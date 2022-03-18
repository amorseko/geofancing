// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModels _$ProfileModelsFromJson(Map<String, dynamic> json) {
  return ProfileModels(
    code: json['code'] as int,
    message: json['message'] as String,
    status: json['status'] as bool,
    data: (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : ListDataProfile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProfileModelsToJson(ProfileModels instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'status': instance.status,
      'data': instance.data,
    };

ListDataProfile _$ListDataProfileFromJson(Map<String, dynamic> json) {
  return ListDataProfile(
    nik: json['nik'] as String,
    no_hp: json['no_hp'] as String,
    no_sepatu: json['no_sepatu'] as String,
    u_werpack: json['u_werpack'] as String,
    no_bpjs: json['no_bpjs'] as String,
    alamat_pegawai: json['alamat_pegawai'] as String,
    ibu_kandung: json['ibu_kandung'] as String,
    no_rek: json['no_rek'] as String,
    an_rek: json['an_rek'] as String,
    kd_bank: json['kd_bank'] as String,
  );
}

Map<String, dynamic> _$ListDataProfileToJson(ListDataProfile instance) =>
    <String, dynamic>{
      'nik': instance.nik,
      'no_hp': instance.no_hp,
      'no_sepatu': instance.no_sepatu,
      'u_werpack': instance.u_werpack,
      'no_bpjs': instance.no_bpjs,
      'alamat_pegawai': instance.alamat_pegawai,
      'ibu_kandung': instance.ibu_kandung,
      'no_rek': instance.no_rek,
      'an_rek': instance.an_rek,
      'kd_bank': instance.kd_bank,
    };
