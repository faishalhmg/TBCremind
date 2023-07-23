import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbc_app/data/Models/alarm/data_model/pengingat.dart';
import 'package:tbc_app/data/Models/alarm/pengambilan_model/pengambilan.dart';
import 'package:tbc_app/data/Models/alarm/periksa_model/periksa.dart';
import 'package:tbc_app/data/Models/edukasi/edukasi.dart';
import 'package:tbc_app/data/Models/efek/efek.dart';
import 'package:tbc_app/data/Models/keluarga/keluarga.dart';
import 'package:tbc_app/data/Models/quiz/hasil_quiz.dart';
import 'package:tbc_app/data/Models/quiz/quiz.dart';
import 'package:tbc_app/data/Models/quiz/quizez.dart';
import 'package:tbc_app/data/Models/quiz/status_quiz.dart';

import 'package:tbc_app/data/Models/user/user.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/AuthorizationInterceptor.dart';
import 'package:tbc_app/data/dio/LoggerInterceptor.dart';
import 'package:tbc_app/data/dio/dio_exception.dart';
import 'package:tbc_app/data/dio/endpoints.dart';
import 'package:tbc_app/service/StorageService.dart';
import 'package:tbc_app/service/storageitem.dart';
import 'package:tbc_app/view/pasien/haislKuis.dart';

class DioClient {
  DioClient([Dio? dio])
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://tbc.restikol.my.id/',
            connectTimeout: Duration(seconds: 5000),
            receiveTimeout: Duration(seconds: 3000),
            responseType: ResponseType.json,
          ),
        )..interceptors.addAll([
            AuthorizationInterceptor(),
            LoggerInterceptor(),
            LogInterceptor(responseBody: true, requestBody: true)
          ]);

  late final Dio _dio;

  Future<bool?> getToken({required String token}) async {
    bool? tokenvalid;
    try {
      Response userData = await _dio.get(
        'pasien',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      print('User Info: ${userData.statusCode}');

      if (userData.statusCode == 200) {
        return tokenvalid = true;
      } else {
        return tokenvalid = false;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
      return tokenvalid;
    }
  }

  Future<UserModel?> getUser(
      {required String nikOremail, required String token}) async {
    final StorageService _storageService = StorageService();

    UserModel? userModel;
    try {
      Response userData = await _dio.get(
        '${Endpoints.users}/$nikOremail',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      print('User Info: ${userData.data}');

      if (userData.statusCode == 200) {
        final body = userData.data;
        print('User Info: ${userData.data}');
        return UserModel(
            id: int.tryParse(body['data']['id']),
            nama: body['data']['nama'].toString(),
            email: body['data']['email'].toString(),
            username: body['data']['username'].toString(),
            usia: body['data']['usia'].toString(),
            no_hp: body['data']['no_hp'].toString(),
            nik: body['data']['nik'].toString(),
            role: body['data']['role'].toString(),
            jk: body['data']['jk'].toString(),
            alamat: body['data']['alamat'].toString(),
            bb: body['data']['bb'].toString(),
            goldar: body['data']['goldar'].toString(),
            pet_kesehatan: body['data']['pet_kesehatan'].toString(),
            pmo: body['data']['pmo'].toString(),
            kaderTB: body['data']['kaderTB'].toString());
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
      return userModel;
    }
  }

  Future<User?> createUser({required User user}) async {
    User? retrievedUser;
    try {
      Response response = await _dio.post(
        'register',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
        data: user.toJson(),
      );
      print('User created: ${response.data}');
      retrievedUser = User.fromJson(response.data);
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      print('Error creating user: $e');
    }

    return retrievedUser;
  }

  Future<UserModel?> updateUser({
    required UserModel userModel,
    required int id,
  }) async {
    UserModel? updatedUser;
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');

    try {
      Response response = await _dio.put(
        'pasien/$id',
        data: userModel.toJson(),
        options: Options(headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $token'
        }),
      );

      print('User updated: ${response.data}');

      if (response.statusCode == 200) {
        final body = response.data;
        print('User Info: ${response.data}');
        updatedUser = UserModel(
            id: int.tryParse(body['data']['id']),
            nama: body['data']['nama'],
            email: body['data']['email'],
            username: body['data']['username'],
            usia: body['data']['usia'],
            no_hp: body['data']['no_hp'],
            nik: body['data']['nik'],
            alamat: body['data']['alamat'],
            jk: body['data']['jk'],
            bb: body['data']['bb'],
            goldar: body['data']['goldar'],
            pet_kesehatan: body['data']['pet_kesehatan'],
            pmo: body['data']['pmo'],
            kaderTB: body['data']['kaderTB']);
      }
    } catch (e) {
      print('Error updating user: $e');
    }

    return updatedUser;
  }

  Future<void> deleteUser({required String id}) async {
    try {
      await _dio.delete('pasien/$id');
      print('User deleted!');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<String?> login(String nikOremail, String password) async {
    Response response;

    response = await _dio.post('login',
        data: {"nik_or_email": nikOremail, "password": password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ));
    if (response.statusCode == 200) {
      final body = response.data['token'];
      return body;
    } else {
      return null;
    }
  }

  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future<Response> get(
  //   String url, {
  //   Map<String, dynamic>? queryParameters,
  //   Options? options,
  //   CancelToken? cancelToken,
  //   ProgressCallback? onReceiveProgress,
  // }) async {
  //   try {
  //     final Response response = await _dio.get(
  //       url,
  //       queryParameters: queryParameters,
  //       options: options,
  //       cancelToken: cancelToken,
  //       onReceiveProgress: onReceiveProgress,
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<Response> put(
  //   String url, {
  //   data,
  //   Map<String, dynamic>? queryParameters,
  //   Options? options,
  //   CancelToken? cancelToken,
  //   ProgressCallback? onSendProgress,
  //   ProgressCallback? onReceiveProgress,
  // }) async {
  //   try {
  //     final Response response = await _dio.put(
  //       url,
  //       data: data,
  //       queryParameters: queryParameters,
  //       options: options,
  //       cancelToken: cancelToken,
  //       onSendProgress: onSendProgress,
  //       onReceiveProgress: onReceiveProgress,
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<dynamic> delete(
  //   String url, {
  //   data,
  //   Map<String, dynamic>? queryParameters,
  //   Options? options,
  //   CancelToken? cancelToken,
  //   ProgressCallback? onSendProgress,
  //   ProgressCallback? onReceiveProgress,
  // }) async {
  //   try {
  //     final Response response = await _dio.delete(
  //       url,
  //       data: data,
  //       queryParameters: queryParameters,
  //       options: options,
  //       cancelToken: cancelToken,
  //     );
  //     return response.data;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  Future getKeluargaPasien() async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final datakeluarga = await _dio.get(
        'dataKeluarga',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      print('User Info: ${datakeluarga.data}');

      if (datakeluarga.statusCode == 200) {
        final data = datakeluarga.data;

        print('User Info: ${datakeluarga.data}');
        // return Keluarga(
        //     id: int.parse(body['data']['id']),
        //     nama: body['data']['nama'],
        //     usia:body['data']['nama'],
        //     riwayat: body['data']['nama'],
        //     jenis: body['data']['nama'],
        //     id_pasien: body['data']['nama'],
        //     );
        return data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  Future getKeluarga({required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final datakeluarga = await _dio.get(
        'dataKeluarga/$id',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      print('User Info: ${datakeluarga.data}');

      if (datakeluarga.statusCode == 200) {
        final data = datakeluarga.data['data'] as List;

        print('User Info: ${datakeluarga.data}');
        // return Keluarga(
        //     id: int.parse(body['data']['id']),
        //     nama: body['data']['nama'],
        //     usia:body['data']['nama'],
        //     riwayat: body['data']['nama'],
        //     jenis: body['data']['nama'],
        //     id_pasien: body['data']['nama'],
        //     );
        return data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  Future<Keluarga?> createKeluarga(
      {required id_pasien, nama, jenis, usia, riwayat}) async {
    Keluarga? retrievedKeluarga;
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      Response response = await _dio.post('dataKeluarga',
          data: {
            "id_pasien": id_pasien,
            "nama": nama,
            'jenis': jenis,
            'usia': usia,
            'riwayat': riwayat
          },
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      print('Info keluarga created: ${response.data}');
      retrievedKeluarga = Keluarga.fromJson(response.data);
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      print('Error creating info keluarga: $e');
    }

    return retrievedKeluarga;
  }

  Future<void> deleteKeluarga({required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      await _dio.delete('dataKeluarga/$id',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      print('Data Keluarga Delete!');
    } catch (e) {
      print('Error deleting data keluarga: $e');
    }
  }

  Future<Keluarga?> updatekeluarga(
      {required Keluarga keluarga, required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      Response response = await _dio.put(
        'dataKeluarga/$id',
        data: keluarga.toJson(),
        options: Options(headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $token'
        }),
      );

      print('Keluarga updated: ${response.data}');

      if (response.statusCode == 200) {
        final body = response.data;
      }
    } catch (e) {
      print('Error updating user: $e');
    }

    return null;
  }

  //efek
  Future getEfek({required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');

    try {
      final efekObat = await _dio.get(
        'efekObat/$id',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      if (efekObat.statusCode == 200) {
        final data = efekObat.data;
        return data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  Future<Efek?> createEfek(
      {required id_pasien,
      required judul,
      required p_awal,
      required p_akhir,
      required dosis,
      lupa,
      required efek}) async {
    Efek? retrievedEfek;
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      Response response = await _dio.post('efekObat',
          data: {
            "id_pasien": id_pasien,
            "awal": p_awal,
            "akhir": p_akhir,
            'dosis': dosis,
            'lupa': lupa,
            'efeksamping': efek,
            'judul': judul
          },
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      print('Info efek created: ${response.data}');
      retrievedEfek = Efek.fromJson(response.data);
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      print('Error creating info keluarga: $e');
    }

    return retrievedEfek;
  }

  Future deleteEfek({required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final response = await _dio.delete('efekObat/$id',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      print('Data Efek Delete!');
      if (response.statusCode == 200) {
        final body = response.data;
        return body;
      }
    } catch (e) {
      print('Error deleting data efek: $e');
    }
  }

  Future updateEfek({required Efek efek, required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      Response response = await _dio.put(
        'efekObat/$id',
        data: efek.toJson(),
        options: Options(headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $token'
        }),
      );

      print('Efek updated: ${response.data}');

      if (response.statusCode == 200) {
        final body = response.data;
        return body;
      }
    } catch (e) {
      print('Error updating efek: $e');
    }

    return null;
  }

  //pengingat
  Future getPengingat({required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');

    try {
      final pengingatObat = await _dio.get(
        'pengingatObat/$id',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      if (pengingatObat.statusCode == 200) {
        final data = pengingatObat.data;

        return data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  Future<Pengingat?> createPengingat(
      {required id_pasien, required judul, hari, waktu}) async {
    Pengingat? retrievedPengingat;
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      Response response = await _dio.post('pengingatObat',
          data: {
            "id_pasien": id_pasien.toString(),
            "judul": judul.toString(),
            "waktu": waktu.toString(),
            'hari': [hari].map((i) => i.toString()).join(",").toString(),
          },
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      final body = response.data;
      List<int> list = body['hari']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',')
          .map<int>((e) {
        return int.parse(
            e); //use tryParse if you are not confirm all content is int or require other handling can also apply it here
      }).toList();
      print('Info efek created: ${response.data}');
      retrievedPengingat = Pengingat(
          id: int.tryParse(body['id'].toString()),
          id_pasien: int.tryParse(body['id_pasien'].toString()),
          waktu: DateTime.parse(body['waktu'].toString()),
          hari: list,
          judul: body['judul']);
      print('Info pengingat created :  $retrievedPengingat');
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      print('Error creating info keluarga: $e');
    }

    return retrievedPengingat;
  }

  Future deletePengingat({required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final deteletP = await _dio.delete('pengingatObat/$id',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      print('Data Efek Delete!');
      if (deteletP.statusCode == 200) {
        final data = deteletP.data;

        return data;
      } else {
        return null;
      }
    } catch (e) {
      print('Error deleting data efek: $e');
    }
  }

  Future updatePengingat(
      {required id_pasien,
      required judul,
      hari,
      waktu,
      required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      Response response = await _dio.put(
        'pengingatObat/$id',
        data: {
          "id_pasien": id_pasien.toString(),
          "judul": judul.toString(),
          "waktu": waktu.toString(),
          'hari': [hari].map((i) => i.toString()).join(",").toString(),
        },
        options: Options(headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $token'
        }),
      );

      print('Efek updated: ${response.data}');

      if (response.statusCode == 200) {
        final body = response.data;
        return body;
      }
    } catch (e) {
      print('Error updating efek: $e');
    }

    return null;
  }

  //pengambilan
  Future getPengambilan({required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');

    try {
      final PengambilanObat = await _dio.get(
        'pengambilanObat/$id',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      if (PengambilanObat.statusCode == 200) {
        final data = PengambilanObat.data;

        return data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  Future<Pengambilan?> createPengambilan(
      {required id_pasien,
      required awal,
      required ambil,
      required lokasi,
      time}) async {
    Pengambilan? retrievedPengambilan;
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      Response response = await _dio.post('pengambilanObat',
          data: {
            "id_pasien": id_pasien.toString(),
            "awal": awal.toString(),
            "ambil": ambil.toString(),
            'lokasi': lokasi.toString(),
            'time': time.toString()
          },
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      final body = response.data;
      retrievedPengambilan = Pengambilan(
          id: int.tryParse(body['id'].toString()),
          id_pasien: int.tryParse(body['id_pasien'].toString()),
          time: DateTime.parse(body['time'].toString()),
          awal: DateTime.parse(body['awal'].toString()),
          ambil: DateTime.parse(body['ambil'].toString()),
          lokasi: body['lokasi']);
      print('Info Pengambilan created :  $retrievedPengambilan');
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      print('Error creating info keluarga: $e');
    }

    return retrievedPengambilan;
  }

  Future deletePengambilan({required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final response = await _dio.delete('pengambilanObat/$id',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      print('Data Efek Delete!');
      if (response.statusCode == 200) {
        final body = response.data;
        return body;
      }
    } catch (e) {
      print('Error deleting data efek: $e');
    }
  }

  Future updatePengambilan(
      {required id_pasien,
      time,
      required awal,
      required ambil,
      required lokasi,
      required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      Response response = await _dio.put(
        'pengambilanObat/$id',
        data: {
          "id_pasien": id_pasien.toString(),
          "time": time.toString(),
          "awal": awal.toString(),
          "ambil": ambil.toString(),
          'lokasi': lokasi.toString(),
        },
        options: Options(headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $token'
        }),
      );

      print('Efek updated: ${response.data}');

      if (response.statusCode == 200) {
        final body = response.data;
        return body;
      }
    } catch (e) {
      print('Error updating efek: $e');
    }

    return null;
  }

  //periksa
  Future getPeriksa({required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');

    try {
      final PeriksaDahak = await _dio.get(
        'periksaDahak/$id',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      if (PeriksaDahak.statusCode == 200) {
        final data = PeriksaDahak.data;

        return data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  Future<Periksa?> createPeriksa(
      {required id_pasien,
      required sebelumnya,
      required selanjutnya,
      required lokasi_periksa,
      time}) async {
    Periksa? retrievedPeriksa;
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      Response response = await _dio.post('periksaDahak',
          data: {
            "id_pasien": id_pasien.toString(),
            "time": time.toString(),
            'sebelumnya': sebelumnya.toString(),
            'selanjutnya': selanjutnya.toString(),
            'lokasi_periksa': lokasi_periksa.toString()
          },
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      final body = response.data;
      retrievedPeriksa = Periksa(
          id: int.tryParse(body['id'].toString()),
          id_pasien: int.tryParse(body['id_pasien'].toString()),
          time: DateTime.parse(body['time'].toString()),
          sebelumnya: DateTime.parse(body['sebelumnya'].toString()),
          selanjutnya: DateTime.parse(body['selanjutnya'].toString()),
          lokasi_periksa: body['lokasi_periksa']);
      print('Info Pengambilan created :  $retrievedPeriksa');
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      print('Error creating info keluarga: $e');
    }

    return retrievedPeriksa;
  }

  Future deletePeriksa({required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final response = await _dio.delete('periksaDahak/$id',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      print('Data Efek Delete!');
      if (response.statusCode == 200) {
        final body = response.data;
        return body;
      }
    } catch (e) {
      print('Error deleting data efek: $e');
    }
  }

  Future updatePeriksa(
      {required id_pasien,
      time,
      required sebelumnya,
      required selanjutnya,
      required lokasi_periksa,
      required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      Response response = await _dio.put(
        'periksaDahak/$id',
        data: {
          "id_pasien": id_pasien.toString(),
          "time": time.toString(),
          "sebelumnya": sebelumnya.toString(),
          "selanjutnya": selanjutnya.toString(),
          'lokasi_periksa': lokasi_periksa.toString(),
        },
        options: Options(headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $token'
        }),
      );

      print('Efek updated: ${response.data}');

      if (response.statusCode == 200) {
        final body = response.data;
        return body;
      }
    } catch (e) {
      print('Error updating efek: $e');
    }

    return null;
  }

  //edukasi
  Future getEdukasi() async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final edukasi = await _dio.get(
        'edukasi',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      print('User Info: ${edukasi.data}');

      if (edukasi.statusCode == 200) {
        final data = edukasi.data;
        // return Edukasi(
        //     id: int.parse(body['data']['id']),
        //     nama: body['data']['nama'],
        //     usia:body['data']['nama'],
        //     riwayat: body['data']['nama'],
        //     jenis: body['data']['nama'],
        //     id_pasien: body['data']['nama'],
        //     );
        return data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  Future createEdukasi(
      {required judul,
      required isi,
      required media,
      required created_by,
      required created_at}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      FormData formData = FormData.fromMap({
        "judul": judul.toString(),
        "isi": isi.toString(),
        "media": media != null
            ? await MultipartFile.fromFile(media.path,
                filename: media.toString().split("/").last)
            : '',
        'created_by': created_by.toString(),
        'created_at': created_at.toString()
      });
      Response response = await _dio.post('edukasi',
          data: formData,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      print('Info Edukasi created: ${response.data}');
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      print('Error creating info Edukasi: $e');
    }

    return null;
  }

  Future<void> deleteEdukasi({required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      await _dio.delete('edukasi/$id',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      print('Data Edukasi Delete!');
    } catch (e) {
      print('Error deleting data Edukasi: $e');
    }
  }

  Future<Edukasi?> updateEdukasi(
      {judul, isi, media, update_at, required int id}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');

    try {
      FormData formData = FormData.fromMap({
        "judul": judul.toString(),
        "isi": isi.toString(),
        "media": media != null
            ? await MultipartFile.fromFile(media.path,
                filename: media.toString().split("/").last)
            : '',
        'update_at': update_at.toString(),
      });
      Response response = await _dio.post(
        'edukasi/update/$id',
        data: formData,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      print('Edukasi updated: ${response.data}');

      if (response.statusCode == 200) {
        final body = response.data;
      }
    } catch (e) {
      print('Error updating user: $e');
    }

    return null;
  }

  Future<Edukasi?> showEdukasi(int id) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final edukasi = await _dio.get(
        'edukasi/$id',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      print('User Info: ${edukasi.data}');

      if (edukasi.statusCode == 200) {
        final data = edukasi.data;
        return Edukasi(
          id: int.tryParse(data['id']),
          judul: data['judul'].toString(),
          isi: data['isi'].toString(),
          media: data['media'].toString(),
          created_by: int.tryParse(data['created_by']),
          created_at: DateTime.tryParse(data['created_at']),
        );
        // return data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
    return null;
  }

  Future getPasien() async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final userData = await _dio.get(
        'pasien',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      print('User Info: ${userData.statusCode}');

      if (userData.statusCode == 200) {
        final data = userData.data;

        return data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  Future<List<Quiz>> getQuizzes() async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');

    List<Quiz> quizzes = [];

    try {
      Response response = await _dio.get(
        'QuizController',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> quizData = response.data;
        quizzes = quizData.map((data) => Quiz.fromJson(data)).toList();
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
    }

    return quizzes;
  }

  Future getQuiz() async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final quiz = await _dio.get(
        'QuizController',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      print('User Info: ${quiz.statusCode}');

      if (quiz.statusCode == 200) {
        final data = quiz.data;
        return data;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
    return null;
  }

  Future<Quizez?> getQuizz(int id) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final quiz = await _dio.get(
        'QuizController/$id',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      print('User Info: ${quiz.statusCode}');

      if (quiz.statusCode == 200) {
        final data = quiz.data;
        return Quizez(
          quiz: data['quiz'],
          question: data['question'],
          answer: data['answer'],
        );
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
    return null;
  }

  Future<bool> createQuiz({required Quiz quiz}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    bool success = false;

    try {
      Response response = await _dio.post(
        'QuizController',
        data: quiz.toJson(),
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      if (response.statusCode == 201) {
        success = true;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
    }

    return success;
  }

  Future<bool> updateQuiz({required Quiz quiz}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    bool success = false;

    try {
      Response response = await _dio.put(
        'QuizController/${quiz.id}',
        data: quiz.toJson(),
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      if (response.statusCode == 200) {
        success = true;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
    }

    return success;
  }

  Future deleteQuiz({required int quizId}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    bool success = false;

    try {
      Response response = await _dio.delete(
        'QuizController/$quizId',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      if (response.statusCode == 200) {
        success = true;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
    }

    return success;
  }

  Future getHasil(int id) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final quiz = await _dio.get(
        'HasilQuizController/$id',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      print('User Info: ${quiz.statusCode}');

      if (quiz.statusCode == 200) {
        final data = quiz.data;
        return data;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
    return null;
  }

  Future postHasil({required Hasil_kuis hasil_kuis}) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final quiz = await _dio.post(
        'HasilQuizController',
        data: {
          'id_pasien': hasil_kuis.id_pasien,
          'id_quiz': hasil_kuis.id_quiz,
          'hasil': hasil_kuis.hasil.toString()
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      print('User Info: ${quiz.statusCode}');

      if (quiz.statusCode == 200) {
        final data = quiz.data;
        return data;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
    return null;
  }

  Future getStatusQuiz() async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    try {
      final quiz = await _dio.get(
        'StatusQuizController',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      print('User Info: ${quiz.statusCode}');

      if (quiz.statusCode == 200) {
        final data = quiz.data;
        return data;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
    return null;
  }

  Future updateStatusQuiz({
    required id,
    required id_quiz,
  }) async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    bool success = false;

    try {
      Response response = await _dio.put(
        'StatusQuizController/$id',
        data: {
          "quiz_id": id_quiz,
        },
        options: Options(headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $token'
        }),
      );

      if (response.statusCode == 200) {
        success = true;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
    }

    return success;
  }

  Future forgotPassowrd({required String email}) async {
    try {
      final forgot = await _dio.post(
        'forgotPassword',
        data: {
          'email': email,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      print('User Info: ${forgot.statusCode}');

      if (forgot.statusCode == 200) {
        final data = forgot.data;
        return data;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
    return null;
  }

  Future resetPassowrd(
      {required String token, required String password}) async {
    try {
      final hasil = await _dio.post(
        'resetPassword',
        data: {'token': token, 'password': password},
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      print('User Info: ${hasil.statusCode}');

      if (hasil.statusCode == 200) {
        final data = hasil.data;
        return data;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
    return null;
  }
}
