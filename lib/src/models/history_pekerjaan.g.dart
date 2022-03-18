// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_pekerjaan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryPekerjaanModels _$HistoryPekerjaanModelsFromJson(
    Map<String, dynamic> json) {
  return HistoryPekerjaanModels(
    status: json['status'] as String,
    error: json['error'] as bool,
    message: json['message'] as String,
    data: (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : HistoryPekerjaanData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$HistoryPekerjaanModelsToJson(
        HistoryPekerjaanModels instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

HistoryPekerjaanData _$HistoryPekerjaanDataFromJson(Map<String, dynamic> json) {
  return HistoryPekerjaanData(
    id_rmh: json['id_rmh'] as String,
    ID_users: json['ID_users'] as String,
    id_dealer: json['id_dealer'] as String,
    no_spk: json['no_spk'] as String,
    tgl_report: json['tgl_report'] as String,
    nopol: json['nopol'] as String,
    tgl_report_formated: json['tgl_report_formated'] as String,
  );
}

Map<String, dynamic> _$HistoryPekerjaanDataToJson(
        HistoryPekerjaanData instance) =>
    <String, dynamic>{
      'id_rmh': instance.id_rmh,
      'ID_users': instance.ID_users,
      'id_dealer': instance.id_dealer,
      'no_spk': instance.no_spk,
      'tgl_report': instance.tgl_report,
      'nopol': instance.nopol,
      'tgl_report_formated': instance.tgl_report_formated,
    };
