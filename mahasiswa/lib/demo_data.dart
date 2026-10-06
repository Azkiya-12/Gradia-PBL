import 'package:flutter/foundation.dart';

/// Akun demo untuk presentasi. Login berhasil hanya dengan data ini.
class DemoAccount {
  static String email = 'sinta@kampus.ac.id';
  static const nim = '251234567899';
  static String password = 'password123';
}

/// Status demo bersama antar screen.
/// kosong = true -> semester yang dipilih belum punya nilai, jadi screen
/// Nilai, Evaluasi AI, dan Notifikasi menampilkan tampilan kosong.
class DemoState {
  static final ValueNotifier<bool> kosong = ValueNotifier<bool>(false);
}

/// Email kampus harus berakhiran @kampus.ac.id dan ada nama sebelum @.
bool isKampusEmail(String v) {
  final e = v.trim().toLowerCase();
  return e.endsWith('@kampus.ac.id') && e.length > '@kampus.ac.id'.length;
}

/// Password minimal 8 karakter, ada huruf dan angka.
bool isValidPassword(String v) =>
    v.length >= 8 && RegExp(r'[A-Za-z]').hasMatch(v) && RegExp(r'\d').hasMatch(v);
