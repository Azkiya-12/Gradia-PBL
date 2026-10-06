import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/common.dart';

/// Screen 03 - Lupa password
class LupaPasswordScreen extends StatelessWidget {
  const LupaPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubScreen(
      title: 'Lupa password',
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reset password',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.ink)),
          const SizedBox(height: 8),
          const Text(
              'Masukkan email atau NIM. Kami kirim tautan untuk membuat password baru.',
              style: TextStyle(
                  fontSize: 13, height: 1.45, color: AppColors.muted)),
          const SizedBox(height: 24),
          const AppTextField(
            label: 'Email',
            hint: 'nama@kampus.ac.id',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            'Kirim tautan reset',
            onPressed: () =>
                showSnack(context, 'Tautan reset dikirim ke emailmu (demo)'),
          ),
          const SizedBox(height: 18),
          Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: const Text('Kembali ke login',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted)),
            ),
          ),
        ],
      ),
    );
  }
}
