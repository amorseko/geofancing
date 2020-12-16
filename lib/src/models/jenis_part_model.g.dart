// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jenis_part_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetListJenisPartModels _$GetListJenisPartModelsFromJson(
    Map<String, dynamic> json) {
  return GetListJenisPartModels(
      message: json['message'] as String,
      status: json['status'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : _Data.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      error: json['error'] as bool);
}

Map<String, dynamic> _$GetListJenisPartModelsToJson(
        GetListJenisPartModels instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'error': instance.error,
      'data': instance.data
    };

_Data _$_DataFromJson(Map<String, dynamic> json) {
  return _Data(
      id_jenis_part: json['id_jenis_part'] as String,
      jenis_part: json['jenis_part'] as String);
}

Map<String, dynamic> _$_DataToJson(_Data instance) => <String, dynamic>{
      'id_jenis_part': instance.id_jenis_part,
      'jenis_part': instance.jenis_part
    };
