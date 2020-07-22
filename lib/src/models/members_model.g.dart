// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'members_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModels _$MemberModelsFromJson(Map<String, dynamic> json) {
  return MemberModels(
      code: json['code'] as int,
      message: json['message'] as String,
      status: json['status'] as bool,
      data: json['data'] == null
          ? null
          : _Data.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MemberModelsToJson(MemberModels instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'status': instance.status,
      'data': instance.data
    };

_Data _$_DataFromJson(Map<String, dynamic> json) {
  return _Data(
      username: json['username'] as String,
      level: json['level'] as String,
      nama_user: json['nama_user'] as String,
      id_user: json['id_user'] as String,
      foto: json['foto'] as String,
      id_dealer: json['id_dealer'] as String,
      token: json['token'] as String,
      longitude: (json['longitude'] as num)?.toDouble(),
      latitude: (json['latitude'] as num)?.toDouble());
}

Map<String, dynamic> _$_DataToJson(_Data instance) => <String, dynamic>{
      'username': instance.username,
      'level': instance.level,
      'nama_user': instance.nama_user,
      'id_user': instance.id_user,
      'foto': instance.foto,
      'id_dealer': instance.id_dealer,
      'token': instance.token,
      'longitude': instance.longitude,
      'latitude': instance.latitude
    };
