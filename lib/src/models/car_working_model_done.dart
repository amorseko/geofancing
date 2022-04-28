import 'package:json_annotation/json_annotation.dart';

part 'car_working_model_done.g.dart';

@JsonSerializable(nullable: true)
class HistoryCarWorkingModelsDone {

  String status;
  bool error;
  String message;

  HistoryCarWorkingData data;

  HistoryCarWorkingModelsDone({this.status, this.error, this.message, this.data});

  factory HistoryCarWorkingModelsDone.fromJson(Map<String, dynamic> json) =>
      _$HistoryCarWorkingModelsDoneFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryCarWorkingModelsDoneToJson(this);

  HistoryCarWorkingModelsDone.withError(String error)
      : message = error,
        error = false;
}

@JsonSerializable(nullable: true)
class HistoryCarWorkingData {

  // List<_ListFoto> list_foto = [];
  HistoryCarWorkingData(
      {
        this.id,
        this.id_uniq,
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


  List<_ListFoto> list_foto;

  factory HistoryCarWorkingData.fromJson(Map<String, dynamic> json) =>
      _$HistoryCarWorkingDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryCarWorkingDataToJson(this);
}


@JsonSerializable(nullable: true)
class _ListFoto {
  _ListFoto({this.code, this.foto});

  @JsonKey(name: 'code')
  String code;
  @JsonKey(name: 'foto')
  String foto;
  @JsonKey(name: 'file_name')
  String file_name;

  factory _ListFoto.fromJson(Map<String, dynamic> json) => _$_ListFotoFromJson(json);

  Map<String, dynamic> toJson() => _$_ListFotoToJson(this);
}

