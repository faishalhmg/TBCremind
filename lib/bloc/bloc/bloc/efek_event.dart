part of 'efek_bloc.dart';

abstract class EfekEvent extends Equatable {
  const EfekEvent();
}

class LoadEfekEvent extends EfekEvent {
  final int id;

  const LoadEfekEvent({required this.id});
  @override
  List<Object> get props => [id];
}

class AddEfekEvent extends EfekEvent {
  final String judul;
  final DateTime p_awal;
  final DateTime p_akhir;
  final String dosis;
  final DateTime lupa;
  final String efek;
  final int id_pasien;

  AddEfekEvent({
    required this.judul,
    required this.p_awal,
    required this.p_akhir,
    required this.dosis,
    required this.lupa,
    required this.efek,
    required this.id_pasien,
  });
  @override
  List<Object> get props => [
        judul,
        p_awal,
        p_akhir,
        dosis,
        lupa,
        efek,
        id_pasien,
      ];
}

class DeleteEfekEvent extends EfekEvent {
  final int id;
  final int id_pasien;

  const DeleteEfekEvent({required this.id, required this.id_pasien});
  @override
  List<Object> get props => [id];
}

class UpdateEfekEvent extends EfekEvent {
  final int id;
  final String judul;
  final DateTime p_awal;
  final DateTime p_akhir;
  final String dosis;
  final DateTime lupa;
  final String efek;
  final int id_pasien;

  const UpdateEfekEvent({
    required this.id,
    required this.judul,
    required this.p_awal,
    required this.p_akhir,
    required this.dosis,
    required this.lupa,
    required this.efek,
    required this.id_pasien,
  });
  @override
  List<Object> get props => [
        id,
        judul,
        p_awal,
        p_akhir,
        dosis,
        lupa,
        efek,
        id_pasien,
      ];
}
