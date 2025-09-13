// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package

import 'package:capricorn/src/constants/app_styles.dart';
import 'package:capricorn/src/controllers/csv_controller.dart';
import 'package:capricorn/src/controllers/jlc_controller.dart';
import 'package:capricorn/src/log/app_logger.dart';
import 'package:capricorn/src/models/bom_item.dart';
import 'package:capricorn/src/widgets/bom_cost_widget.dart';
import 'package:capricorn/src/widgets/bom_table_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppState { select, selected, processing, processed }

enum ErrorState { none, info, warn, error, fatal }

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
  // List<BomItem> bom = [];
  Widget dataTable = Container();
  AppState state = AppState.select;
  ErrorState error = ErrorState.none;
  double progress = 0.0;

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
            state = AppState.selected;
            error = ErrorState.none;
          } else {
            state = AppState.select;
            error = ErrorState.error;
            errorMessage = "Invalid file extension!";
            chosenFile = null;
          }
        } else {
          state = AppState.select;
          error = ErrorState.error;
          errorMessage = "File extension not known!";
          chosenFile = null;
        }
        setState(() {});
      } else {
        state = AppState.select;
        error = ErrorState.warn;
        errorMessage = "Selection Canceled!";
        chosenFile = null;
        logger.i("selection canceled");
        setState(() {});
      }
    } on PlatformException catch (e) {
      state = AppState.select;
      error = ErrorState.fatal;
      errorMessage = "Unsupported operation on platform!";
      chosenFile = null;
      _logException('Unsupported operation: $e');
    } catch (e) {
      state = AppState.select;
      error = ErrorState.fatal;
      errorMessage = "Critical error within application: $e";
      chosenFile = null;
      _logException(e.toString());
    }
  }

  void resetFile() {
    state = AppState.select;
    error = ErrorState.none;
    chosenFile = null;
    CsvController.instance().reset();
    setState(() {});
  }

  void processFile() async {
    logger.t("BEGIN");

    if (chosenFile == null) {
      state = AppState.select;
      error = ErrorState.error;
      errorMessage = "No file selected!";
      logger.e("chosen file is null");
      return;
    }

    void setProgress(double d) {
      progress = d;
      setState(() {});
    }

    CsvController csvController = CsvController.instance();
    JlcController jlcController = JlcController.instance();

    setState(() {
      csvController.reset();
      state = AppState.processing;
    });
    bool b = await csvController.parseCsv(chosenFile!);
    if (b) {
      b = await jlcController.getPrices(csvController.bom, setProgress);
      if (!b) {
        state = AppState.processed;
        error = ErrorState.error;
        errorMessage = "Error getting prices.";
      } else {
        state = AppState.processed;
        error = ErrorState.none;

        dataTable = BomTableWidget(bom: csvController.bom);
        // setState(() {});
      }
    } else {
      if (csvController.parsedHeader == false) {
        state = AppState.processed;
        error = ErrorState.error;
        errorMessage = "Unable to parse header!";
      } else if (csvController.foundLcsc == false) {
        state = AppState.processed;
        error = ErrorState.error;
        errorMessage = "Unable to find LCSC column in BOM!";
      } else {
        state = AppState.processed;
        error = ErrorState.error;
        errorMessage = "Unable to parse file!";
      }
    }
    setState(() {});

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
                Visibility(
                  visible: (state == AppState.select),
                  child: Row(
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
                ),
                Visibility(
                  visible: (state != AppState.select),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: FloatingActionButton.extended(
                          onPressed: () => resetFile(),
                          label: const Text('Reset'),
                          icon: const Icon(Icons.restore),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      SizedBox(
                        width: 125,
                        height: 50,
                        child: FloatingActionButton.extended(
                          onPressed: () => processFile(),
                          label: Text((state == AppState.processed)
                              ? "Reprocess"
                              : "Process"),
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
                ),
                Visibility(
                  visible: (error != ErrorState.none),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: [
                        Text(
                          errorMessage,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: (error == ErrorState.info)
                                ? Colors.black
                                : (error == ErrorState.warn)
                                    ? Colors.amber.shade700
                                    : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
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
          visible: (state == AppState.processing),
          child: Column(
            children: [
              CircularProgressIndicator(
                value: progress,
              ),
              Text("${(progress * 100).toStringAsFixed(0)}%")
            ],
          ),
        ),
        Visibility(
          visible: (state == AppState.processed),
          child: dataTable,
        ),
        Visibility(
          visible: (state == AppState.processed),
          child: BomCostWidget(bom: CsvController.instance().bom),
        ),
      ],
    );
  }

  void printInDebug(Object object) => debugPrint(object.toString());
}
