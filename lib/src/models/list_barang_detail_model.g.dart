// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_barang_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetListBarangDetailModels _$GetListBarangDetailModelsFromJson(
    Map<String, dynamic> json) {
  return GetListBarangDetailModels(
      message: json['message'] as String,
      status: json['status'] as String,
      data: (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : GetListBarangDetailData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      error: json['error'] as bool);
}

Map<String, dynamic> _$GetListBarangDetailModelsToJson(
        GetListBarangDetailModels instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'error': instance.error,
      'data': instance.data
    };

GetListBarangDetailData _$GetListBarangDetailDataFromJson(
    Map<String, dynamic> json) {
  return GetListBarangDetailData(
      id_permintaan_brg: json['id_permintaan_brg'] as String,
      jenis_part: json['jenis_part'] as String,
      kode_part: json['kode_part'] as String,
      nama_parts: json['nama_parts'] as String,
      nama_satuan: json['nama_satuan'] as String,
      id_barang: json['id_barang'] as String,
      id_dpb: json['id_dpb'] as String);
}

Map<String, dynamic> _$GetListBarangDetailDataToJson(
        GetListBarangDetailData instance) =>
    <String, dynamic>{
      'id_permintaan_brg': instance.id_permintaan_brg,
      'jenis_part': instance.jenis_part,
      'kode_part': instance.kode_part,
      'nama_parts': instance.nama_parts,
      'nama_satuan': instance.nama_satuan,
      'id_barang': instance.id_barang,
      'id_dpb': instance.id_dpb
    };
