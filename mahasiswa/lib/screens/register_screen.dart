import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _primary = Color(0xFF4F46E5);
  static const _link = Color(0xFF0066FF);
  static const _border = Color(0xFFE2E8F0);
  static const _dark = Color(0xFF0F172A);
  static const _grey = Color(0xFF64748B);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _selectedProdi;
  bool _obscurePass = true;
bool _obscureConfirm = true;

  final List<String> _prodiList = const [
    'Teknologi Informasi',
    'teknologi Rekayasa Perangkat Lunak',
    'Sistem Informasi',
    'Teknik Elektro',
    'Kearsipan',
    'Ilmu Perpustakaan',
    'Manajemen',
    'Akuntansi',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Akun berhasil dibuat, silakan login')),
    );
    Navigator.pop(context); // kembali ke halaman Login
  }

  InputDecoration _decoration(String hint, {Widget? suffixIcon}) {
    OutlineInputBorder outline(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: outline(_border),
      enabledBorder: outline(_border),
      focusedBorder: outline(_primary),
      errorBorder: outline(Colors.red),
      focusedErrorBorder: outline(Colors.red),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
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
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _dark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
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

                // NIM
                _label('NIM'),
                TextFormField(
                  controller: _nimController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Masukkan NIM'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'NIM wajib diisi'
                      : null,
                ),

                const SizedBox(height: 16),

                // Email kampus
                _label('Email kampus'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('nama@kampus.ac.id'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email kampus wajib diisi';
                    }
                    if (!v.contains('@') || !v.contains('.')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password
                _label('Password'),
                TextFormField(
                  controller: _passController,
                  obscureText: _obscurePass,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Minimal 8 karakter', suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    icon: Icon(
                      _obscurePass
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF64748B),
                    ),
                  )),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password wajib diisi';
                    if (v.length < 8) return 'Minimal 8 karakter';
                    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(v);
                    final hasDigit = RegExp(r'[0-9]').hasMatch(v);
                    if (!hasLetter || !hasDigit) {
                      return 'Harus kombinasi huruf dan angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 6),
                const Text(
                  'Minimal 8 karakter, kombinasi huruf dan angka',
                  style: TextStyle(fontSize: 12, color: _grey),
                ),

                const SizedBox(height: 16),

                // Konfirmasi password
                _label('Konfirmasi password'),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  decoration: _decoration(
                    'Ketik ulang password',
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: _grey,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Konfirmasi password wajib diisi';
                    }
                    if (v != _passController.text) {
                      return 'Password tidak sama';
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

                const SizedBox(height: 24),

                // Tombol Daftar
                SizedBox(
                  width: double.infinity,
                  height: 50,
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

                const SizedBox(height: 16),

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
                            color: _link,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pop(context),
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