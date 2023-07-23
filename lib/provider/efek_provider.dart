import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tbc_app/data/Models/alarm/efek_hive_storage.dart';
import 'package:tbc_app/data/Models/alarm/pengambilan_hive_storage.dart';
import 'package:tbc_app/data/Models/alarm/pengambilan_model/pengambilan_data_model.dart';
import 'package:tbc_app/data/Models/alarm/periksa_hive_storage.dart';
import 'package:tbc_app/data/Models/alarm/periksa_model/periksa_data_model.dart';
import 'package:tbc_app/data/Models/efek/efek.dart';
import 'package:tbc_app/data/Models/efek/efek_data_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/helper/alarm_helper.dart';
import 'package:tbc_app/service/StorageService.dart';
import 'package:timezone/timezone.dart';

class EfekModel extends ChangeNotifier {
  final EfekHiveLocalStorage _storage;

  EfekState? state;
  List<EfekDataModel>? efeks;
  List<EfekDataModel> _efeksList = [];
  List<dynamic> get alarmList => _efeksList;
  bool loading = true;
  final DioClient _dioClient = DioClient();

  EfekModel(EfekHiveLocalStorage storage) : _storage = storage {
    _storage.init().then((_) => loadEfek());
  }

  @override
  void dispose() {
    _storage.dispose();
    super.dispose();
  }

  void loadEfek() async {
    final StorageService _storageService = StorageService();
    String? id = await _storageService.readSecureData('id');
    final efeks = await _storage.loadEfek();
    this.efeks = List.from(
        efeks.where((element) => element.id_pasien == int.tryParse(id!)));

    if (efeks.isNotEmpty) {
      state = EfekLoaded(efeks);
    } else {
      final StorageService _storageService = StorageService();
      String? id = await _storageService.readSecureData('id');
      List result = await _dioClient.getEfek(id: int.parse(id!));

      result.map((e) async {
        for (var a = 0; a < result.length; a++) {
          EfekDataModel efek1 = EfekDataModel(
              id: int.tryParse(e['id'].toString()),
              id_pasien: int.parse(e['id_pasien'].toString()),
              judul: e['judul'],
              p_awal: DateTime.parse(e['awal'].toString()),
              p_akhir: DateTime.parse(e['akhir'].toString()),
              dosis: e['dosis'],
              efek: e['efeksamping'],
              lupa: DateTime.parse(e['lupa'].toString()));
          _efeksList.add(efek1);
          await _storage.addEfek(efek1);
        }
      }).toList();
      final efeks = await _storage.loadEfek();
      this.efeks = List.from(efeks);

      state = EfekLoaded(efeks);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> addEfek(EfekDataModel efek) async {
    loading = true;
    notifyListeners();
    final newEfek1 = await _dioClient.createEfek(
        id_pasien: efek.id_pasien,
        judul: efek.judul,
        p_awal: efek.p_awal.toIso8601String(),
        p_akhir: efek.p_akhir!.toIso8601String(),
        dosis: efek.dosis,
        efek: efek.efek,
        lupa: efek.lupa!.toIso8601String());

    final newEfek = await _storage.addEfek(EfekDataModel(
        id: newEfek1!.id,
        judul: efek.judul,
        p_awal: efek.p_awal,
        p_akhir: efek.p_akhir,
        dosis: efek.dosis,
        efek: efek.efek,
        id_pasien: efek.id_pasien,
        lupa: efek.lupa));
    efeks!.add(newEfek);
    efeks!.sort(effeksort);

    efeks = List.from(efeks!);

    loading = false;
    state = EfekCreate(
      efek,
      efeks!.indexOf(newEfek),
    );
    notifyListeners();
  }

  Future<void> updateEfek(EfekDataModel efek, int index) async {
    loading = true;
    notifyListeners();
    final efekss = await _dioClient.updateEfek(
        efek: Efek(
            id: efek.id,
            p_awal: efek.p_awal,
            p_akhir: efek.p_akhir,
            dosis: efek.dosis,
            efek: efek.efek,
            id_pasien: efek.id_pasien),
        id: efek.id);

    if (efekss.toString().contains('berhasil')) {
      final newEfek = await _storage.updateEfek(efek);

      efeks![index] = newEfek;
      efeks!.sort(effeksort);
      efeks = List.from(efeks!);

      loading = false;
      state = EfekUpdate(
        newEfek,
        efek,
        index,
        efeks!.indexOf(newEfek),
      );
      notifyListeners();
    }
  }

  Future<void> deleteEfek(EfekDataModel efek, int index) async {
    loading = true;
    notifyListeners();
    final delete = await _dioClient.deleteEfek(id: efek.id);

    if (delete.toString().contains('berhasil')) {
      await _storage.removeEfek(efek);
      efeks!.removeAt(index);

      loading = false;
      state = EfekDeleted(
        efek,
        index,
      );
      notifyListeners();
    }
  }

  int effeksort(efek1, efek2) => efek1.p_akhir.compareTo(efek2.p_akhir);
}

abstract class EfekState {
  const EfekState();
}

class EfekLoaded extends EfekState {
  final List<EfekDataModel> efeks;

  const EfekLoaded(this.efeks);
}

// state for create, update, delete,
class EfekCreate extends EfekState {
  final EfekDataModel efek;
  final int index;

  const EfekCreate(this.efek, this.index);
}

class EfekDeleted extends EfekState {
  final EfekDataModel efek;
  final int index;

  const EfekDeleted(this.efek, this.index);
}

class EfekUpdate extends EfekState {
  final EfekDataModel efek;
  final EfekDataModel oldefek;
  final int index;
  final int newIndex;

  const EfekUpdate(this.efek, this.oldefek, this.index, this.newIndex);
}
