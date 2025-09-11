import 'dart:convert';

import 'package:collection/collection.dart';

class Attribute {
  final String attributeNameEn;
  final String componentCode;
  final String attributeValueName;

  const Attribute({
    required this.attributeNameEn,
    required this.componentCode,
    required this.attributeValueName,
  });

  @override
  String toString() {
    return 'Attribute(attributeNameEn: $attributeNameEn, componentCode: $componentCode, attributeValueName: $attributeValueName)';
  }

  factory Attribute.fromMap(Map<String, dynamic> data) => Attribute(
        attributeNameEn: data['attribute_name_en'] as String,
        componentCode: data['component_code'] as String,
        attributeValueName: data['attribute_value_name'] as String,
      );

  Map<String, dynamic> toMap() => {
        'attribute_name_en': attributeNameEn,
        'component_code': componentCode,
        'attribute_value_name': attributeValueName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Attribute].
  factory Attribute.fromJson(String data) {
    return Attribute.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Attribute] to a JSON string.
  String toJson() => json.encode(toMap());

  Attribute copyWith({
    String? attributeNameEn,
    String? componentCode,
    String? attributeValueName,
  }) {
    return Attribute(
      attributeNameEn: attributeNameEn ?? this.attributeNameEn,
      componentCode: componentCode ?? this.componentCode,
      attributeValueName: attributeValueName ?? this.attributeValueName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Attribute) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      attributeNameEn.hashCode ^
      componentCode.hashCode ^
      attributeValueName.hashCode;
}
