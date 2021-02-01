import 'package:json_annotation/json_annotation.dart';

part 'getversion_model.g.dart';

@JsonSerializable(nullable: true)
class GetVersionModel {
  String message;
  bool status;
  int code;
  _Data data;

  GetVersionModel({this.message, this.status, this.data, this.code});

  factory GetVersionModel.fromJson(Map<String, dynamic> json) =>
      _$GetVersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetVersionModelToJson(this);

  GetVersionModel.withError(String error)
      : message = error,
        status = false;
}

@JsonSerializable(nullable: true)
class _Data {
  _Data({this.app_id, this.data});

  @JsonKey(name: 'app_id')
  String app_id;
  _DataApp data;

  factory _Data.fromJson(Map<String, dynamic> json) => _$_DataFromJson(json);

  Map<String, dynamic> toJson() => _$_DataToJson(this);
}

@JsonSerializable(nullable: true)
class _DataApp {
  _DataApp({this.force_update,this.ios,this.android});

  @JsonKey(name: 'force_update')
  bool force_update;

  _DataVersion ios;
  _DataVersion android;

  factory _DataApp.fromJson(Map<String, dynamic> json) => _$_DataAppFromJson(json);

  Map<String, dynamic> toJson() => _$_DataAppToJson(this);
}

@JsonSerializable(nullable: true)
class _DataVersion {
  _DataVersion({this.version_code,this.url, this.version_name});

  @JsonKey(name: 'version_code')
  String version_code;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'version_name')
  String version_name;

  factory _DataVersion.fromJson(Map<String, dynamic> json) => _$_DataVersionFromJson(json);

  Map<String, dynamic> toJson() => _$_DataVersionToJson(this);
}