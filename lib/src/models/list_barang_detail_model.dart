import 'package:json_annotation/json_annotation.dart';
part 'list_barang_detail_model.g.dart';

@JsonSerializable()
class GetListBarangDetailModels {
  String message;
  String status;
  bool error;
  List<GetListBarangDetailData> data = [];

  GetListBarangDetailModels({this.message, this.status, this.data, this.error});

  factory GetListBarangDetailModels.fromJson(Map<String, dynamic> json) =>
      _$GetListBarangDetailModelsFromJson(json);

  Map<String, dynamic> toJson() => _$GetListBarangDetailModelsToJson(this);

  GetListBarangDetailModels.withError(String error)
      : message = error,
        error = false;
}

@JsonSerializable(nullable: true)
class GetListBarangDetailData {
  GetListBarangDetailData(
        {
          this.id_permintaan_brg,
          this.jenis_part,
          this.kode_part,
          this.nama_parts,
          this.nama_satuan,
          this.id_barang,
          this.id_dpb
        }
      );

  @JsonKey(name: 'id_permintaan_brg')
  String id_permintaan_brg;

  @JsonKey(name: 'jenis_part')
  String jenis_part;

  @JsonKey(name: 'kode_part')
  String kode_part;

  @JsonKey(name: 'nama_parts')
  String nama_parts;

  @JsonKey(name: 'nama_satuan')
  String nama_satuan;

  @JsonKey(name: 'id_barang')
  String id_barang;

  @JsonKey(name: 'id_dpb')
  String id_dpb;

  factory GetListBarangDetailData.fromJson(Map<String, dynamic> json) => _$GetListBarangDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$GetListBarangDetailDataToJson(this);
}
