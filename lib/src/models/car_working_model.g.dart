// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_working_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryCarWorkingModels _$HistoryCarWorkingModelsFromJson(
    Map<String, dynamic> json) {
  return HistoryCarWorkingModels(
    status: json['status'] as String,
    error: json['error'] as bool,
    message: json['message'] as String,
    data: (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : HistoryCarWorkingData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$HistoryCarWorkingModelsToJson(
        HistoryCarWorkingModels instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

HistoryCarWorkingData _$HistoryCarWorkingDataFromJson(
    Map<String, dynamic> json) {
  return HistoryCarWorkingData(
    id: json['id'] as String,
    id_uniq: json['id_uniq'] as String,
    id_sa: json['id_sa'] as String,
    nopol: json['nopol'] as String,
    model: json['model'] as String,
    km: json['km'] as String,
    lp: json['lp'] as String,
    suhu: json['suhu'] as String,
    windspeed: json['windspeed'] as String,
    filter: json['filter'] as String,
    blower: json['blower'] as String,
    perawatan: json['perawatan'] as String,
    penggantian: json['penggantian'] as String,
    input_date: json['input_date'] as String,
    status: json['status'] as String,
    no_spk: json['no_spk'] as String,
    type_working: json['type_working'] as String,
    list_foto: json['list_foto'] as String,
    pekerjaan: json['pekerjaan'] as String,
  )..hp = json['hp'] as String;
}

Map<String, dynamic> _$HistoryCarWorkingDataToJson(
        HistoryCarWorkingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_uniq': instance.id_uniq,
      'id_sa': instance.id_sa,
      'nopol': instance.nopol,
      'model': instance.model,
      'km': instance.km,
      'hp': instance.hp,
      'lp': instance.lp,
      'suhu': instance.suhu,
      'windspeed': instance.windspeed,
      'filter': instance.filter,
      'blower': instance.blower,
      'perawatan': instance.perawatan,
      'penggantian': instance.penggantian,
      'input_date': instance.input_date,
      'status': instance.status,
      'no_spk': instance.no_spk,
      'type_working': instance.type_working,
      'list_foto': instance.list_foto,
      'pekerjaan': instance.pekerjaan,
    };
