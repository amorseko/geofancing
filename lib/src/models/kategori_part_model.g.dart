// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kategori_part_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetListKategoriPartModels _$GetListKategoriPartModelsFromJson(
    Map<String, dynamic> json) {
  return GetListKategoriPartModels(
    message: json['message'] as String,
    status: json['status'] as String,
    data: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : _Data.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    error: json['error'] as bool,
  );
}

Map<String, dynamic> _$GetListKategoriPartModelsToJson(
        GetListKategoriPartModels instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'error': instance.error,
      'data': instance.data,
    };

_Data _$_DataFromJson(Map<String, dynamic> json) {
  return _Data(
    id_kategori_part: json['id_kategori_part'] as String,
    nama_kategori_part: json['nama_kategori_part'] as String,
  );
}

Map<String, dynamic> _$_DataToJson(_Data instance) => <String, dynamic>{
      'id_kategori_part': instance.id_kategori_part,
      'nama_kategori_part': instance.nama_kategori_part,
    };
