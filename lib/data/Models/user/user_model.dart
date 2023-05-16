import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel(
      {this.nikOremail,
      this.token,
      this.id,
      this.nama,
      this.username,
      this.email,
      this.nik,
      this.alamat,
      this.usia,
      this.bb,
      this.goldar,
      this.jk,
      this.kaderTB,
      this.no_hp,
      this.pet_kesehatan,
      this.pmo});

  String? nikOremail;
  String? token;
  int? id;
  String? nama;
  String? username;
  String? email;
  String? nik;
  String? alamat;
  int? usia;
  String? no_hp;
  String? goldar;
  String? bb;
  String? kaderTB;
  String? pmo;
  String? pet_kesehatan;
  String? jk;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
