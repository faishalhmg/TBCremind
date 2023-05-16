// import 'package:dio/dio.dart';

// class ApiClient {
//   final Dio _dio = Dio();

//   Future<Response> registerUser(Map<String, dynamic>? userData) async {
//     try {
//       Response response =
//           await _dio.post('http://localhost:8080/api/register', //ENDPONT URL
//               data: userData, //REQUEST BODY
//               options: Options(headers: {
//                 'X-LoginRadius-Sott': 'YOUR_SOTT_KEY', //HEADERS
//               }));
//       //returns the successful json object
//       return response.data;
//     } on DioError catch (e) {
//       //returns the error object if there is
//       return e.response!.data;
//     }
//   }

//   Future<Response> login(String nikOrEmail, String password) async {
//     try {
//       Response response = await _dio.post(
//         'http://localhost:8080/api/login',
//         data: {'nik_or_email': nikOrEmail, 'password': password},
        
//       );
//       //returns the successful user data json object
//       return response.data;
//     } on DioError catch (e) {
//       //returns the error object if any
//       return e.response!.data;
//     }
//   }

//   Future<Response> getUserProfileData(String accesstoken) async {
//     try {
//       Response response = await _dio.get(
//         'http://localhost:8080/api/pasien',
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer ${YOUR_ACCESS_TOKEN}',
//           },
//         ),
//       );
//       return response.data;
//     } on DioError catch (e) {
//       return e.response!.data;
//     }
//   }

//    Future<Response> logout(String accessToken) async {
//         try {
//           Response response = await _dio.get(
//             'https://api.loginradius.com/identity/v2/auth/access_token/InValidate',
//             options: Options(
//               headers: {'Authorization': 'Bearer $accessToken'},
//             ),
//           );
//           return response.data;
//         } on DioError catch (e) {
//           return e.response!.data;
//         }
//       }
// }
