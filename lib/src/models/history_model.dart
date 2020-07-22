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
        this.jam_masuk,
        this.jam_pulang,
        this.titik_absen,
        this.titik_pulang,
        this.tanggal,
      }
      );

  @JsonKey(name: 'jam_masuk')
  String jam_masuk;
  @JsonKey(name: 'jam_pulang')
  String jam_pulang;
  @JsonKey(name: 'titik_absen')
  String titik_absen;
  @JsonKey(name: 'titik_pulang')
  String titik_pulang;
  @JsonKey(name: 'tanggal')
  String tanggal;


  factory HistoryData.fromJson(Map<String, dynamic> json) => _$HistoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryDataToJson(this);
}