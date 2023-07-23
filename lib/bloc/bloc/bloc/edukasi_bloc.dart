import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tbc_app/data/Models/edukasi/edukasi.dart';
import 'package:tbc_app/data/dio/DioClient.dart';

part 'edukasi_event.dart';
part 'edukasi_state.dart';

class EdukasiBloc extends Bloc<EdukasiEvent, EdukasiState> {
  final DioClient _dioClient;
  EdukasiBloc(this._dioClient) : super(EdukasiLoadingState()) {
    on<LoadEdukasiEvent>((event, emit) async {
      emit(EdukasiLoadingState());
      try {
        final edukasi = await _dioClient.getEdukasi();
        emit(EdukasiLoadedState(edukasi));
      } catch (e) {
        emit(EdukasiErrorState(e.toString()));
      }
    });
    on<AddEdukasiEvent>((event, emit) async {
      try {
        final edukasi = await _dioClient.createEdukasi(
            judul: event.judul,
            isi: event.isi,
            media: event.media,
            created_by: event.created_by,
            created_at: event.created_at);
        if (edukasi != null) {
          emit(EdukasiLoadingState());
          final edukasi = await _dioClient.getEdukasi();
          emit(EdukasiLoadedState(edukasi));
        }
      } catch (e) {
        emit(EdukasiErrorState(e.toString()));
      }
    });
    on<UpdateEdukasiEvent>(
      (event, emit) async {
        try {
          if (state is Edukasi1LoadedState) {
            final edukasi1 = await _dioClient.updateEdukasi(
                judul: event.judul,
                isi: event.isi,
                media: event.media,
                update_at: event.update_at,
                id: event.id);
            if (edukasi1 != null) {
              emit(EdukasiLoadingState());
              final edukasi = await _dioClient.getEdukasi();
              emit(EdukasiLoadedState(edukasi));
            }
          }
        } catch (e) {
          emit(EdukasiErrorState(e.toString()));
        }
      },
    );
    on<DeleteEdukasiEvent>((event, emit) async {
      if (state is EdukasiLoadedState) {
        try {
          final edukasi = await _dioClient.deleteEdukasi(id: event.id);
          final edukasi1 = await _dioClient.getEdukasi();
          emit(EdukasiLoadedState(edukasi1));
        } catch (e) {
          emit(EdukasiErrorState(e.toString()));
        }
      }
    });
    on<LoadEdukasi1Event>((event, emit) async {
      emit(EdukasiLoadingState());
      try {
        final edukasi = await _dioClient.showEdukasi(event.id);
        emit(Edukasi1LoadedState(edukasi: edukasi!));
      } catch (e) {
        emit(EdukasiErrorState(e.toString()));
      }
    });
  }
}
