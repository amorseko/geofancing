// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_picture_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPictureModel _$GetPictureModelFromJson(Map<String, dynamic> json) {
  return GetPictureModel(
      status: json['status'] as String,
      error: json['error'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : ListGetPictureModel.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$GetPictureModelToJson(GetPictureModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data
    };

ListGetPictureModel _$ListGetPictureModelFromJson(Map<String, dynamic> json) {
  return ListGetPictureModel(
      foto_spk: json['foto_spk'] as String,
      foto_nopol: json['foto_nopol'] as String);
}

Map<String, dynamic> _$ListGetPictureModelToJson(
        ListGetPictureModel instance) =>
    <String, dynamic>{
      'foto_spk': instance.foto_spk,
      'foto_nopol': instance.foto_nopol
    };
