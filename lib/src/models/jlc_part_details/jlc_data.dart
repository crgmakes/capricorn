import 'dart:convert';

import 'package:collection/collection.dart';

import 'attribute.dart';
import 'price.dart';

class JlcData {
  final String componentCode;
  final String componentBrandEn;
  final String componentModelEn;
  final String dataManualUrl;
  final String componentName;
  final String componentNameEn;
  final String componentSpecificationEn;
  final String describe;
  final String firstSortName;
  final List<Attribute> attributes;
  final int rohsFlag;
  final List<Price> prices;
  final String lcscGoodsUrl;
  final int minPurchaseNum;
  final double initialPrice;

  const JlcData(
    this.componentCode,
    this.componentBrandEn,
    this.componentModelEn,
    this.dataManualUrl,
    this.componentName,
    this.componentNameEn,
    this.componentSpecificationEn,
    this.describe,
    this.firstSortName,
    this.attributes,
    this.rohsFlag,
    this.prices,
    this.lcscGoodsUrl,
    this.minPurchaseNum,
    this.initialPrice,
  );

  @override
  String toString() {
    return 'Data(componentCode: $componentCode, componentBrandEn: $componentBrandEn, componentModelEn: $componentModelEn, dataManualUrl: $dataManualUrl, componentName: $componentName, componentNameEn: $componentNameEn, componentSpecificationEn: $componentSpecificationEn, describe: $describe, attributes: $attributes, rohsFlag: $rohsFlag, lcscGoodsUrl: $lcscGoodsUrl, minPurchaseNum: $minPurchaseNum, initialPrice: $initialPrice )';
  }

  factory JlcData.fromMap(Map<String, dynamic> data) => JlcData(
        data['componentCode'] as String,
        data['componentBrandEn'] as String,
        data['componentModelEn'] as String,
        data['dataManualUrl'] as String,
        data['componentName'] as String,
        data['componentNameEn'] as String,
        data['componentSpecificationEn'] as String,
        data['describe'] as String,
        data['firstSortName'] as String,
        (data['attributes'] as List<dynamic>)
            .map((e) => Attribute.fromMap(e as Map<String, dynamic>))
            .toList(),
        data['rohsFlag'] as int,
        (data['prices'] as List<dynamic>)
            .map((e) => Price.fromMap(e as Map<String, dynamic>))
            .toList(),
        data['lcscGoodsUrl'] as String,
        data['minPurchaseNum'] as int,
        (data['initialPrice'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'componentCode': componentCode,
        'componentBrandEn': componentBrandEn,
        'componentModelEn': componentModelEn,
        'dataManualUrl': dataManualUrl,
        'componentName': componentName,
        'componentNameEn': componentNameEn,
        'componentSpecificationEn': componentSpecificationEn,
        'describe': describe,
        'firstSortName': firstSortName,
        'attributes': attributes.map((e) => e.toMap()).toList(),
        'rohsFlag': rohsFlag,
        'prices': prices.map((e) => e.toMap()).toList(),
        'minPurchaseNum': minPurchaseNum,
        'initialPrice': initialPrice,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory JlcData.fromJson(String data) {
    return JlcData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! JlcData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      componentCode.hashCode ^
      componentBrandEn.hashCode ^
      componentModelEn.hashCode ^
      dataManualUrl.hashCode ^
      componentName.hashCode ^
      componentNameEn.hashCode ^
      componentSpecificationEn.hashCode ^
      describe.hashCode ^
      firstSortName.hashCode ^
      attributes.hashCode ^
      rohsFlag.hashCode ^
      prices.hashCode ^
      lcscGoodsUrl.hashCode ^
      minPurchaseNum.hashCode ^
      initialPrice.hashCode;
}
