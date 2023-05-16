// import 'package:dio/dio.dart';
// import 'package:tbc_app/data/Models/user.dart';
// import 'package:tbc_app/data/Models/user_model.dart';
// import 'package:tbc_app/data/dio/UserApi.dart';
// import 'package:tbc_app/data/dio/dio_exception.dart';

// class UserRepository {
//   final UserApi userApi;

//   UserRepository(this.userApi);

//   Future<List<UserModel>> getUsersRequested(int id) async {
//     try {
//       final response = await userApi.getUsersApi(id);
//       final users = (response.data['data'] as List)
//           .map((e) => UserModel.fromJson(e))
//           .toList();
//       return users;
//     } on DioError catch (e) {
//       final errorMessage = DioException.fromDioError(e).toString();
//       throw errorMessage;
//     }
//   }

//   Future<User> addNewUserRequested(
//       String nama,
//       String username,
//       String email,
//       String nik,
//       String password,
//       String alamat,
//       String usia,
//       String no_hp,
//       String goldar,
//       String bb,
//       String kaderTB,
//       String pmo,
//       String pet_kesehatan,
//       String jk) async {
//     try {
//       final response = await userApi.addUserApi(
//           nama,
//           username,
//           email,
//           nik,
//           password,
//           alamat,
//           usia,
//           no_hp,
//           goldar,
//           bb,
//           kaderTB,
//           pmo,
//           pet_kesehatan,
//           jk);
//       return User.fromJson(response.data);
//     } on DioError catch (e) {
//       final errorMessage = DioException.fromDioError(e).toString();
//       throw errorMessage;
//     }
//   }

//   Future<User> updateUserRequested(
//       int id,
//       String nama,
//       String username,
//       String email,
//       String nik,
//       String password,
//       String alamat,
//       String usia,
//       String no_hp,
//       String goldar,
//       String bb,
//       String kaderTB,
//       String pmo,
//       String pet_kesehatan,
//       String jk) async {
//     try {
//       final response = await userApi.updateUserApi(
//           id,
//           nama,
//           username,
//           email,
//           nik,
//           password,
//           alamat,
//           usia,
//           no_hp,
//           goldar,
//           bb,
//           kaderTB,
//           pmo,
//           pet_kesehatan,
//           jk);
//       return User.fromJson(response.data);
//     } on DioError catch (e) {
//       final errorMessage = DioException.fromDioError(e).toString();
//       throw errorMessage;
//     }
//   }

//   Future<void> deleteNewUserRequested(int id) async {
//     try {
//       await userApi.deleteUserApi(id);
//     } on DioError catch (e) {
//       final errorMessage = DioException.fromDioError(e).toString();
//       throw errorMessage;
//     }
//   }
// }
