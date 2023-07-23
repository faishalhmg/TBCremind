import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/service/StorageService.dart';

part 'pasien_event.dart';
part 'pasien_state.dart';

class PasienBloc extends Bloc<PasienEvent, PasienState> {
  final DioClient _dioClient;
  PasienBloc(this._dioClient) : super(PasienLoadingState()) {
    on<LoadPasienEvent>((event, emit) async {
      emit(PasienLoadingState());
      try {
        final userModel = await _dioClient.getPasien();

        if (userModel != null) {
          emit(UserPasienState(userModel));
        }
      } catch (e) {
        emit(PasienErrorState(e.toString()));
      }
    });

    on<LoadedPasienEvent>((event, emit) async {
      emit(PasienLoadingState());
      try {
        final StorageService _storageService = StorageService();
        String? token = await _storageService.readSecureData('token');
        final userModel = await _dioClient.getUser(
            nikOremail: event.nikOremail, token: token!);

        if (userModel != null) {
          emit(LoadPasienState(userModel));
        }
      } catch (e) {
        emit(PasienErrorState(e.toString()));
      }
    });
  }
}
