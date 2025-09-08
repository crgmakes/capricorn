// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package

import 'package:capricorn/src/log/app_logger.dart';
import 'package:capricorn/src/models/bom_data_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:capricorn/src/constants/app_styles.dart';
import 'package:capricorn/src/models/bom_item.dart';
import 'package:flutter/material.dart';

class BomTableWidget extends StatefulWidget {
  final List<BomItem> bom;

  const BomTableWidget({
    required this.bom,
    super.key,
  });

  @override
  State<BomTableWidget> createState() => _BomTableWidgetState();
}

class _BomTableWidgetState extends State<BomTableWidget> {
  final logger = AppLogger.getLogger();
  final ScrollController _hscrollController = ScrollController();
  final ScrollController _vscrollController = ScrollController();
  late List<BomItem> bom;
  late BomDataSource bomData;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  bool _initialized = false;

  @override
  void initState() {
    bom = widget.bom;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      //final currentRouteOption = getCurrentRouteOption(context);
      bomData = BomDataSource(
        context,
        bom,
        false,
        false,
        false,
        true,
      );
      _initialized = true;
      bomData.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    bomData.dispose();
    super.dispose();
  }

  void _sort<T>(
    Comparable<T> Function(BomItem d) getField,
    int columnIndex,
    bool ascending,
  ) {
    bomData.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: AppStyles.styleBoarderCard,
      margin: const EdgeInsets.fromLTRB(50, 10, 50, 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 300,
          child: DataTable2(
            scrollController: _vscrollController,
            horizontalScrollController: _hscrollController,
            headingRowColor:
                WidgetStateColor.resolveWith((states) => Colors.grey[850]!),
            headingTextStyle: const TextStyle(color: Colors.white),
            dividerThickness: 1,
            isVerticalScrollBarVisible: true,
            columnSpacing: 5,
            horizontalMargin: 5,
            minWidth: 600,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            sortArrowIcon: Icons.keyboard_arrow_up,
            sortArrowAnimationDuration: const Duration(milliseconds: 500),
            sortArrowIconColor: Colors.white,
            columns: [
              DataColumn2(
                label: Text("Comment"),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.comment, columnIndex, ascending),
              ),
              DataColumn2(
                label: Text("LCSC"),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.comment, columnIndex, ascending),
              ),
              DataColumn2(
                label: Text("Quantity"),
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.quantity, columnIndex, ascending),
              ),
              DataColumn2(
                label: Text("Cost/Each"),
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.cost, columnIndex, ascending),
              ),
              DataColumn2(
                label: Text("Ext Cost"),
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.extcost, columnIndex, ascending),
              ),
              DataColumn2(
                label: Text("Designator"),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.designator, columnIndex, ascending),
              ),
              DataColumn2(
                label: Text("Footprint"),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.footprint, columnIndex, ascending),
              ),
            ],
            rows: List<DataRow>.generate(
              bomData.rowCount,
              (index) => bomData.getRow(index),
            ),
          ),
        ),
      ),
    );
  }
}
