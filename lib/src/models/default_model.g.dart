// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultModel _$DefaultModelFromJson(Map<String, dynamic> json) {
  return DefaultModel(json['message'] as String, json['status'] as String,
      json['error'] as bool);
}

Map<String, dynamic> _$DefaultModelToJson(DefaultModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'error': instance.error
    };
