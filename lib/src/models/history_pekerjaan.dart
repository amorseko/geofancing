import 'package:json_annotation/json_annotation.dart';

part 'history_pekerjaan.g.dart';

@JsonSerializable(nullable: true)
class HistoryPekerjaanModels {
  String status;
  bool error;
  String message;

  List<HistoryPekerjaanData> data = [];

  HistoryPekerjaanModels({this.status, this.error, this.message, this.data});

  factory HistoryPekerjaanModels.fromJson(Map<String, dynamic> json) =>
      _$HistoryPekerjaanModelsFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryPekerjaanModelsToJson(this);
}

@JsonSerializable(nullable: true)
class HistoryPekerjaanData {
  HistoryPekerjaanData(
      {this.id_rmh,
      this.ID_users,
      this.id_dealer,
      this.no_spk,
      this.tgl_report,
      this.nopol,
      this.tgl_report_formated});

  @JsonKey(name: 'id_rmh')
  String id_rmh;
  @JsonKey(name: 'ID_users')
  String ID_users;
  @JsonKey(name: 'id_dealer')
  String id_dealer;
  @JsonKey(name: 'no_spk')
  String no_spk;
  @JsonKey(name: 'tgl_report')
  String tgl_report;
  @JsonKey(name: 'nopol')
  String nopol;
  @JsonKey(name: 'tgl_report_formated')
  String tgl_report_formated;

  factory HistoryPekerjaanData.fromJson(Map<String, dynamic> json) =>
      _$HistoryPekerjaanDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryPekerjaanDataToJson(this);
}
