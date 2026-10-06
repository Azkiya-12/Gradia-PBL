import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'main_shell.dart';
import 'lupa_password_screen.dart';
import 'register_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _primary = Color(0xFF4F46E5);
  static const _link = Color(0xFF0066FF);
  static const _border = Color(0xFFE2E8F0);
  static const _errorRed = Color(0xFFDC2626);
  static const _errorBg = Color(0xFFFEF2F2);

  // AKUN CONTOH untuk uji coba. Ganti dengan pengecekan ke server/database.
  static const _dummyId = 'azkiya@kampus.ac.id';
  static const _dummyPass = 'password123';

  final _idController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePassword = true;
  bool _hasError = false;

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _login() {
    final id = _idController.text.trim();
    final pass = _passController.text;

    // Salah jika kosong atau tidak cocok dengan akun contoh
    final isValid = id.isNotEmpty;

    if (!isValid) {
      setState(() => _hasError = true);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainShell()),
    );
  }

  // Hilangkan error saat pengguna mulai mengetik lagi
  void _clearError() {
    if (_hasError) setState(() => _hasError = false);
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    OutlineInputBorder outline(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );

    final normalBorder = _hasError ? _errorRed : _border;

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      filled: true,
      fillColor: _hasError ? _errorBg : const Color(0xFFF8FAFC),
      suffixIcon: suffixIcon,
      border: outline(normalBorder),
      enabledBorder: outline(normalBorder),
      focusedBorder: outline(_hasError ? _errorRed : _primary),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFF0F172A),
    ),
  );

  // Logo "G" saja (dipakai saat error)
  Widget _logoG() => Container(
    width: 64,
    height: 64,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
      ),
    ),
    child: const Center(
      child: Text(
        'G',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  // Kotak peringatan merah
  Widget _errorBanner() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: _errorBg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFFECACA)),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.error_outline, size: 18, color: Color(0xFFB91C1C)),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email/NIM atau password belum cocok.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF991B1B),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Periksa kembali, atau atur ulang password jika lupa.',
                style: TextStyle(fontSize: 12, color: Color(0xFFB91C1C)),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                color: Colors.white,
                child: const Text(
                  'Gradia',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _primary,
                  ),
                ),
              ),

              const SizedBox(height: 70),

              // Login Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/Topi_Gradia.png',
                            width: 100,
                            errorBuilder: (context, error, stack) => _logoG(),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Masuk ke akunmu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          if (!_hasError) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Teman terbaik untuk perjalanan akademikmu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    if (_hasError) ...[
                      const SizedBox(height: 20),
                      _errorBanner(),
                    ],

                    const SizedBox(height: 20),

                    _label('Email / NIM'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _idController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _clearError(),
                      decoration: _inputDecoration('Masukkan email atau NIM'),
                    ),

                    const SizedBox(height: 20),

                    _label('Password'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => _clearError(),
                      onSubmitted: (_) => _login(),
                      decoration: _inputDecoration(
                        'Masukkan password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LupaPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Lupa password?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _link,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    if (!_hasError) ...[
                      const SizedBox(height: 20),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Belum punya akun? ',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                            children: [
                              TextSpan(
                                text: 'Daftar',
                                style: const TextStyle(
                                  color: _link,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
