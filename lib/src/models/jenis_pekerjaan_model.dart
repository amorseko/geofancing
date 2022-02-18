import 'package:json_annotation/json_annotation.dart';

part 'jenis_pekerjaan_model.g.dart';

@JsonSerializable()
class GetListJenisPekerjaanModel {
  String message;
  String status;
  bool error;
  List<_Data> data;

  GetListJenisPekerjaanModel(
      {this.message, this.status, this.data, this.error});

  factory GetListJenisPekerjaanModel.fromJson(Map<String, dynamic> json) =>
      _$GetListJenisPekerjaanModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetListJenisPekerjaanModelToJson(this);

  GetListJenisPekerjaanModel.withError(String error)
      : message = error,
        error = false;
}

@JsonSerializable(nullable: true)
class _Data {
  _Data({this.typeSingkat, this.typePekerjaan});

  @JsonKey(name: 'type_singkat')
  String typeSingkat;

  @JsonKey(name: 'type_pekerjaan')
  String typePekerjaan;

  factory _Data.fromJson(Map<String, dynamic> json) => _$_DataFromJson(json);

  Map<String, dynamic> toJson() => _$_DataToJson(this);
}
