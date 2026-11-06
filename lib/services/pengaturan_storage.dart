import 'package:shared_preferences/shared_preferences.dart';

class PengaturanStorage {
  static const _kNilai = 'notif_nilai';
  static const _kPengumuman = 'notif_pengumuman';
  static const _kReminder = 'notif_reminder';
  static const _kUpdate = 'notif_update_sistem';

  static Future<Map<String, bool>> muat() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'nilai': prefs.getBool(_kNilai) ?? true,
      'pengumuman': prefs.getBool(_kPengumuman) ?? true,
      'reminder': prefs.getBool(_kReminder) ?? true,
      'update': prefs.getBool(_kUpdate) ?? false,
    };
  }

  static Future<void> simpan({
    required bool nilai,
    required bool pengumuman,
    required bool reminder,
    required bool update,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNilai, nilai);
    await prefs.setBool(_kPengumuman, pengumuman);
    await prefs.setBool(_kReminder, reminder);
    await prefs.setBool(_kUpdate, update);
  }
}