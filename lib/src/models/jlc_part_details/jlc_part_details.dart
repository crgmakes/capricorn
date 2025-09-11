import 'dart:convert';
import 'jlc_data.dart';
import 'package:collection/collection.dart';

class JlcPartDetails {
  final int code;
  final JlcData data;
  final String message;

  const JlcPartDetails(this.code, this.data, this.message);

  @override
  String toString() {
    return 'JlcPartDetails(code: $code, data: $data, message: $message)';
  }

  factory JlcPartDetails.fromMap(Map<String, dynamic> data) {
    return JlcPartDetails(
      data['code'] as int,
      data['data'] = JlcData.fromMap(data['data'] as Map<String, dynamic>),
      data['message'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'code': code,
        'data': data.toMap(),
        'message': message,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [JlcPartDetails].
  factory JlcPartDetails.fromJson(String data) {
    return JlcPartDetails.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [JlcPartDetails] to a JSON string.
  String toJson() => json.encode(toMap());

  JlcPartDetails copyWith({
    int? code,
    JlcData? data,
    dynamic message,
  }) {
    return JlcPartDetails(
      code ?? this.code,
      data ?? this.data,
      message ?? this.message,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! JlcPartDetails) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => code.hashCode ^ data.hashCode ^ message.hashCode;
}
