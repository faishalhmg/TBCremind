import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum Gender { male, female }

enum Status { active, inactive }

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    required this.nama,
    required this.username,
    required this.email,
    required this.nik,
    required this.password,
    required this.alamat,
    required this.usia,
    required this.no_hp,
    required this.goldar,
    required this.bb,
    required this.kaderTB,
    required this.pmo,
    required this.pet_kesehatan,
    required this.jk,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  final int id;
  final String nama;
  final String username;
  final String email;
  final String nik;
  final String password;
  final String alamat;
  final String usia;
  final String no_hp;
  final String goldar;
  final String bb;
  final String kaderTB;
  final String pmo;
  final String pet_kesehatan;
  final String jk;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        id,
        nama,
        username,
        email,
        nik,
        password,
        alamat,
        usia,
        no_hp,
        goldar,
        bb,
        kaderTB,
        pmo,
        pet_kesehatan,
        jk
      ];
}
