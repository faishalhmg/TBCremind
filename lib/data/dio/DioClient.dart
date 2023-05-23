import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbc_app/data/Models/keluarga/keluarga.dart';

import 'package:tbc_app/data/Models/user/user.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/AuthorizationInterceptor.dart';
import 'package:tbc_app/data/dio/LoggerInterceptor.dart';
import 'package:tbc_app/data/dio/dio_exception.dart';
import 'package:tbc_app/data/dio/endpoints.dart';
import 'package:tbc_app/service/StorageService.dart';
import 'package:tbc_app/service/storageitem.dart';

class DioClient {
  DioClient([Dio? dio])
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://tbc.restikol.my.id/api/',
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

    // Future<Response> login(String nikOrEmail, String password) async {
    //   try {
    //     Response response = await _dio.post(
    //       'login',
    //       data: {'nik_or_email': nikOrEmail, 'password': password},
    //     );
    //     //returns the successful user data json object
    //     return response.data;
    //   } on DioError catch (e) {
    //     //returns the error object if any
    //     return e.response!.data;
    //   }
    // }
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
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

  Future<dynamic> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
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
  // HTTP request methods will go here
}
