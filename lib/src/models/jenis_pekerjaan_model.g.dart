// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jenis_pekerjaan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetListJenisPekerjaanModel _$GetListJenisPekerjaanModelFromJson(
    Map<String, dynamic> json) {
  return GetListJenisPekerjaanModel(
      message: json['message'] as String,
      status: json['status'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : _Data.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      error: json['error'] as bool);
}

Map<String, dynamic> _$GetListJenisPekerjaanModelToJson(
        GetListJenisPekerjaanModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'error': instance.error,
      'data': instance.data
    };

_Data _$_DataFromJson(Map<String, dynamic> json) {
  return _Data(
      typeSingkat: json['type_singkat'] as String,
      typePekerjaan: json['type_pekerjaan'] as String);
}

Map<String, dynamic> _$_DataToJson(_Data instance) => <String, dynamic>{
      'type_singkat': instance.typeSingkat,
      'type_pekerjaan': instance.typePekerjaan
    };
