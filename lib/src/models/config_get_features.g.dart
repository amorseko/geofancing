// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_get_features.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigGetFeaturesModel _$ConfigGetFeaturesModelFromJson(
    Map<String, dynamic> json) {
  return ConfigGetFeaturesModel(
      message: json['message'] as String,
      status: json['status'] as bool,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : _Data.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      code: json['code'] as int);
}

Map<String, dynamic> _$ConfigGetFeaturesModelToJson(
        ConfigGetFeaturesModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'code': instance.code,
      'data': instance.data
    };

_Data _$_DataFromJson(Map<String, dynamic> json) {
  return _Data(
      id: json['id'] as int,
      appid: json['appid'] as String,
      feature_id: json['feature_id'] as String,
      status: json['status'] as bool);
}

Map<String, dynamic> _$_DataToJson(_Data instance) => <String, dynamic>{
      'id': instance.id,
      'appid': instance.appid,
      'feature_id': instance.feature_id,
      'status': instance.status
    };
