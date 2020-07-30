import 'package:json_annotation/json_annotation.dart';

part 'history_model.g.dart';

@JsonSerializable(nullable: true)
class HistoryModels {
  String status;
  bool error;
  String message;

  List<HistoryData> data = [];

  HistoryModels(
      {this.status,this.error, this.message, this.data});

  factory HistoryModels.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelsFromJson(json);


  Map<String, dynamic> toJson() => _$HistoryModelsToJson(this);


}

@JsonSerializable(nullable: true)
class HistoryData {

  HistoryData(
      {
        this.absen_masuk,
        this.absen_keluar,
        this.koordinat_masuk,
        this.koordinat_keluar,
        this.stt_absen,
        this.tanggal,
      }
      );

  @JsonKey(name: 'absen_masuk')
  String absen_masuk;
  @JsonKey(name: 'absen_keluar')
  String absen_keluar;
  @JsonKey(name: 'koordinat_masuk')
  String koordinat_masuk;
  @JsonKey(name: 'koordinat_keluar')
  String koordinat_keluar;
  @JsonKey(name: 'stt_absen')
  String stt_absen;
  @JsonKey(name: 'tanggal')
  String tanggal;


  factory HistoryData.fromJson(Map<String, dynamic> json) => _$HistoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryDataToJson(this);
}