import 'package:capricorn/src/models/bom_item.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class BomDataSource extends DataTableSource {
  final BuildContext context;
  late List<BomItem> items;
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  BomDataSource.empty(this.context) {
    items = [];
  }

  BomDataSource(this.context, this.items,
      [sortedByCalories = false,
      this.hasRowTaps = false,
      this.hasRowHeightOverrides = false,
      this.hasZebraStripes = false]) {
    // items = _items;
    // if (sortedByCalories) {
    //   sort((d) => d.calories, true);
    // }
  }

  void sort<T>(Comparable<T> Function(BomItem d) getField, bool ascending) {
    items.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  @override
  DataRow2 getRow(int index, [Color? color]) {
    assert(index >= 0);
    if (index >= items.length) throw 'index > _items.length';
    final item = items[index];
    return DataRow2.byIndex(
      index: index,
      selected: item.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
              ? WidgetStateProperty.all(Theme.of(context).highlightColor)
              : null),
      cells: [
        DataCell(SelectableText(item.category)),
        DataCell(SelectableText(item.mn)),
        DataCell(SelectableText(item.mpn)),
        DataCell(SelectableText(item.description)),
        DataCell(SelectableText(item.comment)),
        DataCell(SelectableText(item.lcsc)),
        DataCell(SelectableText(item.quantity.toString())),
        DataCell(SelectableText(item.cost.toStringAsFixed(4))),
        DataCell(SelectableText(item.extcost.toStringAsFixed(4))),
        DataCell(SelectableText(item.designator)),
      ],
    );
  }

  @override
  int get rowCount => items.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
