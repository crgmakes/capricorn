import 'dart:collection';
import 'dart:io';

import 'package:capricorn/src/log/app_logger.dart';
import 'package:capricorn/src/models/bom_item.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:csv/csv.dart';

class CsvController {
  final logger = AppLogger.getLogger();

  bool parsedHeader = false;
  bool foundLcsc = false;
  bool processedBom = false;

  int commentCol = -1;
  int designatorCol = -1;
  int footprintCol = -1;
  int lcscCol = -1;

  List<BomItem> bom = [];

  static CsvController controller = CsvController();

  static CsvController instance() {
    return controller;
  }

  Future<bool> parseCsv(PlatformFile file) async {
    try {
      bom.clear();

      String filePath = file.path!;
      const FirstOccurrenceSettingsDetector det =
          FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);

      final input = File(filePath).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter(csvSettingsDetector: det))
          .toList();

      logger.t("processed fields.length: ${fields.length}");
      logger.t("processed first.length: ${fields.first.length}");

      if (fields.isNotEmpty) {
        logger.d("we have ${fields.length} rows");

        if (parseHeader(fields.first) == false) {
          logger.e("Failed to parse header");
          return processedBom;
        } else {
          parsedHeader = true;
        }

        int rowc = fields.length;

        // start at 1 since first row is comment
        for (int i = 1; i < rowc; i++) {
          BomItem j = parseRow(fields[i]);
          if (j.quantity > 0) {
            bom.add(j);
          } else {
            logger.w("skipping row '${j.comment}'");
          }
        } // end for
        logger.d("bom size=${bom.length}");
        processedBom = true;
      } else {
        logger.e("file appears to be blank - field length is zero");
      }
    } on Exception catch (e) {
      logger.f("error parsing: $e");
    }

    return processedBom;
  }

  bool parseHeader(List<dynamic> row) {
    int l = row.length;

    for (int i = 0; i < l; i++) {
      logger.d("c[$i]=${row[i]}");

      if (row[i].toString().toLowerCase() == "comment") {
        commentCol = i;
      } else if (row[i].toString().toLowerCase() == "footprint") {
        footprintCol = i;
      } else if (row[i].toString().toLowerCase() == "designator") {
        designatorCol = i;
      } else if (row[i].toString().toLowerCase() == "lcsc") {
        lcscCol = i;
        foundLcsc = true;
      }
    } // end for

    // return true if we found all the elements
    if ((commentCol == -1 ||
        footprintCol == -1 ||
        designatorCol == -1 ||
        lcscCol == -1)) {
      return false;
    } else {
      return true;
    }
  }

  BomItem parseRow(List<dynamic> list) {
    BomItem j = BomItem();

    if (list.isEmpty) {
      logger.e("list is empty");
    } else {
      j.comment = list[commentCol].toString();
      j.footprint = list[footprintCol].toString();
      j.designator = list[designatorCol].toString();
      j.lcsc = list[lcscCol].toString();
      j.quantity = 1;

      for (int i = 0; i < j.designator.length; i++) {
        if (j.designator[i] == ",") {
          j.quantity++;
        }
      }
    }

    return j;
  } // end parseRow
} // end class
