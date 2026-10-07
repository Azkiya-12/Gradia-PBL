import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/common.dart';
import 'data_diri_screen.dart';
import 'login_screen.dart';
import 'pengaturan_notifikasi_screen.dart';
import 'ubah_email_password_screen.dart';

/// Screen 16 - Tab "Akun" di bottom nav
class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Akun',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.ink)),
          SizedBox(height: 24),
          _ProfilBody(),
        ],
      ),
    );
  }
}

/// Screen 17 - Profil (versi dengan tombol back, dibuka dari avatar di Dashboard)
class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) => const SubScreen(
        title: 'Profil',
        padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: _ProfilBody(),
      );
}

/// Isi bersama untuk Akun dan Profil (avatar, nama, menu, tombol keluar).
class _ProfilBody extends StatelessWidget {
  const _ProfilBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 85,
          height: 85,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6366F1), Color(0xFFA78BFA)],
            ),
          ),
          child: const Text('SP',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 16),
        const Text('Sinta Putri Anabella',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.ink)),
        const SizedBox(height: 4),
        const Text('251234567899 · Teknologi Informasi',
            style: TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: 28),
        AppCard(
          child: Column(
            children: divide([
              _MenuRow('Data diri',
                  () => push(context, const DataDiriScreen())),
              _MenuRow('Ubah email / password',
                  () => push(context, const UbahEmailPasswordScreen())),
              _MenuRow('Pengaturan notifikasi',
                  () => push(context, const PengaturanNotifikasiScreen())),
            ]),
          ),
        ),
        const SizedBox(height: 24),
        DestructiveButton(
          'Keluar',
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _MenuRow(this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.ink, size: 22),
          ],
        ),
      ),
    );
  }
}