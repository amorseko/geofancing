import 'package:json_annotation/json_annotation.dart';

part 'config_get_features.g.dart';

@JsonSerializable()
class ConfigGetFeaturesModel {
  String message;
  bool status;
  int code;
  List<_Data> data = [];

  ConfigGetFeaturesModel({this.message, this.status, this.data, this.code});

  factory ConfigGetFeaturesModel.fromJson(Map<String, dynamic> json) =>
      _$ConfigGetFeaturesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigGetFeaturesModelToJson(this);

  ConfigGetFeaturesModel.withError(String error)
      : message = error,
        status = false;
}

@JsonSerializable()
class _Data {
  _Data({this.id, this.appid, this.feature_id, this.status});

  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'appid')
  String appid;
  @JsonKey(name: 'feature_id')
  String feature_id;
  @JsonKey(name: 'status')
  bool status;

  factory _Data.fromJson(Map<String, dynamic> json) => _$_DataFromJson(json);

  Map<String, dynamic> toJson() => _$_DataToJson(this);
}