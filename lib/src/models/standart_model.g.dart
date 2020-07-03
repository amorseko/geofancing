// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandartModels _$StandartModelsFromJson(Map<String, dynamic> json) {
  return StandartModels(json['message'] as String, json['status'] as bool,
      json['data'] as String);
}

Map<String, dynamic> _$StandartModelsToJson(StandartModels instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'data': instance.data
    };
