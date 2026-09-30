import 'package:flutter/material.dart';

import 'Screens/login_screen.dart';
import 'Screens/dashboard_screen.dart';
import 'Screens/profile.screen.dart';

void main() {
  runApp(const GradiaApp());
}

class GradiaApp extends StatelessWidget {
  const GradiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Gradia - Sistem Informasi Akademik',

      // Halaman pertama yang muncul
      initialRoute: '/login',

      routes: {
        // Login
        '/login': (context) => const LoginScreen(),

        // Dashboard Dosen
        '/dashboard': (context) => const DashboardScreen(),

        // Profile Dosen
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}