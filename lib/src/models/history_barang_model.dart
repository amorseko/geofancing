import 'package:json_annotation/json_annotation.dart';

part 'history_barang_model.g.dart';

@JsonSerializable(nullable: true)
class HistoryBarangModels {
  String status;
  bool error;
  String message;

  List<HistoryBarangData> data = [];

  HistoryBarangModels(
      {this.status,this.error, this.message, this.data});

  factory HistoryBarangModels.fromJson(Map<String, dynamic> json) =>
      _$HistoryBarangModelsFromJson(json);


  Map<String, dynamic> toJson() => _$HistoryBarangModelsToJson(this);


}

@JsonSerializable(nullable: true)
class HistoryBarangData {

  HistoryBarangData(
      {
        this.npb,
        this.tgl_transaksi_in,
        this.jenis_part,
        this.nama_dealer,
        this.keterangan
      }
      );

  @JsonKey(name: 'npb')
  String npb;
  @JsonKey(name: 'tgl_transaksi_in')
  String tgl_transaksi_in;
  @JsonKey(name: 'jenis_part')
  String jenis_part;
  @JsonKey(name: 'nama_dealer')
  String nama_dealer;
  @JsonKey(name: 'keterangan')
  String keterangan;


  factory HistoryBarangData.fromJson(Map<String, dynamic> json) => _$HistoryBarangDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryBarangDataToJson(this);
}