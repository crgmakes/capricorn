import 'dart:convert';

import 'package:collection/collection.dart';

class Price {
  final String? componentCode;
  final int startNumber;
  final int endNumber;
  final double productPrice;

  const Price(
    this.componentCode,
    this.startNumber,
    this.endNumber,
    this.productPrice,
  );

  @override
  String toString() {
    return 'Price(componentCode: $componentCode, startNumber: $startNumber, endNumber: $endNumber, productPrice: $productPrice)';
  }

  factory Price.fromMap(Map<String, dynamic> data) => Price(
        data['componentCode'] as String,
        data['startNumber'] as int,
        data['endNumber'] as int,
        (data['productPrice'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'componentCode': componentCode,
        'startNumber': startNumber,
        'endNumber': endNumber,
        'productPrice': productPrice,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Price].
  factory Price.fromJson(String data) {
    return Price.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Price] to a JSON string.
  String toJson() => json.encode(toMap());

  Price copyWith(
    String componentCode,
    int startNumber,
    int endNumber,
    double productPrice,
  ) {
    return Price(
      componentCode,
      startNumber,
      endNumber,
      productPrice,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Price) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      componentCode.hashCode ^
      startNumber.hashCode ^
      endNumber.hashCode ^
      productPrice.hashCode;
}
