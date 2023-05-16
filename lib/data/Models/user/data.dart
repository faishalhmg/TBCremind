import 'package:json_annotation/json_annotation.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  Data({
    required this.userModel,
  });

  UserModel userModel;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
