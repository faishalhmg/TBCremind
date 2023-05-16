// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:tbc_app/data/dio/DioClient.dart';
// import 'package:tbc_app/data/dio/UserApi.dart';

// import '../data/UserRepository .dart';

// final getIt = GetIt.instance;

// Future<void> setup() async {
//   getIt.registerSingleton(Dio());
//   getIt.registerSingleton(DioClient(getIt<Dio>()));
//   getIt.registerSingleton(UserApi(dioClient: getIt<DioClient>()));
//   getIt.registerSingleton(UserRepository(getIt.get<UserApi>()));
// }
