import 'package:json_annotation/json_annotation.dart';

part 'satuan_model.g.dart';
@JsonSerializable()
class GetSatuanModels {
  String message;
  String status;
  bool error;
  List<_Data> data;

  GetSatuanModels({this.message, this.status, this.data, this.error});

  factory GetSatuanModels.fromJson(Map<String, dynamic> json) =>
      _$GetSatuanModelsFromJson(json);

  Map<String, dynamic> toJson() => _$GetSatuanModelsToJson(this);

  GetSatuanModels.withError(String error)
      : message = error,
        error = false;
}

@JsonSerializable()
class _Data {
  _Data(
      {this.id_satuan,
        this.nama_satuan});

  @JsonKey(name: 'id_satuan')
  String id_satuan;

  @JsonKey(name: 'nama_satuan')
  String nama_satuan;

  factory _Data.fromJson(Map<String, dynamic> json) => _$_DataFromJson(json);

  Map<String, dynamic> toJson() => _$_DataToJson(this);
}
