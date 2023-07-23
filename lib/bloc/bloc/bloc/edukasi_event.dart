part of 'edukasi_bloc.dart';

abstract class EdukasiEvent extends Equatable {
  const EdukasiEvent();
}

class LoadEdukasiEvent extends EdukasiEvent {
  const LoadEdukasiEvent();
  @override
  List<Object> get props => [];
}

class LoadEdukasi1Event extends EdukasiEvent {
  final int id;
  const LoadEdukasi1Event({required this.id});
  @override
  List<Object> get props => [id];
}

class AddEdukasiEvent extends EdukasiEvent {
  final String judul;
  final String isi;
  final File? media;
  final int created_by;
  final DateTime created_at;

  const AddEdukasiEvent(
      {required this.judul,
      required this.isi,
      required this.media,
      required this.created_by,
      required this.created_at});
  @override
  List<Object> get props => [judul, isi, media!, created_by, created_at];
}

class DeleteEdukasiEvent extends EdukasiEvent {
  final int id;
  final int created_by;

  const DeleteEdukasiEvent({required this.id, required this.created_by});
  @override
  List<Object> get props => [id];
}

class UpdateEdukasiEvent extends EdukasiEvent {
  final String judul;
  final String isi;
  final File? media;
  final int created_by;
  final DateTime update_at;
  final int id;

  const UpdateEdukasiEvent({
    required this.id,
    required this.judul,
    required this.isi,
    this.media,
    required this.created_by,
    required this.update_at,
  });
  @override
  List<Object> get props => [id, judul, isi, media!, created_by, update_at];
}
