import 'package:json_annotation/json_annotation.dart';

part 'kategori_part_model.g.dart';
@JsonSerializable()
class GetListKategoriPartModels {
  String message;
  String status;
  bool error;
  List<_Data> data;

  GetListKategoriPartModels({this.message, this.status, this.data, this.error});

  factory GetListKategoriPartModels.fromJson(Map<String, dynamic> json) =>
      _$GetListKategoriPartModelsFromJson(json);

  Map<String, dynamic> toJson() => _$GetListKategoriPartModelsToJson(this);

  GetListKategoriPartModels.withError(String error)
      : message = error,
        error = false;
}

@JsonSerializable()
class _Data {
  _Data(
      {this.id_kategori_part,
        this.nama_kategori_part});

  @JsonKey(name: 'id_kategori_part')
  String id_kategori_part;

  @JsonKey(name: 'nama_kategori_part')
  String nama_kategori_part;

  factory _Data.fromJson(Map<String, dynamic> json) => _$_DataFromJson(json);

  Map<String, dynamic> toJson() => _$_DataToJson(this);
}
