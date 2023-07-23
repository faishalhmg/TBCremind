import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tbc_app/data/Models/efek/efek.dart';
import 'package:tbc_app/data/dio/DioClient.dart';

part 'efek_event.dart';
part 'efek_state.dart';

class EfekBloc extends Bloc<EfekEvent, EfekState> {
  final DioClient _dioClient;

  EfekBloc(this._dioClient) : super(EfekLoadingState()) {
    on<LoadEfekEvent>((event, emit) async {
      emit(EfekLoadingState());
      try {
        final efek = await _dioClient.getEfek(id: event.id);
        emit(EfekLoadedState(efek));
      } catch (e) {
        emit(EfekErrorState(e.toString()));
      }
    });
    on<AddEfekEvent>(
      (event, emit) async {
        if (state is EfekLoadedState) {
          try {
            final efek = await _dioClient.createEfek(
                judul: event.judul,
                dosis: event.dosis,
                efek: event.efek,
                id_pasien: event.id_pasien,
                p_akhir: event.p_akhir,
                p_awal: event.p_awal,
                lupa: event.lupa);
            if (efek != null) {
              emit(EfekLoadingState());
              final efek = await _dioClient.getEfek(id: event.id_pasien);
              emit(EfekLoadedState(efek));
            }
          } catch (e) {
            emit(EfekErrorState(e.toString()));
          }
        }
      },
    );
    on<UpdateEfekEvent>(
      (event, emit) async {
        if (state is EfekLoadedState) {
          try {
            final efek = await _dioClient.updateEfek(
                efek: Efek(
                    id: event.id,
                    judul: event.judul,
                    p_awal: event.p_awal,
                    p_akhir: event.p_akhir,
                    dosis: event.dosis,
                    lupa: event.lupa,
                    efek: event.efek),
                id: event.id);
            if (efek != null) {
              emit(EfekLoadingState());
              final efek = await _dioClient.getEfek(id: event.id_pasien);
              emit(EfekLoadedState(efek));
            }
          } catch (e) {
            emit(EfekErrorState(e.toString()));
          }
        }
      },
    );
    on<DeleteEfekEvent>((event, emit) async {
      if (state is EfekLoadedState) {
        try {
          final efek = await _dioClient.deleteEfek(id: event.id);
          final efek1 = await _dioClient.getEfek(id: event.id_pasien);
          emit(EfekLoadedState(efek1));
        } catch (e) {
          emit(EfekErrorState(e.toString()));
        }
      }
    });
  }
}
