import 'package:json_annotation/json_annotation.dart';

part 'car_working_model.g.dart';

@JsonSerializable(nullable: true)
class HistoryCarWorkingModels {

  String status;
  bool error;
  String message;

  List<HistoryCarWorkingData> data;

  HistoryCarWorkingModels({this.status, this.error, this.message, this.data});

  factory HistoryCarWorkingModels.fromJson(Map<String, dynamic> json) =>
  _$HistoryCarWorkingModelsFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryCarWorkingModelsToJson(this);

  HistoryCarWorkingModels.withError(String error)
      : message = error,
        error = false;
}

@JsonSerializable(nullable: true)
class HistoryCarWorkingData {

  HistoryCarWorkingData(
      {
        this.id,
        this.id_uniq,
        this.id_sa,
        this.nopol,
        this.model,
        this.km,
        this.lp,
        this.suhu,
        this.windspeed,
        this.filter,
        this.blower,
        this.perawatan,
        this.penggantian,
        this.input_date,
        this.status,
        this.no_spk,
        this.type_working,
        this.list_foto,
      }
      );

  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'id_uniq')
  String id_uniq;
  @JsonKey(name: 'id_sa')
  String id_sa;
  @JsonKey(name: 'nopol')
  String nopol;
  @JsonKey(name: 'model')
  String model;
  @JsonKey(name: 'km')
  String km;
  @JsonKey(name: 'hp')
  String hp;
  @JsonKey(name: 'lp')
  String lp;
  @JsonKey(name: 'suhu')
  String suhu;
  @JsonKey(name: 'windspeed')
  String windspeed;
  @JsonKey(name: 'filter')
  String filter;
  @JsonKey(name: 'blower')
  String blower;
  @JsonKey(name: 'perawatan')
  String perawatan;
  @JsonKey(name: 'penggantian')
  String penggantian;
  @JsonKey(name: 'input_date')
  String input_date;
  @JsonKey(name: 'status')
  String status;
  @JsonKey(name: 'no_spk')
  String no_spk;
  @JsonKey(name: 'type_working')
  String type_working;
  @JsonKey(name: 'list_foto')
  String list_foto;

  factory HistoryCarWorkingData.fromJson(Map<String, dynamic> json) =>
      _$HistoryCarWorkingDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryCarWorkingDataToJson(this);
}


