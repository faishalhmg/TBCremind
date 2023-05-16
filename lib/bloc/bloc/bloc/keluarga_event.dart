part of 'keluarga_bloc.dart';

abstract class KeluargaEvent extends Equatable {
  const KeluargaEvent();
}

class LoadKeluargaEvent extends KeluargaEvent {
  final int id;

  const LoadKeluargaEvent({required this.id});
  @override
  List<Object> get props => [id];
}

class AddKeluargaEvent extends KeluargaEvent {
  final String nama;
  final String jenis;
  final int usia;
  final String riwayat;
  final int id_pasien;

  const AddKeluargaEvent(
      {required this.nama,
      required this.jenis,
      required this.usia,
      required this.riwayat,
      required this.id_pasien});
  @override
  List<Object> get props => [id_pasien, nama, jenis, usia, riwayat];
}

class DeleteKeluargaEvent extends KeluargaEvent {
  final int id;
  final int id_pasien;

  const DeleteKeluargaEvent({required this.id, required this.id_pasien});
  @override
  List<Object> get props => [id];
}

class UpdateKeluargaEvent extends KeluargaEvent {
  final int id;
  final String nama;
  final String jenis;
  final int usia;
  final String riwayat;
  final int id_pasien;

  const UpdateKeluargaEvent(
      {required this.id,
      required this.nama,
      required this.jenis,
      required this.usia,
      required this.riwayat,
      required this.id_pasien});
  @override
  List<Object> get props => [id_pasien, nama, jenis, usia, riwayat];
}
