import 'package:json_annotation/json_annotation.dart';

part 'list_barang_model.g.dart';
@JsonSerializable()
class GetListNamaBarangModels {
  String message;
  String status;
  bool error;
  List<_Data> data;

  GetListNamaBarangModels({this.message, this.status, this.data, this.error});

  factory GetListNamaBarangModels.fromJson(Map<String, dynamic> json) =>
      _$GetListNamaBarangModelsFromJson(json);

  Map<String, dynamic> toJson() => _$GetListNamaBarangModelsToJson(this);

  GetListNamaBarangModels.withError(String error)
      : message = error,
        error = false;
}

@JsonSerializable()
class _Data {
  _Data(
      {this.id_barang,
        this.nama_parts,
        this.satuan});

  @JsonKey(name: 'id_barang')
  String id_barang;

  @JsonKey(name: 'nama_parts')
  String nama_parts;

  @JsonKey(name: 'satuan')
  String satuan;

  factory _Data.fromJson(Map<String, dynamic> json) => _$_DataFromJson(json);

  Map<String, dynamic> toJson() => _$_DataToJson(this);
}
