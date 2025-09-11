import 'dart:convert';

import 'package:collection/collection.dart';

class ImageList {
  final dynamic productImage;
  final String? productImageAccessId;
  final dynamic productBigImage;
  final String? productBigImageAccessId;
  final int? fileType;

  const ImageList({
    this.productImage,
    this.productImageAccessId,
    this.productBigImage,
    this.productBigImageAccessId,
    this.fileType,
  });

  @override
  String toString() {
    return 'ImageList(productImage: $productImage, productImageAccessId: $productImageAccessId, productBigImage: $productBigImage, productBigImageAccessId: $productBigImageAccessId, fileType: $fileType)';
  }

  factory ImageList.fromMap(Map<String, dynamic> data) => ImageList(
        productImage: data['productImage'] as dynamic,
        productImageAccessId: data['productImageAccessId'] as String?,
        productBigImage: data['productBigImage'] as dynamic,
        productBigImageAccessId: data['productBigImageAccessId'] as String?,
        fileType: data['fileType'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'productImage': productImage,
        'productImageAccessId': productImageAccessId,
        'productBigImage': productBigImage,
        'productBigImageAccessId': productBigImageAccessId,
        'fileType': fileType,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ImageList].
  factory ImageList.fromJson(String data) {
    return ImageList.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ImageList] to a JSON string.
  String toJson() => json.encode(toMap());

  ImageList copyWith({
    dynamic productImage,
    String? productImageAccessId,
    dynamic productBigImage,
    String? productBigImageAccessId,
    int? fileType,
  }) {
    return ImageList(
      productImage: productImage ?? this.productImage,
      productImageAccessId: productImageAccessId ?? this.productImageAccessId,
      productBigImage: productBigImage ?? this.productBigImage,
      productBigImageAccessId:
          productBigImageAccessId ?? this.productBigImageAccessId,
      fileType: fileType ?? this.fileType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ImageList) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      productImage.hashCode ^
      productImageAccessId.hashCode ^
      productBigImage.hashCode ^
      productBigImageAccessId.hashCode ^
      fileType.hashCode;
}
