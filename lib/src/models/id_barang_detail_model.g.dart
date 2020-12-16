// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_barang_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IDBarangModels _$IDBarangModelsFromJson(Map<String, dynamic> json) {
  return IDBarangModels(
      status: json['status'] as String,
      error: json['error'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : _Data.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$IDBarangModelsToJson(IDBarangModels instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data
    };

_Data _$_DataFromJson(Map<String, dynamic> json) {
  return _Data(id_permintaan_barang: json['id_permintaan_barang'] as String);
}

Map<String, dynamic> _$_DataToJson(_Data instance) =>
    <String, dynamic>{'id_permintaan_barang': instance.id_permintaan_barang};
