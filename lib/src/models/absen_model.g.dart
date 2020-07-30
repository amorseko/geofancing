// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbsenModels _$AbsenModelsFromJson(Map<String, dynamic> json) {
  return AbsenModels(
      status: json['status'] as String,
      error: json['error'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : AbsenTodayData.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$AbsenModelsToJson(AbsenModels instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data
    };

AbsenTodayData _$AbsenTodayDataFromJson(Map<String, dynamic> json) {
  return AbsenTodayData(
      absen_masuk: json['absen_masuk'] as String,
      absen_keluar: json['absen_keluar'] as String,
      koordinat_masuk: json['koordinat_masuk'] as String,
      koordinat_keluar: json['koordinat_keluar'] as String,
      stt_absen: json['stt_absen'] as String,
      tanggal: json['tanggal'] as String);
}

Map<String, dynamic> _$AbsenTodayDataToJson(AbsenTodayData instance) =>
    <String, dynamic>{
      'absen_masuk': instance.absen_masuk,
      'absen_keluar': instance.absen_keluar,
      'koordinat_masuk': instance.koordinat_masuk,
      'koordinat_keluar': instance.koordinat_keluar,
      'stt_absen': instance.stt_absen,
      'tanggal': instance.tanggal
    };
