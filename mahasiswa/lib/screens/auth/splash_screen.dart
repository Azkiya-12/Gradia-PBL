import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _primary = Color(0xFF4F46E5);

  @override
  void initState() {
    super.initState();
    // Setelah 2 detik, pindah ke halaman Login
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo (topi toga + G)
              Image.asset(
                'assets/images/Topi_Gradia.png',
                width: 100,
                errorBuilder: (context, error, stack) => const Icon(
                  Icons.school,
                  size: 64,
                  color: Color(0xFFFF9A3D),
                ),
              ),

              const SizedBox(height: 12),

              // Nama aplikasi
              const Text(
                'Gradia',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 8),

              // Subjudul
              const Text(
                'Teman terbaik untuk perjalanan akademikmu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 40),

              // Indikator loading
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: _primary,
                  backgroundColor: Color(0xFFE0E7FF),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Memuat...',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}