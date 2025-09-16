import 'package:capricorn/src/log/app_logger.dart';
import 'package:capricorn/src/models/bom_item.dart';
import 'package:capricorn/src/models/jlc_part_details/jlc_data.dart';
import 'package:capricorn/src/models/jlc_part_details/jlc_part_details.dart';
import 'package:capricorn/src/models/jlc_part_details/price.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JlcController {
  final logger = AppLogger.getLogger();
  int uniquePartCount = 0;
  int totalPartCount = 0;
  double totalCost = 0.0;
  late BomItem highPrice;
  late BomItem highQuantity;
  late BomItem lowPrice;
  late BomItem lowQuantity;

  final String baseUrl =
      'https://cart.jlcpcb.com/shoppingCart/smtGood/getComponentDetail?componentCode=';

  static JlcController controller = JlcController();

  static JlcController instance() {
    return controller;
  }

  Future<bool> getPrices(List<BomItem> bom, Function(double d) cb) async {
    bool b = false;
    int processed = 0;
    uniquePartCount = 0;
    totalPartCount = 0;
    totalCost = 0.0;
    double d = 0.0;

    for (int i = 0; i < bom.length; i++) {
      d = i / bom.length;
      cb(d);

      BomItem bi = bom[i];
      if (i == 0) {
        highPrice = bi;
        lowPrice = bi;
        highQuantity = bi;
        lowQuantity = bi;
      }
      if (bi.lcsc.isNotEmpty) {
        uniquePartCount++;
        try {
          final url = Uri.parse(baseUrl + bi.lcsc);
          final response = await http.get(url);

          if (response.statusCode == 200) {
            String s = utf8.decode(response.bodyBytes);
            JlcPartDetails details = JlcPartDetails.fromJson(s);
            if (parse(bi, details.data)) {
              processed++;
            }
          } else {
            // Request failed with an error status code
            logger.e(
                'Request for ${bi.lcsc} failed with status: ${response.statusCode}.');
            break;
          }
        } catch (e, s) {
          // Handle network errors or other exceptions
          logger.f('Error during HTTP request: $e');
          logger.f(s);
        }
      } // end if
    } // end for
    if (processed == bom.length) {
      b = true;
    }
    return b;
  }

  ///
  /// Parse raw JLC data into object
  ///
  bool parse(BomItem bi, JlcData data) {
    bool b = false;

    if (bi.lcsc != data.componentCode) {
      logger.e("data code '${data.componentCode}' <> bom code '${bi.lcsc}'");
      return b;
    }

    bi.data = data;
    bi.category = data.firstSortName;
    bi.mn = data.componentBrandEn;
    bi.mpn = data.componentModelEn;
    bi.description = data.describe;
    // comment taken from CSV file
    // footprint taken from CSV file
    bi.package = data.componentSpecificationEn;
    // lcsc taken from CSV file
    // quantity taken from CSV
    // Compute unit cost
    bi.unitCost = data.initialPrice;
    bi.cost = 0;

    // Build cost
    List<Price> prices = data.prices;
    if (prices.isNotEmpty) {
      for (int i = 0; i < prices.length; i++) {
        Price p = prices[i];
        if (bi.quantity >= p.startNumber && bi.quantity <= p.endNumber) {
          logger.t("quantity: ${bi.quantity} price[$i]: $p");
          bi.cost = p.productPrice;
          break;
        }
      }
    }
    if (bi.cost == 0) {
      logger.e("unable to find price range for ${bi.quantity}");
      bi.cost = bi.unitCost;
    }
    bi.extcost = bi.cost * bi.quantity;
    totalCost += bi.extcost;
    totalPartCount += bi.quantity;
    if (bi.cost > highPrice.cost) {
      highPrice = bi;
    }
    if (bi.cost < lowPrice.cost) {
      lowPrice = bi;
    }
    if (bi.quantity > highQuantity.quantity) {
      highQuantity = bi;
    }
    if (bi.quantity < lowQuantity.quantity) {
      lowQuantity = bi;
    }
    logger.i("jlc price for ${bi.lcsc} = ${bi.cost}");

    b = true;

    return b;
  }
} // end class
