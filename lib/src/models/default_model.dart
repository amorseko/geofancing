import 'package:json_annotation/json_annotation.dart';
part 'default_model.g.dart';

@JsonSerializable()
class DefaultModel {
  String message;
  String status;
  bool error;

  DefaultModel(this.message, this.status, this.error);

  factory DefaultModel.fromJson(Map<String, dynamic> json) =>
      _$DefaultModelFromJson(json);
}
