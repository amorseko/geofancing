import 'package:json_annotation/json_annotation.dart';

part 'id_barang_detail_model.g.dart';


@JsonSerializable(nullable: true)
class IDBarangModels {
  String status;
  bool error;
  String message;
  List<_Data> data = [];

  IDBarangModels(
      {this.status,this.error, this.message, this.data});

  factory IDBarangModels.fromJson(Map<String, dynamic> json) =>
      _$IDBarangModelsFromJson(json);


  Map<String, dynamic> toJson() => _$IDBarangModelsToJson(this);

  IDBarangModels.withError(String error)
      : message = error,
        error = false;
}


@JsonSerializable(nullable: true)
class _Data {
  _Data ({
    this.id_permintaan_barang
  });

  @JsonKey(name: 'id_permintaan_barang')
  String id_permintaan_barang;

  factory _Data.fromJson(Map<String, dynamic> json) => _$_DataFromJson(json);

  Map<String, dynamic> toJson() => _$_DataToJson(this);
}