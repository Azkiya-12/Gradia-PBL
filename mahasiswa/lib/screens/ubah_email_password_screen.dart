import 'package:flutter/material.dart';
import '../demo_data.dart';
import '../widgets/common.dart';

/// Screen 20 - Ubah email / password (dengan validasi dan tampilan error)
class UbahEmailPasswordScreen extends StatefulWidget {
  const UbahEmailPasswordScreen({super.key});

  @override
  State<UbahEmailPasswordScreen> createState() =>
      _UbahEmailPasswordScreenState();
}

class _UbahEmailPasswordScreenState extends State<UbahEmailPasswordScreen> {
  final _email = TextEditingController();
  final _lama = TextEditingController();
  final _baru = TextEditingController();
  final _konfirmasi = TextEditingController();
  Map<String, String> _err = {};

  @override
  void dispose() {
    for (final c in [_email, _lama, _baru, _konfirmasi]) {
      c.dispose();
    }
    super.dispose();
  }

  void _simpan() {
    final e = <String, String>{};
    if (_email.text.trim().isNotEmpty && !isKampusEmail(_email.text)) {
      e['email'] = 'Gunakan email kampus yang berakhiran @kampus.ac.id';
    }
    if (_lama.text != DemoAccount.password) {
      e['lama'] =
          'Password lama belum sesuai. Ketik ulang, atau atur ulang lewat Lupa password.';
    }
    if (!isValidPassword(_baru.text)) {
      e['baru'] = 'Password minimal 8 karakter, kombinasi huruf dan angka.';
    }
    if (_konfirmasi.text.isEmpty || _konfirmasi.text != _baru.text) {
      e['konfirmasi'] = 'Konfirmasi belum sama dengan password baru.';
    }
    setState(() => _err = e);
    if (e.isEmpty) {
      DemoAccount.password = _baru.text;
      if (_email.text.trim().isNotEmpty) {
        DemoAccount.email = _email.text.trim().toLowerCase();
      }
      showSnack(context, 'Perubahan disimpan (demo)');
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SubScreen(
      title: 'Ubah email / password',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Email baru',
            hint: 'nama@kampus.ac.id',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            error: _err['email'],
          ),
          const SizedBox(height: 16),
          AppTextField(
              label: 'Password lama',
              hint: 'Masukkan password lama',
              controller: _lama,
              obscure: true,
              error: _err['lama']),
          const SizedBox(height: 16),
          AppTextField(
              label: 'Password baru',
              hint: 'Minimal 8 karakter',
              controller: _baru,
              obscure: true,
              error: _err['baru']),
          const SizedBox(height: 16),
          AppTextField(
              label: 'Konfirmasi password baru',
              hint: 'Ketik ulang password baru',
              controller: _konfirmasi,
              obscure: true,
              error: _err['konfirmasi']),
          const SizedBox(height: 24),
          PrimaryButton('Simpan perubahan', onPressed: _simpan),
        ],
      ),
    );
  }
}