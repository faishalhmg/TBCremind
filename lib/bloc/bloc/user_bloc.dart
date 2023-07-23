import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/service/StorageService.dart';
import 'package:tbc_app/service/storageitem.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final DioClient _dioClient = DioClient();
  UserBloc() : super(UserSignedOut()) {
    on<SignIn>((event, emit) async {
      if (state is UserSignedOut) {
        String? token =
            await _dioClient.login(event.nikOremail, event.password);
        if (token != null) {
          UserModel? userModel = await _dioClient.getUser(
              nikOremail: event.nikOremail, token: token);
          final StorageService _storageService = StorageService();
          await _storageService.writeSecureData(StorageItem('token', token));
          if (userModel != null) {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString('nikOremail', event.nikOremail);
            pref.setString('token', token);
            await _storageService
                .writeSecureData(StorageItem('id', userModel.id.toString()));
            await _storageService
                .writeSecureData(StorageItem('nikOremail', event.nikOremail));
            await _storageService
                .writeSecureData(StorageItem('password', event.password));
            await _storageService.writeSecureData(
                StorageItem('role', userModel.role.toString()));

            emit(UserSignedIn(userModel: userModel));
          }
        }
      }
    });
    on<SignOut>((event, emit) async {
      if (state is UserSignedIn) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        final StorageService _storageService = StorageService();
        _storageService.deleteAllSecureData();
        pref.remove('nikOremail');
        pref.remove('token');

        emit(UserSignedOut());
      }
    });
    on<CheckSignInStatus>((event, emit) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? nikOremail = pref.getString('nikOremail');
      // String? token = pref.getString('token');
      final StorageService _storageService = StorageService();
      String? token = await _storageService.readSecureData('token');
      String? nikOremail1 = await _storageService.readSecureData('nikOremail');
      String? password = await _storageService.readSecureData('password');

      if (nikOremail != null && token != null) {
        bool? tokenValid = await _dioClient.getToken(token: token);
        if (tokenValid == true) {
          UserModel? userModel =
              await _dioClient.getUser(nikOremail: nikOremail, token: token);
          if (userModel != null) {
            emit(UserSignedIn(userModel: userModel));
          }
        } else {
          String? token = await _dioClient.login(nikOremail1!, password!);
          if (token != null) {
            UserModel? userModel =
                await _dioClient.getUser(nikOremail: nikOremail1, token: token);
            if (userModel != null) {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString('nikOremail', nikOremail1);
              pref.setString('token', token);
              final StorageService _storageService = StorageService();

              await _storageService
                  .writeSecureData(StorageItem('token', token));
              await _storageService
                  .writeSecureData(StorageItem('id', userModel.id.toString()));
              await _storageService
                  .writeSecureData(StorageItem('nikOremail', nikOremail1));
              await _storageService
                  .writeSecureData(StorageItem('password', password));

              emit(UserSignedIn(userModel: userModel));
            }
          }
        }
      }
    });
    on<UpdateProfile>((event, emit) async {
      try {
        if (state is UserSignedIn) {
          UserModel? userModel = await _dioClient.updateUser(
              id: event.id, userModel: event.userModel);
          emit(UserLoadedState(userModel!));
          if (userModel != null) {
            emit(UserLoadingState());
            emit(UserSignedIn(userModel: userModel));
          } else {
            emit(UserSignedOut());
          }
        }
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });
    on<loadProfile>((event, emit) async {
      try {
        if (state is UserSignedIn) {
          UserModel? userModel = await _dioClient.getUser(
              nikOremail: event.nikOremail, token: event.token);
          if (userModel != null) {
            emit(UserLoadingState());
            emit(UserSignedIn(userModel: userModel));
          } else {
            emit(UserSignedOut());
          }
        }
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });
  }
}
