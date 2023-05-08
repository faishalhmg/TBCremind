import 'package:dio/dio.dart';
import 'package:tbc_app/data/Models/user.dart';
import 'package:tbc_app/data/dio/dio_exception.dart';
import 'package:tbc_app/data/dio/endpoints.dart';

class DioClient {
  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://localhost/tbcrestapi/public/',
            connectTimeout: Duration(seconds: 5000),
            receiveTimeout: Duration(seconds: 3000),
            responseType: ResponseType.json,
          ),
        );

  late final Dio _dio;

  Future<User?> getUser({required int id}) async {
    try {
      final response = await _dio.get('${Endpoints.users}/$id');
      return User.fromJson(response.data);
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  // HTTP request methods will go here
}
