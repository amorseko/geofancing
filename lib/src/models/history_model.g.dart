// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryModels _$HistoryModelsFromJson(Map<String, dynamic> json) {
  return HistoryModels(
    status: json['status'] as String,
    error: json['error'] as bool,
    message: json['message'] as String,
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : HistoryData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$HistoryModelsToJson(HistoryModels instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

HistoryData _$HistoryDataFromJson(Map<String, dynamic> json) {
  return HistoryData(
    absen_masuk: json['absen_masuk'] as String,
    absen_keluar: json['absen_keluar'] as String,
    koordinat_masuk: json['koordinat_masuk'] as String,
    koordinat_keluar: json['koordinat_keluar'] as String,
    stt_absen: json['stt_absen'] as String,
    tanggal: json['tanggal'] as String,
  );
}

Map<String, dynamic> _$HistoryDataToJson(HistoryData instance) =>
    <String, dynamic>{
      'absen_masuk': instance.absen_masuk,
      'absen_keluar': instance.absen_keluar,
      'koordinat_masuk': instance.koordinat_masuk,
      'koordinat_keluar': instance.koordinat_keluar,
      'stt_absen': instance.stt_absen,
      'tanggal': instance.tanggal,
    };
