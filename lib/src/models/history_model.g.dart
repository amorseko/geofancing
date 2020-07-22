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
          ?.map((e) => e == null
              ? null
              : HistoryData.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$HistoryModelsToJson(HistoryModels instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data
    };

HistoryData _$HistoryDataFromJson(Map<String, dynamic> json) {
  return HistoryData(
      jam_masuk: json['jam_masuk'] as String,
      jam_pulang: json['jam_pulang'] as String,
      titik_absen: json['titik_absen'] as String,
      titik_pulang: json['titik_pulang'] as String,
      tanggal: json['tanggal'] as String);
}

Map<String, dynamic> _$HistoryDataToJson(HistoryData instance) =>
    <String, dynamic>{
      'jam_masuk': instance.jam_masuk,
      'jam_pulang': instance.jam_pulang,
      'titik_absen': instance.titik_absen,
      'titik_pulang': instance.titik_pulang,
      'tanggal': instance.tanggal
    };
