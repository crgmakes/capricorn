// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package

import 'package:capricorn/src/constants/app_styles.dart';
import 'package:capricorn/src/controllers/jlc_controller.dart';
import 'package:capricorn/src/log/app_logger.dart';
import 'package:capricorn/src/models/bom_item.dart';
import 'package:capricorn/src/widgets/bom_table_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key});

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  final logger = AppLogger.getLogger();

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  List<PlatformFile>? pickedFiles;

  PlatformFile? chosenFile;
  String? lastDirectory;
  String errorMessage = "";
  // List<List<dynamic>> _data = [];
  List<BomItem> bom = [];
  Widget dataTable = Container();

  @override
  void initState() {
    super.initState();
  }

  void _pickFiles() async {
    try {
      // _data.clear();

      FilePickerResult? rs = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => setState(() {}),
        allowedExtensions: ["txt", "csv"],
        dialogTitle: "Select File",
        initialDirectory: lastDirectory,
        withData: true,
      );

      if (rs != null) {
        PlatformFile f = rs.files.first;
        String? ext = f.extension;
        if (ext != null) {
          if (ext == "txt" || ext == "csv") {
            chosenFile = f;
            lastDirectory = f.path;
            errorMessage = "";
          } else {
            errorMessage = "Invalid file extension!";
            chosenFile = null;
          }
        } else {
          errorMessage = "File extension not known!";
          chosenFile = null;
        }
        setState(() {});
      } else {
        chosenFile = null;
        errorMessage = "Selection Canceled!";
        logger.i("selection canceled");
        setState(() {});
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation: $e');
    } catch (e) {
      _logException(e.toString());
    }
  }

  void processFile() async {
    logger.t("BEGIN");

    if (chosenFile == null) {
      errorMessage = "No file selected!";
      logger.e("chosen file is null");
      return;
    }

    JlcController controller = JlcController.instance();

    bool b = await controller.parseCsv(chosenFile!);
    if (b) {
    } else {
      if (controller.parsedHeader == false) {
        errorMessage = "Unable to parse header!";
      } else if (controller.foundLcsc == false) {
        errorMessage = "Unable to find LCSC column in BOM!";
      } else {
        errorMessage = "Unable to parse file!";
      }
    }
    setState(() {
      bom.clear();
      bom.addAll(controller.bom);
      dataTable = BomTableWidget(bom: bom);
    });

    logger.t("END");
  }

  void _logException(String message) {
    logger.e(message);

    printInDebug(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          shape: AppStyles.styleBoarderCard,
          margin: const EdgeInsets.fromLTRB(50, 20, 50, 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Select File:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      width: 80,
                      height: 50,
                      child: FloatingActionButton.extended(
                        onPressed: () => _pickFiles(),
                        label: const Icon(Icons.description),
                        //icon: const Icon(Icons.description),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: (chosenFile != null),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: FloatingActionButton.extended(
                              onPressed: () => processFile(),
                              label: const Text('Process'),
                              icon: const Icon(Icons.save_as),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '${chosenFile?.name}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: (errorMessage.isNotEmpty),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        errorMessage,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10.0,
                      // ),
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 10.0,
                // ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: bom.isNotEmpty,
          child: dataTable,
        ),
      ],
    );
  }

  void printInDebug(Object object) => debugPrint(object.toString());
}
