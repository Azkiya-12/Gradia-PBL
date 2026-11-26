import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../services/api_client.dart';
import '../../services/auth_service.dart';
import '../../widgets/common.dart';

/// Screen 03 - Lupa password
class LupaPasswordScreen extends StatefulWidget {
  const LupaPasswordScreen({super.key});

  @override
  State<LupaPasswordScreen> createState() => _LupaPasswordScreenState();
}

class _LupaPasswordScreenState extends State<LupaPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final identifier = _emailController.text.trim();

    if (identifier.isEmpty) {
      setState(() {
        _errorMessage = 'Email atau NIDN/NIM tidak boleh kosong.';
        _successMessage = null;
      });
      return;
    }

    if (identifier.contains('@')) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(identifier)) {
        setState(() {
          _errorMessage = 'Format email tidak valid.';
          _successMessage = null;
        });
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final res = await AuthService.forgotPassword(identifier);
      if (!mounted) return;

      setState(() {
        _successMessage = res['message']?.toString() ??
            'Tautan reset kata sandi telah dikirim ke email terdaftar.';
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Terjadi kesalahan sistem: $e';
        _isLoading = false;
      });
    }
  }

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
          if (_errorMessage != null) ...[
            FormBanner(title: 'Gagal', message: _errorMessage!),
            const SizedBox(height: 16),
          ],
          if (_successMessage != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.successSoft,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 18, color: AppColors.success),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _successMessage!,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          AppTextField(
            label: 'Email',
            hint: 'nama@kampus.ac.id',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            invalid: _errorMessage != null,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            _isLoading ? 'Mengirim...' : 'Kirim tautan reset',
            onPressed: _isLoading ? null : _submit,
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
