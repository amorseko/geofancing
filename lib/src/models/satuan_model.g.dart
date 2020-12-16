// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'satuan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSatuanModels _$GetSatuanModelsFromJson(Map<String, dynamic> json) {
  return GetSatuanModels(
      message: json['message'] as String,
      status: json['status'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : _Data.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      error: json['error'] as bool);
}

Map<String, dynamic> _$GetSatuanModelsToJson(GetSatuanModels instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'error': instance.error,
      'data': instance.data
    };

_Data _$_DataFromJson(Map<String, dynamic> json) {
  return _Data(
      id_satuan: json['id_satuan'] as String,
      nama_satuan: json['nama_satuan'] as String);
}

Map<String, dynamic> _$_DataToJson(_Data instance) => <String, dynamic>{
      'id_satuan': instance.id_satuan,
      'nama_satuan': instance.nama_satuan
    };
