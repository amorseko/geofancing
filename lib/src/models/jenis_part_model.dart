import 'package:json_annotation/json_annotation.dart';

part 'jenis_part_model.g.dart';

@JsonSerializable()
class GetListJenisPartModels {
  String message;
  String status;
  bool error;
  List<_Data> data;

  GetListJenisPartModels({this.message, this.status, this.data, this.error});

  factory GetListJenisPartModels.fromJson(Map<String, dynamic> json) =>
      _$GetListJenisPartModelsFromJson(json);

  Map<String, dynamic> toJson() => _$GetListJenisPartModelsToJson(this);

  GetListJenisPartModels.withError(String error)
      : message = error,
        error = false;
}

@JsonSerializable()
class _Data {
  _Data({this.id_jenis_part, this.jenis_part});

  @JsonKey(name: 'id_jenis_part')
  String id_jenis_part;

  @JsonKey(name: 'jenis_part')
  String jenis_part;

  factory _Data.fromJson(Map<String, dynamic> json) => _$_DataFromJson(json);

  Map<String, dynamic> toJson() => _$_DataToJson(this);
}
