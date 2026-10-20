import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// File ini dibuat otomatis oleh perintah: dart run build_runner build
part 'app_database.g.dart';

/// Tabel tugas (penyimpanan terstruktur).
@DataClassName('TugasItem')
class Tugas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get judul => text()();
  TextColumn get mataKuliah => text()();
  TextColumn get tenggat => text()();

  /// 'To-Do', 'Terkumpul', atau 'Terlewat'
  TextColumn get status => text()();
}

@DriftDatabase(tables: [Tugas])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'gradia_db'));

  @override
  int get schemaVersion => 1;

  /// Ambil semua tugas sekali.
  Future<List<TugasItem>> semuaTugas() => select(tugas).get();

  /// Pantau tugas: daftar otomatis diperbarui saat data berubah.
  Stream<List<TugasItem>> pantauTugas() => select(tugas).watch();

  /// Ambil tugas berdasarkan status.
  Future<List<TugasItem>> tugasByStatus(String status) =>
      (select(tugas)..where((t) => t.status.equals(status))).get();

  /// Tambah satu tugas.
  Future<int> tambahTugas(TugasCompanion data) => into(tugas).insert(data);

  /// Ubah status tugas (contoh: To-Do menjadi Terkumpul).
  Future<int> ubahStatus(int id, String statusBaru) =>
      (update(tugas)..where((t) => t.id.equals(id)))
          .write(TugasCompanion(status: Value(statusBaru)));

  /// Isi data awal sekali saja (saat tabel masih kosong).
  Future<void> isiDataAwal() async {
    final ada = await select(tugas).get();
    if (ada.isNotEmpty) return;

    await batch((b) {
      b.insertAll(tugas, [
        TugasCompanion.insert(
          judul: 'Usability Test Report',
          mataKuliah: 'Desain User Interface dan User Experience',
          tenggat: 'Terlambat 2 hari',
          status: 'Terlewat',
        ),
        TugasCompanion.insert(
          judul: 'Tugas Aplikasi Mobile',
          mataKuliah: 'Pemrograman Mobile',
          tenggat: 'Besok, 23:59',
          status: 'To-Do',
        ),
        TugasCompanion.insert(
          judul: 'Laporan Praktikum Jaringan',
          mataKuliah: 'Jaringan Komputer',
          tenggat: 'Jumat, 17:00',
          status: 'To-Do',
        ),
        TugasCompanion.insert(
          judul: 'Quiz Framework Laravel',
          mataKuliah: 'Pemrograman Web Framework',
          tenggat: 'Senin, 10:00',
          status: 'To-Do',
        ),
        TugasCompanion.insert(
          judul: 'Prototype Hi-Fi',
          mataKuliah: 'Desain User Interface dan User Experience',
          tenggat: 'Terkumpul Selasa',
          status: 'Terkumpul',
        ),
      ]);
    });
  }
}