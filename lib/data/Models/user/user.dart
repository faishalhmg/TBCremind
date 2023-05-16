import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String nama;
  String username;
  String email;
  String nik;
  String password;
  String confirm_password;
  String? alamat;
  String? usia;
  String? no_hp;
  String? goldar;
  String? bb;
  String? kaderTB;
  String? pmo;
  String? pet_kesehatan;
  String? jk;

  User({
    this.id,
    required this.nama,
    required this.username,
    required this.email,
    required this.nik,
    required this.password,
    required this.confirm_password,
    this.alamat,
    this.usia,
    this.no_hp,
    this.goldar,
    this.bb,
    this.kaderTB,
    this.pmo,
    this.pet_kesehatan,
    this.jk,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
