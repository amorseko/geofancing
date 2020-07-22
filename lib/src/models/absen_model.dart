import 'package:json_annotation/json_annotation.dart';

part 'absen_model.g.dart';

@JsonSerializable(nullable: true)
class AbsenModels {
  String status;
  bool error;
  String message;

  List<AbsenTodayData> data = [];

  AbsenModels(
      {this.status,this.error, this.message, this.data});

  factory AbsenModels.fromJson(Map<String, dynamic> json) =>
      _$AbsenModelsFromJson(json);


  Map<String, dynamic> toJson() => _$AbsenModelsToJson(this);


}

@JsonSerializable(nullable: true)
class AbsenTodayData {

  AbsenTodayData(
      {
        this.jam_absen,
        this.koordinat,
        this.stt_absen,
        this.tanggal
      }
      );

  @JsonKey(name: 'jam_absen')
  String jam_absen;
  @JsonKey(name: 'koordinat')
  String koordinat;
  @JsonKey(name: 'stt_absen')
  String stt_absen;
  @JsonKey(name: 'tanggal')
  String tanggal;


  factory AbsenTodayData.fromJson(Map<String, dynamic> json) => _$AbsenTodayDataFromJson(json);

  Map<String, dynamic> toJson() => _$AbsenTodayDataToJson(this);
}