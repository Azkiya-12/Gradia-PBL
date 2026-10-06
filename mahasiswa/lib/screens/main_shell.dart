import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'nilai_akademik_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _primary = Color(0xFF4F46E5);
  static const _grey = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  int _index = 0;

  void _goTo(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga kondisi tiap tab (misalnya semester yang dipilih)
      body: IndexedStack(
        index: _index,
        children: [
          DashboardScreen(onTabChange: _goTo),
          NilaiScreen(onKembaliKeDashboard: () => _goTo(0)),
          const _SegeraHadir(title: 'Evaluasi AI'),
          const _SegeraHadir(title: 'Akun'),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: _border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: _goTo,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: _primary,
          unselectedItemColor: _grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sticky_note_2_outlined),
              label: 'Nilai',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_outlined),
              label: 'Evaluasi AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}

/// Halaman sementara untuk tab yang belum dibuat.
/// Nanti diganti dengan halaman aslinya.
class _SegeraHadir extends StatelessWidget {
  final String title;

  const _SegeraHadir({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Text(
            '$title\nsegera hadir',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}