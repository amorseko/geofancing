import 'package:json_annotation/json_annotation.dart';

part 'jarak_model.g.dart';


@JsonSerializable(nullable: true)
class JarakModels {
  int code;
  bool status;
  String message;
  List<_Data> data = [];

  JarakModels(
      {this.code,this.status, this.message, this.data});

  factory JarakModels.fromJson(Map<String, dynamic> json) =>
      _$JarakModelsFromJson(json);


  Map<String, dynamic> toJson() => _$JarakModelsToJson(this);

  JarakModels.withError(String error)
      : message = error,
        status = false;
}


@JsonSerializable(nullable: true)
class _Data {
  _Data ({
    this.jarak
  });

  @JsonKey(name: 'jarak')
  int jarak;

  factory _Data.fromJson(Map<String, dynamic> json) => _$_DataFromJson(json);

  Map<String, dynamic> toJson() => _$_DataToJson(this);
}