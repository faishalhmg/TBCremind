// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      nama: json['nama'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      nik: json['nik'] as String,
      password: json['password'] as String,
      alamat: json['alamat'] as String,
      usia: json['usia'] as String,
      no_hp: json['no_hp'] as String,
      goldar: json['goldar'] as String,
      bb: json['bb'] as String,
      kaderTB: json['kaderTB'] as String,
      pmo: json['pmo'] as String,
      pet_kesehatan: json['pet_kesehatan'] as String,
      jk: json['jk'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'username': instance.username,
      'email': instance.email,
      'nik': instance.nik,
      'password': instance.password,
      'alamat': instance.alamat,
      'usia': instance.usia,
      'no_hp': instance.no_hp,
      'goldar': instance.goldar,
      'bb': instance.bb,
      'kaderTB': instance.kaderTB,
      'pmo': instance.pmo,
      'pet_kesehatan': instance.pet_kesehatan,
      'jk': instance.jk,
    };
