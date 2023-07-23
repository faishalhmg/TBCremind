part of 'edukasi_bloc.dart';

@immutable
abstract class EdukasiState extends Equatable {}

//data loading state
class EdukasiLoadingState extends EdukasiState {
  @override
  List<Object?> get props => [];
}

class EdukasiLoadedState extends EdukasiState {
  List edukasi = [];
  EdukasiLoadedState(this.edukasi);
  @override
  List<Object?> get props => [edukasi];
}

class Edukasi1LoadedState extends EdukasiState {
  final Edukasi edukasi;
  Edukasi1LoadedState({required this.edukasi});
  @override
  List<Object?> get props => [edukasi];
}

class EdukasiErrorState extends EdukasiState {
  final String error;
  EdukasiErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

class EdukasiAddState extends EdukasiState {
  List edukasi = [];
  EdukasiAddState(this.edukasi);
  @override
  List<Object?> get props => [edukasi];
}

class EdukasiUpdateState extends EdukasiState {
  List edukasi = [];

  EdukasiUpdateState(this.edukasi);
  @override
  List<Object?> get props => [edukasi];
}
