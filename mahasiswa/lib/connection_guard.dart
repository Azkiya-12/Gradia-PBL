import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// Membungkus seluruh aplikasi. Saat perangkat tidak punya koneksi
/// (Wi-Fi/data mati), muncul banner merah di bagian atas layar.
class ConnectionGuard extends StatefulWidget {
  final Widget child;

  const ConnectionGuard({super.key, required this.child});

  @override
  State<ConnectionGuard> createState() => _ConnectionGuardState();
}

class _ConnectionGuardState extends State<ConnectionGuard> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _offline = false;

  @override
  void initState() {
    super.initState();
    // Cek kondisi saat aplikasi dibuka
    Connectivity().checkConnectivity().then(_update);
    // Pantau perubahan selama aplikasi berjalan
    _subscription = Connectivity().onConnectivityChanged.listen(_update);
  }

  void _update(List<ConnectivityResult> results) {
    final offline = results.every((r) => r == ConnectivityResult.none);
    if (mounted && offline != _offline) {
      setState(() => _offline = offline);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_offline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: const Color(0xFFDC2626),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.wifi_off_rounded,
                          size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Tidak ada koneksi internet',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}