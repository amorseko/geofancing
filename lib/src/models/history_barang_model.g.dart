// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_barang_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryBarangModels _$HistoryBarangModelsFromJson(Map<String, dynamic> json) {
  return HistoryBarangModels(
    status: json['status'] as String,
    error: json['error'] as bool,
    message: json['message'] as String,
    data: (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : HistoryBarangData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$HistoryBarangModelsToJson(
        HistoryBarangModels instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

HistoryBarangData _$HistoryBarangDataFromJson(Map<String, dynamic> json) {
  return HistoryBarangData(
    npb: json['npb'] as String,
    tgl_transaksi_in: json['tgl_transaksi_in'] as String,
    jenis_part: json['jenis_part'] as String,
    nama_dealer: json['nama_dealer'] as String,
    keterangan: json['keterangan'] as String,
  );
}

Map<String, dynamic> _$HistoryBarangDataToJson(HistoryBarangData instance) =>
    <String, dynamic>{
      'npb': instance.npb,
      'tgl_transaksi_in': instance.tgl_transaksi_in,
      'jenis_part': instance.jenis_part,
      'nama_dealer': instance.nama_dealer,
      'keterangan': instance.keterangan,
    };
