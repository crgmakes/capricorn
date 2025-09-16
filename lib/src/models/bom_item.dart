import 'package:capricorn/src/log/app_logger.dart';
import 'package:capricorn/src/models/jlc_part_details/jlc_data.dart';

class BomItem {
  final logger = AppLogger.getLogger();

  String category = '';
  String mn = '';
  String mpn = '';
  String description = '';
  String comment = '';
  String designator = '';
  String footprint = '';
  String package = '';
  String lcsc = '';
  int quantity = 0;
  double unitCost = 0.0; // cost/item based on quantity of 1
  double cost = 0.0; // cost/item for item based on quantity of items
  double extcost = 0.0;

  bool selected = false;
  late JlcData data;

  static List<dynamic> toHeader() {
    List<dynamic> l = [];
    l.add("category");
    l.add("mn");
    l.add("mpn");
    l.add("description");
    l.add("comment");
    l.add("designator");
    l.add("footprint");
    l.add("package");
    l.add("lcsc");
    l.add("quantity");
    l.add("unitCost");
    l.add("cost");
    l.add("extcost");

    return l;
  }

  List<dynamic> toList() {
    List<dynamic> l = [];
    l.add(category);
    l.add(mn);
    l.add(mpn);
    l.add(description);
    l.add(comment);
    l.add(designator);
    l.add(footprint);
    l.add(package);
    l.add(lcsc);
    l.add(quantity);
    l.add(unitCost);
    l.add(cost);
    l.add(extcost);

    return l;
  }
}
