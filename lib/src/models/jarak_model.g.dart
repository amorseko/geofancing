// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jarak_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JarakModels _$JarakModelsFromJson(Map<String, dynamic> json) {
  return JarakModels(
    code: json['code'] as int,
    status: json['status'] as bool,
    message: json['message'] as String,
    data: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : _Data.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$JarakModelsToJson(JarakModels instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_Data _$_DataFromJson(Map<String, dynamic> json) {
  return _Data(
    jarak: json['jarak'] as int,
  );
}

Map<String, dynamic> _$_DataToJson(_Data instance) => <String, dynamic>{
      'jarak': instance.jarak,
    };
