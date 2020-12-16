// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_barang_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetListNamaBarangModels _$GetListNamaBarangModelsFromJson(
    Map<String, dynamic> json) {
  return GetListNamaBarangModels(
      message: json['message'] as String,
      status: json['status'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : _Data.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      error: json['error'] as bool);
}

Map<String, dynamic> _$GetListNamaBarangModelsToJson(
        GetListNamaBarangModels instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'error': instance.error,
      'data': instance.data
    };

_Data _$_DataFromJson(Map<String, dynamic> json) {
  return _Data(
      id_barang: json['id_barang'] as String,
      nama_parts: json['nama_parts'] as String,
      satuan: json['satuan'] as String);
}

Map<String, dynamic> _$_DataToJson(_Data instance) => <String, dynamic>{
      'id_barang': instance.id_barang,
      'nama_parts': instance.nama_parts,
      'satuan': instance.satuan
    };
