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
      // onSelectChanged: (value) {
      //   if (item.selected != value) {
      //     _selectedCount += value! ? 1 : -1;
      //     assert(_selectedCount >= 0);
      //     item.selected = value;
      //     notifyListeners();
      //   }
      // },
      // onTap: hasRowTaps
      //     ? () => _showSnackbar(context, 'Tapped on row ${item.name}')
      //     : null,
      // onDoubleTap: hasRowTaps
      //     ? () => _showSnackbar(context, 'Double Tapped on row ${item.name}')
      //     : null,
      // onLongPress: hasRowTaps
      //     ? () => _showSnackbar(context, 'Long pressed on row ${item.name}')
      //     : null,
      // onSecondaryTap: hasRowTaps
      //     ? () => _showSnackbar(context, 'Right clicked on row ${item.name}')
      //     : null,
      // onSecondaryTapDown: hasRowTaps
      //     ? (d) =>
      //         _showSnackbar(context, 'Right button down on row ${item.name}')
      //     : null,
      // specificRowHeight:
      //     hasRowHeightOverrides && item.fat >= 25 ? 100 : null,

      // cols.add(DataColumn2(label: Text("Comment")));
      // cols.add(DataColumn2(label: Text("LCSC")));
      // cols.add(DataColumn2(label: Text("Quantity")));
      // cols.add(DataColumn2(label: Text("Designator")));
      // cols.add(DataColumn2(label: Text("Footprint")));

      cells: [
        DataCell(Text(item.comment)),
        DataCell(Text(item.lcsc)),
        DataCell(Text(item.quantity.toString())),
        DataCell(Text(item.cost.toStringAsFixed(4))),
        DataCell(Text(item.extcost.toStringAsFixed(4))),
        DataCell(Text(item.designator)),
        // DataCell(Text(item.footprint)),
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
