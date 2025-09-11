// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package

import 'package:capricorn/src/controllers/jlc_controller.dart';
import 'package:capricorn/src/log/app_logger.dart';
import 'package:capricorn/src/constants/app_styles.dart';
import 'package:capricorn/src/models/bom_item.dart';
import 'package:flutter/material.dart';

class BomCostWidget extends StatefulWidget {
  final List<BomItem> bom;

  const BomCostWidget({
    required this.bom,
    super.key,
  });

  @override
  State<BomCostWidget> createState() => _BomCostWidgetState();
}

class _BomCostWidgetState extends State<BomCostWidget> {
  final logger = AppLogger.getLogger();
  late List<BomItem> bom;

  @override
  void initState() {
    bom = widget.bom;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    JlcController jlcController = JlcController.instance();

    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
      child: Table(
        border: TableBorder.all(),
        // columnWidths: const <int, TableColumnWidth>{
        //   0: IntrinsicColumnWidth(),
        //   1: FlexColumnWidth(),
        //   2: FixedColumnWidth(64),
        // },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const <int, TableColumnWidth>{
          0: FractionColumnWidth(.25),
          1: FractionColumnWidth(.75),
        },

        children: <TableRow>[
          TableRow(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text("Unique Part Count:"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(jlcController.uniquePartCount.toString()),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text("Total Part Count:"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(jlcController.totalPartCount.toString()),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text("Highest Cost Part: "),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(
                    "${jlcController.highPrice.lcsc} @ ${jlcController.highPrice.cost}"),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text("Lowest Cost Part:"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(
                    "${jlcController.lowPrice.lcsc} @ ${jlcController.lowPrice.cost}"),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text("Total Cost:"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(jlcController.totalCost.toStringAsFixed(2)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
