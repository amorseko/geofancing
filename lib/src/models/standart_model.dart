import 'package:json_annotation/json_annotation.dart';
part 'standart_model.g.dart';

@JsonSerializable()
class StandartModels {
  String message;
  bool status;
  String data;

  StandartModels(this.message, this.status, this.data);

  factory StandartModels.fromJson(Map<String, dynamic> json) =>
      _$StandartModelsFromJson(json);

  StandartModels.withError(String error)
      : message = error,
        status = false;
}
