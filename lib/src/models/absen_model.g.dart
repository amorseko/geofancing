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
      jam_absen: json['jam_absen'] as String,
      koordinat: json['koordinat'] as String,
      stt_absen: json['stt_absen'] as String,
      tanggal: json['tanggal'] as String);
}

Map<String, dynamic> _$AbsenTodayDataToJson(AbsenTodayData instance) =>
    <String, dynamic>{
      'jam_absen': instance.jam_absen,
      'koordinat': instance.koordinat,
      'stt_absen': instance.stt_absen,
      'tanggal': instance.tanggal
    };
