import 'package:capricorn/src/models/jlc_part_details/jlc_part_details.dart';

class BomItem {
  String comment = '';
  String designator = '';
  String footprint = '';
  String lcsc = '';
  int quantity = 0;
  double unitCost = 0.0;
  double cost = 0.0;
  double extcost = 0.0;
  bool selected = false;
  JlcPartDetails? details;
}
