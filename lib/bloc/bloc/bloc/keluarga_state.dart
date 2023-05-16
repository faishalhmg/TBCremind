part of 'keluarga_bloc.dart';

@immutable
abstract class KeluargaState extends Equatable {}

//data loading state
class KeluargaLoadingState extends KeluargaState {
  @override
  List<Object?> get props => [];
}

class KeluargaLoadedState extends KeluargaState {
  List keluarga = [];
  KeluargaLoadedState(this.keluarga);
  @override
  List<Object?> get props => [keluarga];
}

class KeluargaErrorState extends KeluargaState {
  final String error;
  KeluargaErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

class KeluargaAddState extends KeluargaState {
  List keluarga = [];
  KeluargaAddState(this.keluarga);
  @override
  List<Object?> get props => [keluarga];
}

class KeluargaUpdateState extends KeluargaState {
  List keluarga = [];

  KeluargaUpdateState(this.keluarga);
  @override
  List<Object?> get props => [keluarga];
}
