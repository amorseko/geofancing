import 'package:json_annotation/json_annotation.dart';

part 'list_bank_model.g.dart';

@JsonSerializable()
class ListBankModels {
  String message;
  String status;
  bool error;
  List<ListDataBank> data;

//  List<_Data> data = [];

  ListBankModels({this.message, this.status, this.data, this.error});

  factory ListBankModels.fromJson(Map<String, dynamic> json) =>
      _$ListBankModelsFromJson(json);

  Map<String, dynamic> toJson() => _$ListBankModelsToJson(this);

  ListBankModels.withError(String error)
      : message = error,
        error = false;
}

@JsonSerializable()
class ListDataBank {
  ListDataBank(
      {this.code,
        this.name,
      });

  @JsonKey(name: 'code')
  String code;
  @JsonKey(name: 'name')
  String name;

  factory ListDataBank.fromJson(Map<String, dynamic> json) => _$ListDataBankFromJson(json);

  Map<String, dynamic> toJson() => _$ListDataBankToJson(this);
}