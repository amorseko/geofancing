import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModels {
  int code;
  String message;
  bool status;
  List<ListDataProfile> data = [];

//  List<_Data> data = [];

  ProfileModels({this.code, this.message, this.status, this.data});

  factory ProfileModels.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelsFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelsToJson(this);

  ProfileModels.withError(String error)
      : message = error,
        status = false;
}

@JsonSerializable()
class ListDataProfile {
  ListDataProfile(
      {this.nik,
        this.no_hp,
        this.no_sepatu,
        this.u_werpack,
        this.no_bpjs,
        this.alamat_pegawai,
      });

  @JsonKey(name: 'nik')
  String nik;
  @JsonKey(name: 'no_hp')
  String no_hp;
  @JsonKey(name: 'no_sepatu')
  String no_sepatu;
  @JsonKey(name: 'u_werpack')
  String u_werpack;
  @JsonKey(name: 'no_bpjs')
  String no_bpjs;
  @JsonKey(name: 'alamat_pegawai')
  String alamat_pegawai;

  factory ListDataProfile.fromJson(Map<String, dynamic> json) => _$ListDataProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ListDataProfileToJson(this);
}