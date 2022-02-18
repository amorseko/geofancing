import 'package:json_annotation/json_annotation.dart';

part 'absen_model.g.dart';

@JsonSerializable(nullable: true)
class AbsenModels {
  String status;
  bool error;
  String message;

  List<AbsenTodayData> data = [];

  AbsenModels({this.status, this.error, this.message, this.data});

  factory AbsenModels.fromJson(Map<String, dynamic> json) =>
      _$AbsenModelsFromJson(json);

  Map<String, dynamic> toJson() => _$AbsenModelsToJson(this);
}

@JsonSerializable(nullable: true)
class AbsenTodayData {
  AbsenTodayData(
      {this.absen_masuk,
      this.absen_keluar,
      this.koordinat_masuk,
      this.koordinat_keluar,
      this.stt_absen,
      this.tanggal});

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

  factory AbsenTodayData.fromJson(Map<String, dynamic> json) =>
      _$AbsenTodayDataFromJson(json);

  Map<String, dynamic> toJson() => _$AbsenTodayDataToJson(this);
}
