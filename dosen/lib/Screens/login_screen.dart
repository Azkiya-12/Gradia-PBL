import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
  bool rememberMe = false;

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1050,
              ),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              // ISI DESAIN LOGIN DI SINI
              child: Row(
                children: [
                  Expanded(
                    child: _loginForm(),
                  ),

                  const SizedBox(width: 25),

                  Expanded(
                    child: _informationPanel(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // BAGIAN LOGIN
  // =========================

  Widget _loginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LOGO
        Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E9FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.school,
                color: Color(0xFF5146E5),
              ),
            ),

            const SizedBox(width: 10),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gradia',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Sistem Informasi Akademik',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 30),

        const Text(
          'Selamat Datang!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Masuk ke akun Anda untuk mengakses sistem informasi '
          'akademik terintegrasi.',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 20),

        // LOGIN / DAFTAR
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF172033),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Center(
                  child: Text(
                    '♙  Masuk / Login Dosen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                color: const Color(0xFFF0F3F7),
                child: const Center(
                  child: Text(
                    '♧  Daftar Akun Baru',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // EMAIL
        const Text(
          'NIDN / Email Kampus',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 7),

        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'hendra@kampus.ac.id',
            prefixIcon: const Icon(
              Icons.mail_outline,
              size: 15,
            ),
            filled: true,
            fillColor: const Color(0xFFF7F9FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 15),

        // PASSWORD
        const Text(
          'Password / Kata Sandi',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 7),

        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            hintText: 'secretpassword123',
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 15,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 15,
              ),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
            filled: true,
            fillColor: const Color(0xFFF7F9FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (value) {
                setState(() {
                  rememberMe = value ?? false;
                });
              },
            ),

            const Text(
              'Ingat saya di perangkat ini',
              style: TextStyle(fontSize: 9),
            ),

            const Spacer(),

            const Text(
              'Lupa password?',
              style: TextStyle(
                color: Color(0xFF5146E5),
                fontSize: 9,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // LOGIN BUTTON
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/dashboard',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5146E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '↪  Masuk ke Portal Dosen →',
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // SSO
        SizedBox(
          width: double.infinity,
          height: 38,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF7F9FB),
              foregroundColor: Colors.black54,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '🏛  Masuk dengan Kampus SSO ID',
              style: TextStyle(fontSize: 9),
            ),
          ),
        ),

        const SizedBox(height: 25),

        const Row(
          children: [
            Text(
              'Bantuan Teknis',
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 12),
            Text(
              '•',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Protokol Privasi',
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // BAGIAN KANAN
  // =========================

  Widget _informationPanel() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🛡 Mendukung Transformasi Digital Pendidikan',
                style: TextStyle(
                  fontSize: 7,
                  color: Color(0xFF149B68),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Container(
            height: 125,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFE8E7FF),
                  Color(0xFFF0F4FF),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.computer,
                size: 65,
                color: Color(0xFF8993AC),
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Sistem Informasi Akademik Terintegrasi &',
            style: TextStyle(
              color: Color(0xFF4B3FE4),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            'AI Feedback Engine',
            style: TextStyle(
              color: Color(0xFF4B3FE4),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'sistem yang dirancang untuk mengelola berbagai '
            'aktivitas akademik, seperti data mahasiswa, kelas, nilai, '
            'dan laporan pembelajaran dalam satu platform yang '
            'terhubung.',
            style: TextStyle(
              fontSize: 9,
              height: 1.5,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 15),

          const Row(
            children: [
              _Feature(
                icon: Icons.hub,
                title: 'Terintegrasi',
              ),
              SizedBox(width: 6),
              _Feature(
                icon: Icons.psychology,
                title: 'AI Feedback',
              ),
              SizedBox(width: 6),
              _Feature(
                icon: Icons.bolt,
                title: 'Lebih Efisien',
              ),
              SizedBox(width: 6),
              _Feature(
                icon: Icons.shield,
                title: 'Aman',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String title;

  const _Feature({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 15,
              color: Color(0xFF5146E5),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}