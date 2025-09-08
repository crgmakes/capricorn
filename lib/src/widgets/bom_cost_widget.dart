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

    return Card(
      shape: AppStyles.styleBoarderCard,
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Unique Part Count: ${jlcController.uniquePartCount}"),
            Text("Total Part Count: ${jlcController.totalPartCount}"),
            Text(
                "Highest Cost Part: ${jlcController.highPrice.lcsc} @ ${jlcController.highPrice.cost}"),
            Text(
                "Lowest Cost Part: ${jlcController.lowPrice.lcsc} @ ${jlcController.lowPrice.cost}"),
            Text("Total Cost: \$${jlcController.totalCost.toStringAsFixed(2)}"),
          ],
        )),
      ),
    );
  }
}
