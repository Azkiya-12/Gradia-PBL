import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Warna diambil dari desain Figma (halaman Design system)
  static const _primary = Color(0xFF4F46E5);
  static const _border = Color(0xFFE2E8F0);
  static const _dark = Color(0xFF0F172A);
  static const _grey = Color(0xFF64748B);
  static const _hint = Color(0xFF94A3B8);
  static const _surface = Color(0xFFF8FAFC);
  static const _danger = Color(0xFFDC2626);
  static const _dangerSoft = Color(0xFFFEF2F2);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  late final TapGestureRecognizer _loginTap;
  String? _selectedProdi;

  final List<String> _prodiList = const [
    'Teknologi Informasi',
    'Teknologi Rekayasa Perangkat Lunak',
    'Sistem Informasi',
    'Teknik Elektro',
    'Kearsipan',
    'Ilmu Perpustakaan',
    'Manajemen',
    'Akuntansi',
  ];

  @override
  void initState() {
    super.initState();
    _loginTap = TapGestureRecognizer()..onTap = () => Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    _loginTap.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Akun berhasil dibuat, silakan login')),
    );
    Navigator.pop(context); // kembali ke halaman Login
  }

  /// [helper] tampil di bawah input, otomatis diganti pesan error kalau ada error.
  InputDecoration _decoration(String hint, {String? helper}) {
    OutlineInputBorder outline(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _hint, fontSize: 14),
      helperText: helper,
      helperStyle: const TextStyle(fontSize: 12, color: _grey),
      errorStyle: const TextStyle(fontSize: 12, height: 1.4, color: _danger),
      errorMaxLines: 3,
      filled: true,
      // Latar jadi merah muda saat field error (sesuai desain)
      fillColor: WidgetStateColor.resolveWith(
        (states) =>
            states.contains(WidgetState.error) ? _dangerSoft : _surface,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: outline(_border),
      enabledBorder: outline(_border),
      focusedBorder: outline(_primary),
      errorBorder: outline(_danger),
      focusedErrorBorder: outline(_danger),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _dark,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: tombol kembali + judul
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.arrow_back_ios_new,
                            size: 18, color: _dark),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Buat akun',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Daftar sebagai mahasiswa',
                  style: TextStyle(fontSize: 12, color: _grey),
                ),

                const SizedBox(height: 24),

                // Nama lengkap
                _label('Nama lengkap'),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Masukkan nama lengkap'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Nama lengkap wajib diisi'
                      : null,
                ),

                const SizedBox(height: 16),

                // NIM (harus 12 digit angka)
                _label('NIM'),
                TextFormField(
                  controller: _nimController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ],
                  decoration: _decoration('Masukkan NIM'),
                  validator: (v) {
                    if (v == null || !RegExp(r'^\d{12}$').hasMatch(v.trim())) {
                      return 'NIM terdiri dari 12 digit angka. Contoh: 251234567899';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Email kampus (harus @kampus.ac.id)
                _label('Email kampus'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('nama@kampus.ac.id'),
                  validator: (v) {
                    final email = (v ?? '').trim().toLowerCase();
                    if (email.isEmpty) return 'Email kampus wajib diisi';
                    if (!email.endsWith('@kampus.ac.id') ||
                        email.length <= '@kampus.ac.id'.length) {
                      return 'Gunakan email kampus yang berakhiran @kampus.ac.id';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password
                _label('Password'),
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration(
                    'Minimal 8 karakter',
                    helper: 'Minimal 8 karakter, kombinasi huruf dan angka',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password wajib diisi';
                    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(v);
                    final hasDigit = RegExp(r'[0-9]').hasMatch(v);
                    if (v.length < 8 || !hasLetter || !hasDigit) {
                      return 'Password minimal 8 karakter. Kombinasikan huruf dan angka.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Konfirmasi password
                _label('Konfirmasi password'),
                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: _decoration('Ketik ulang password'),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Konfirmasi password wajib diisi';
                    }
                    if (v != _passController.text) {
                      return 'Konfirmasi belum sama dengan password. Ketik ulang ya.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Program studi
                _label('Program studi'),
                DropdownButtonFormField<String>(
                  initialValue: _selectedProdi,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: _grey),
                  borderRadius: BorderRadius.circular(12),
                  decoration: _decoration('Pilih program studi'),
                  hint: const Text(
                    'Pilih program studi',
                    style: TextStyle(fontSize: 14, color: _dark),
                  ),
                  items: _prodiList
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedProdi = v),
                  validator: (v) =>
                      v == null ? 'Program studi wajib dipilih' : null,
                ),

                const SizedBox(height: 28),

                // Tombol Daftar
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Sudah punya akun? Login
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun? ',
                      style: const TextStyle(fontSize: 13, color: _grey),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(
                            color: _primary,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: _loginTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}