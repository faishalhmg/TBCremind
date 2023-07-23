import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tbc_app/data/Models/keluarga/keluarga.dart';

import 'package:tbc_app/data/dio/DioClient.dart';

part 'keluarga_event.dart';
part 'keluarga_state.dart';

class KeluargaBloc extends Bloc<KeluargaEvent, KeluargaState> {
  final DioClient _dioClient;

  KeluargaBloc(this._dioClient) : super(KeluargaLoadingState()) {
    on<LoadKeluargaEvent>((event, emit) async {
      emit(KeluargaLoadingState());
      try {
        final keluarga = await _dioClient.getKeluarga(id: event.id);
        emit(KeluargaLoadedState(keluarga));
      } catch (e) {
        emit(KeluargaErrorState(e.toString()));
      }
    });
    on<AddKeluargaEvent>(
      (event, emit) async {
        try {
          final keluarga = await _dioClient.createKeluarga(
              id_pasien: event.id_pasien,
              nama: event.nama,
              usia: event.usia,
              riwayat: event.riwayat,
              jenis: event.jenis);
          if (keluarga != null) {
            emit(KeluargaLoadingState());
            final keluarga = await _dioClient.getKeluarga(id: event.id_pasien);
            emit(KeluargaLoadedState(keluarga));
          }
        } catch (e) {
          emit(KeluargaErrorState(e.toString()));
        }
      },
    );
    on<UpdateKeluargaEvent>(
      (event, emit) async {
        if (state is KeluargaLoadedState) {
          try {
            final keluarga = await _dioClient.updatekeluarga(
                keluarga: Keluarga(
                    id: event.id,
                    nama: event.nama,
                    usia: event.usia,
                    riwayat: event.riwayat,
                    jenis: event.jenis,
                    id_pasien: event.id_pasien),
                id: event.id);
            if (keluarga != null) {
              emit(KeluargaLoadingState());
              final keluarga =
                  await _dioClient.getKeluarga(id: event.id_pasien);
              emit(KeluargaLoadedState(keluarga));
            }
          } catch (e) {
            emit(KeluargaErrorState(e.toString()));
          }
        }
      },
    );
    on<DeleteKeluargaEvent>((event, emit) async {
      if (state is KeluargaLoadedState) {
        try {
          final keluarga = await _dioClient.deleteKeluarga(id: event.id);
          final keluarga1 = await _dioClient.getKeluarga(id: event.id_pasien);
          emit(KeluargaLoadedState(keluarga1));
        } catch (e) {
          emit(KeluargaErrorState(e.toString()));
        }
      }
    });
    on<LoadedKeluargaEvent>((event, emit) async {
      emit(KeluargaLoadingState());
      try {
        final keluarga = await _dioClient.getKeluargaPasien();
        emit(KeluargaLoadedState1(keluarga));
      } catch (e) {
        emit(KeluargaErrorState(e.toString()));
      }
    });
  }
}
