import 'dart:async';
import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/common.dart';
import 'login_screen.dart';

/// Screen 04 - Loading / splash. Otomatis lanjut ke Login setelah 2 detik.
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            GradiaLogo(),
            SizedBox(height: 16),
            Text('Gradia',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.ink)),
            SizedBox(height: 6),
            Text('Teman terbaik untuk perjalanan akademikmu',
                style: TextStyle(fontSize: 12, color: AppColors.muted)),
            SizedBox(height: 56),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.primary,
                backgroundColor: AppColors.primarySoft,
              ),
            ),
            SizedBox(height: 10),
            Text('Memuat…',
                style: TextStyle(fontSize: 12, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}
