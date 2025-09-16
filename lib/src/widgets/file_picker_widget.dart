// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package

import 'package:capricorn/src/constants/app_styles.dart';
import 'package:capricorn/src/controllers/csv_controller.dart';
import 'package:capricorn/src/controllers/jlc_controller.dart';
import 'package:capricorn/src/log/app_logger.dart';
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

  // final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  List<PlatformFile>? pickedFiles;

  PlatformFile? chosenFile;
  String? lastDirectory;
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
            chosenFile = null;
            showErrorMessage("Invalid file extension!");
          }
        } else {
          state = AppState.select;
          error = ErrorState.error;
          chosenFile = null;
          showErrorMessage("File extension not known!");
        }
        setState(() {});
      } else {
        state = AppState.select;
        error = ErrorState.warn;
        chosenFile = null;
        logger.i("selection canceled");
        showWarningMessage("Selection Canceled!");
        setState(() {});
      }
    } on PlatformException catch (e) {
      logger.e("platform error: $e");
      state = AppState.select;
      error = ErrorState.fatal;
      chosenFile = null;
      showErrorMessage("Unsupported operation on platform!");
    } catch (e) {
      state = AppState.select;
      error = ErrorState.fatal;
      chosenFile = null;
      showErrorMessage("Critical error within application: $e");
    }
  }

  ///
  /// Resets the file indicator and controllers
  ///
  void resetFile() {
    state = AppState.select;
    error = ErrorState.none;
    chosenFile = null;
    CsvController.instance().reset();
    setState(() {});
  }

  ///
  /// Processes selected file
  ///
  void processFile() async {
    logger.t("BEGIN");

    if (chosenFile == null) {
      state = AppState.select;
      error = ErrorState.error;
      showErrorMessage("No file selected!");
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
        showErrorMessage("Error getting prices.");
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
        showErrorMessage("Unable to parse header!");
      } else if (csvController.foundLcsc == false) {
        state = AppState.processed;
        error = ErrorState.error;
        showErrorMessage("Unable to find LCSC column in BOM!");
      } else {
        state = AppState.processed;
        error = ErrorState.error;
        showErrorMessage("Unable to parse file!");
      }
    }
    setState(() {});

    logger.t("END");
  }

  ///
  /// Exports file after processing
  ///
  void saveFile() async {
    String name = chosenFile!.name;
    int i = name.indexOf('.');
    if (i != -1) {
      name = "${name.substring(0, i)}-cost${name.substring(i)}";
    }

    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      initialDirectory: chosenFile!.path,
      fileName: name,
    );

    if (outputFile != null) {
      logger.d("file name: $outputFile");
      CsvController controller = CsvController.instance();
      bool b = controller.saveFile(outputFile);
      if (b) {
        error = ErrorState.info;
        showInfoMessage("Exported File!");
      }
    } else {
      logger.w("user canceled");
      error = ErrorState.warn;
      showWarningMessage("Canceled file selection!");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // key: _scaffoldMessengerKey,
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
        Visibility(
          visible: (state == AppState.processed),
          child: SizedBox(
            width: 125,
            height: 50,
            child: FloatingActionButton.extended(
              onPressed: () => saveFile(),
              label: Text("Export"),
              icon: const Icon(Icons.upload),
            ),
          ),
        ),
      ],
    );
  }

  void showInfoMessage(String message) {
    postMessage(
      Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  void showWarningMessage(String message) {
    postMessage(
      Text(
        message,
        style: TextStyle(
          color: Colors.orange.shade600,
        ),
      ),
    );
  }

  void showErrorMessage(String message) {
    postMessage(
      Text(
        message,
        style: const TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }

  void postMessage(Text text) {
    logger.d(text.data);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: text,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.purple.shade900,
      ),
    );
  }
}
