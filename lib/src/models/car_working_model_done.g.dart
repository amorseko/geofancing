// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_working_model_done.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryCarWorkingModelsDone _$HistoryCarWorkingModelsDoneFromJson(
    Map<String, dynamic> json) {
  return HistoryCarWorkingModelsDone(
    status: json['status'] as String,
    error: json['error'] as bool,
    message: json['message'] as String,
    data: json['data'] == null
        ? null
        : HistoryCarWorkingData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$HistoryCarWorkingModelsDoneToJson(
        HistoryCarWorkingModelsDone instance) =>
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
    list_foto: (json['list_foto'] as List)
        ?.map((e) =>
            e == null ? null : _ListFoto.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..hp = json['hp'] as String;
}

Map<String, dynamic> _$HistoryCarWorkingDataToJson(
        HistoryCarWorkingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_uniq': instance.id_uniq,
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
      'list_foto': instance.list_foto,
    };

_ListFoto _$_ListFotoFromJson(Map<String, dynamic> json) {
  return _ListFoto(
    code: json['code'] as String,
    foto: json['foto'] as String,
  )..file_name = json['file_name'] as String;
}

Map<String, dynamic> _$_ListFotoToJson(_ListFoto instance) => <String, dynamic>{
      'code': instance.code,
      'foto': instance.foto,
      'file_name': instance.file_name,
    };
