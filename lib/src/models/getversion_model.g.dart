// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getversion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetVersionModel _$GetVersionModelFromJson(Map<String, dynamic> json) {
  return GetVersionModel(
    message: json['message'] as String,
    status: json['status'] as bool,
    data: json['data'] == null
        ? null
        : _Data.fromJson(json['data'] as Map<String, dynamic>),
    code: json['code'] as int,
  );
}

Map<String, dynamic> _$GetVersionModelToJson(GetVersionModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'code': instance.code,
      'data': instance.data,
    };

_Data _$_DataFromJson(Map<String, dynamic> json) {
  return _Data(
    app_id: json['app_id'] as String,
    data: json['data'] == null
        ? null
        : _DataApp.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_DataToJson(_Data instance) => <String, dynamic>{
      'app_id': instance.app_id,
      'data': instance.data,
    };

_DataApp _$_DataAppFromJson(Map<String, dynamic> json) {
  return _DataApp(
    force_update: json['force_update'] as bool,
    ios: json['ios'] == null
        ? null
        : _DataVersion.fromJson(json['ios'] as Map<String, dynamic>),
    android: json['android'] == null
        ? null
        : _DataVersion.fromJson(json['android'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_DataAppToJson(_DataApp instance) => <String, dynamic>{
      'force_update': instance.force_update,
      'ios': instance.ios,
      'android': instance.android,
    };

_DataVersion _$_DataVersionFromJson(Map<String, dynamic> json) {
  return _DataVersion(
    version_code: json['version_code'] as String,
    url: json['url'] as String,
    version_name: json['version_name'] as String,
  );
}

Map<String, dynamic> _$_DataVersionToJson(_DataVersion instance) =>
    <String, dynamic>{
      'version_code': instance.version_code,
      'url': instance.url,
      'version_name': instance.version_name,
    };
