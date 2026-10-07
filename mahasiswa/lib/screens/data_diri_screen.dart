import 'package:flutter/material.dart';
import '../widgets/common.dart';

/// Screen 18 - Data diri
class DataDiriScreen extends StatelessWidget {
  const DataDiriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubScreen(
      title: 'Data diri',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Nama lengkap',
            controller: TextEditingController(text: 'Sinta Putri Anabella'),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'NIM',
            controller: TextEditingController(text: '251234567899'),
            readOnly: true,
            helper: 'NIM dikelola kampus dan tidak bisa diubah',
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Program studi',
            controller: TextEditingController(text: 'Teknologi Informasi'),
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Angkatan',
            controller: TextEditingController(text: '2025'),
            readOnly: true,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            'Simpan perubahan',
            onPressed: () {
              showSnack(context, 'Perubahan disimpan (demo)');
              Navigator.of(context).maybePop();
            },
          ),
        ],
      ),
    );
  }
}