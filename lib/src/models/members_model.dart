import 'package:json_annotation/json_annotation.dart';

part 'members_model.g.dart';

@JsonSerializable(nullable: true)
class MemberModels {
  int code;
  String message;
  bool status;
  _Data data;

//  List<_Data> data = [];

  MemberModels(
      {this.code,this.message, this.status, this.data});

  factory MemberModels.fromJson(Map<String, dynamic> json) =>
      _$MemberModelsFromJson(json);


  Map<String, dynamic> toJson() => _$MemberModelsToJson(this);

  MemberModels.withError(String error)
      : message = error,
        status = false;
}

@JsonSerializable(nullable: true)
class _Data {

  _Data(
        {
          this.username,
          this.level,
          this.nama_user,
          this.id_user,
          this.foto,
          this.id_dealer,
          this.token,
          this.longitude,
          this.latitude
        }
      );

  @JsonKey(name: 'username')
  String username;
  @JsonKey(name: 'level')
  String level;
  @JsonKey(name: 'nama_user')
  String nama_user;
  @JsonKey(name: 'id_user')
  String id_user;
  @JsonKey(name: 'foto')
  String foto;
  @JsonKey(name: 'id_dealer')
  String id_dealer;
  @JsonKey(name: 'token')
  String token;
  @JsonKey(name: 'longitude')
  double longitude;
  @JsonKey(name: 'latitude')
  double latitude;

  factory _Data.fromJson(Map<String, dynamic> json) => _$_DataFromJson(json);

  Map<String, dynamic> toJson() => _$_DataToJson(this);
}