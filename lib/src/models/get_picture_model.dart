import 'package:json_annotation/json_annotation.dart';

part 'get_picture_model.g.dart';

@JsonSerializable(nullable: true)
class GetPictureModel {
  String status;
  bool error;
  String message;

  List<ListGetPictureModel> data = [];

  GetPictureModel({this.status, this.error, this.message, this.data});

  factory GetPictureModel.fromJson(Map<String, dynamic> json) =>
      _$GetPictureModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetPictureModelToJson(this);
}

@JsonSerializable(nullable: true)
class ListGetPictureModel {
  ListGetPictureModel({
    this.foto_spk,
    this.foto_nopol,
  });

  @JsonKey(name: 'foto_spk')
  String foto_spk;

  @JsonKey(name: 'foto_nopol')
  String foto_nopol;

  factory ListGetPictureModel.fromJson(Map<String, dynamic> json) =>
      _$ListGetPictureModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListGetPictureModelToJson(this);
}
