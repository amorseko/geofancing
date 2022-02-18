// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_bank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListBankModels _$ListBankModelsFromJson(Map<String, dynamic> json) {
  return ListBankModels(
      message: json['message'] as String,
      status: json['status'] as String,
      data: (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : ListDataBank.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      error: json['error'] as bool);
}

Map<String, dynamic> _$ListBankModelsToJson(ListBankModels instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'error': instance.error,
      'data': instance.data
    };

ListDataBank _$ListDataBankFromJson(Map<String, dynamic> json) {
  return ListDataBank(
      code: json['code'] as String, name: json['name'] as String);
}

Map<String, dynamic> _$ListDataBankToJson(ListDataBank instance) =>
    <String, dynamic>{'code': instance.code, 'name': instance.name};
