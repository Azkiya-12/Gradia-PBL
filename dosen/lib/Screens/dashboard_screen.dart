import 'package:flutter/material.dart'; 
import 'profile.screen.dart'; 
 
class DashboardScreen extends StatelessWidget { 
  const DashboardScreen({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: const Color(0xFFF5F6F8), 
      body: LayoutBuilder( 
        builder: (context, constraints) { 
          final isMobile = constraints.maxWidth < 900; 
 
          return Row( 
            children: [ 
              if (!isMobile) const DashboardSidebar(), 
 
              Expanded( 
                child: Column( 
                  children: [ 
                    if (isMobile) const MobileHeader(), 
 
                    const DashboardTopBar(), 
 
                    const Expanded( 
                      child: DashboardContent(), 
                    ), 
                  ], 
                ), 
              ), 
            ], 
          ); 
        }, 
      ), 
    ); 
  } 
} 
 
// ============================================================ 
// MOBILE HEADER 
// ============================================================ 
 
class MobileHeader extends StatelessWidget { 
  const MobileHeader({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      height: 64, 
      padding: const EdgeInsets.symmetric(horizontal: 20), 
      color: Colors.white, 
      child: Row( 
        children: [ 
          IconButton( 
            onPressed: () { 
              ScaffoldMessenger.of(context).showSnackBar( 
                const SnackBar( 
                  content: Text('Menu sidebar'), 
                ), 
              ); 
            }, 
            icon: const Icon(Icons.menu), 
          ), 
          const SizedBox(width: 8), 
          const Text( 
            'Gradia', 
            style: TextStyle( 
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: Color(0xFF4F36D9), 
            ), 
          ), 
          const Spacer(), 
          const CircleAvatar( 
            radius: 18, 
            backgroundColor: Color(0xFF4F36D9), 
            child: Text( 
              'H', 
              style: TextStyle( 
                color: Colors.white, 
                fontWeight: FontWeight.bold, 
              ), 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
} 
 
// ============================================================ 
// SIDEBAR 
// ============================================================ 
 
class DashboardSidebar extends StatelessWidget { 
  const DashboardSidebar({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      width: 250, 
      height: double.infinity, 
      decoration: const BoxDecoration( 
        color: Colors.white, 
        border: Border( 
          right: BorderSide( 
            color: Color(0xFFE5E7EB), 
          ), 
        ), 
      ), 
      child: Column( 
        children: [ 
          // LOGO 
          Padding( 
            padding: const EdgeInsets.all(20), 
            child: Row( 
              children: [ 
                Container( 
                  width: 42, 
                  height: 42, 
                  decoration: BoxDecoration( 
                    color: const Color(0xFFEDE9FF), 
                    borderRadius: BorderRadius.circular(10), 
                  ), 
                  child: const Icon( 
                    Icons.school, 
                    color: Color(0xFF5136D9), 
                    size: 24, 
                  ), 
                ), 
                const SizedBox(width: 12), 
                const Column( 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [ 
                    Text( 
                      'GRADIA', 
                      style: TextStyle( 
                        fontSize: 17, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFF22252B), 
                      ), 
                    ), 
                    SizedBox(height: 2), 
                    Text( 
                      'Portal Dosen', 
                      style: TextStyle( 
                        fontSize: 12, 
                        color: Color(0xFF777D87), 
                      ), 
                    ), 
                  ], 
                ), 
              ], 
            ), 
          ), 
 
          const Divider( 
            height: 1, 
            color: Color(0xFFEDEDED), 
          ), 
 
          Expanded( 
            child: SingleChildScrollView( 
              padding: const EdgeInsets.all(16), 
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [ 
                  _sectionTitle('UTAMA'), 
 
                  _menuItem( 
                    Icons.dashboard_outlined, 
                    'Dashboard', 
                    selected: true, 
                  ), 
 
                  _menuItem( 
                    Icons.library_books_outlined, 
                    'Manajemen Data Kelas', 
                  ), 
 
                  _menuItem( 
                    Icons.groups_outlined, 
                    'Tambah Kelas & Mahasiswa', 
                  ), 
 
                  const SizedBox(height: 20), 
 
                  _sectionTitle('PENILAIAN & EVALUASI'), 
 
                  _menuItem( 
                    Icons.receipt_long_outlined, 
                    'Input Rekap Nilai', 
                  ), 
 
                  _menuItem( 
                    Icons.insert_drive_file_outlined, 
                    'Import Nilai Excel', 
                  ), 
 
                  const SizedBox(height: 20), 
 
                  _sectionTitle('KECERDASAN BUATAN & LAPORAN'), 
 
                  _menuItem( 
                    Icons.analytics_outlined, 
                    'Analitik & AI Feedback', 
                  ), 
 
                  _menuItem( 
                    Icons.auto_awesome_outlined, 
                    'Generate AI Feedback', 
                  ), 
 
                  _menuItem( 
                    Icons.picture_as_pdf_outlined, 
                    'Cetak PDF & Laporan', 
                  ), 
 
                  const SizedBox(height: 20), 
 
                  _sectionTitle('PENGATURAN AKUN'), 
 
                 _menuItem(
                  Icons.person_outline,
                  'Kelola Profil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
 
                  _menuItem( 
                    Icons.security_outlined, 
                    'Keamanan & Akun', 
                  ), 
 
                  const SizedBox(height: 25), 
 
                  Container( 
                    padding: const EdgeInsets.all(12), 
                    decoration: BoxDecoration( 
                      color: const Color(0xFFF3F0FF), 
                      borderRadius: BorderRadius.circular(10), 
                    ), 
                    child: const Row( 
                      children: [ 
                        Icon( 
                          Icons.menu_book_outlined, 
                          color: Color(0xFF5B42D4), 
                        ), 
                        SizedBox(width: 10), 
                        Expanded( 
                          child: Text( 
                            'Panduan Dosen', 
                            style: TextStyle( 
                              fontSize: 13, 
                              color: Color(0xFF4F3DBD), 
                              fontWeight: FontWeight.w600, 
                            ), 
                          ), 
                        ), 
                        Icon( 
                          Icons.arrow_forward_ios, 
                          size: 12, 
                          color: Color(0xFF6A59D5), 
                        ), 
                      ], 
                    ), 
                  ), 
                ], 
              ), 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _sectionTitle(String title) { 
    return Padding( 
      padding: const EdgeInsets.only( 
        left: 8, 
        bottom: 8, 
      ), 
      child: Text( 
        title, 
        style: const TextStyle( 
          fontSize: 11, 
          fontWeight: FontWeight.bold, 
          color: Color(0xFF8A9099), 
          letterSpacing: .5, 
        ), 
      ), 
    ); 
  } 
 
Widget _menuItem(
  IconData icon,
  String title, {
  bool selected = false,
  VoidCallback? onTap,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(
      vertical: 2,
    ),
    decoration: BoxDecoration(
      color: selected
          ? const Color(0xFFF0EDFF)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      dense: true,

      leading: Icon(
        icon,
        size: 20,
        color: selected
            ? const Color(0xFF5136D9)
            : const Color(0xFF626873),
      ),

      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: selected
              ? FontWeight.w600
              : FontWeight.w400,
          color: selected
              ? const Color(0xFF5136D9)
              : const Color(0xFF3F444C),
        ),
      ),

      // Fungsi ketika menu diklik
      onTap: onTap,
    ),
  );
}
  } 
 
// ============================================================ 
// TOP BAR 
// ============================================================ 
 
class DashboardTopBar extends StatelessWidget { 
  const DashboardTopBar({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      height: 72, 
      padding: const EdgeInsets.symmetric( 
        horizontal: 28, 
      ), 
      decoration: const BoxDecoration( 
        color: Colors.white, 
        border: Border( 
          bottom: BorderSide( 
            color: Color(0xFFE6E8EC), 
          ), 
        ), 
      ), 
      child: Row( 
        children: [ 
          const Expanded( 
            child: Text( 
              'Portal  /  Sistem Akademik  /  Dashboard Dosen', 
              style: TextStyle( 
                fontSize: 13, 
                color: Color(0xFF737984), 
              ), 
            ), 
          ), 
 
          Container( 
            padding: const EdgeInsets.symmetric( 
              horizontal: 12, 
              vertical: 8, 
            ), 
            decoration: BoxDecoration( 
              color: const Color(0xFFF1EFFF), 
              borderRadius: BorderRadius.circular(20), 
            ), 
            child: const Row( 
              children: [ 
                Icon( 
                  Icons.circle, 
                  size: 8, 
                  color: Color(0xFF12B77A), 
                ), 
                SizedBox(width: 7), 
                Text( 
                  'Semester Ganjil 2024/2025', 
                  style: TextStyle( 
                    fontSize: 12, 
                    color: Color(0xFF504B79), 
                    fontWeight: FontWeight.w500, 
                  ), 
                ), 
              ], 
            ), 
          ), 
 
          const SizedBox(width: 24), 
 
          const Column( 
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.end, 
            children: [ 
              Text( 
                'Dr. Ir. Hendra, M.T.', 
                style: TextStyle( 
                  fontSize: 13, 
                  fontWeight: FontWeight.bold, 
                ), 
              ), 
              SizedBox(height: 2), 
              Text( 
                'NIDN: 0412088201', 
                style: TextStyle( 
                  fontSize: 11, 
                  color: Color(0xFF777D87), 
                ), 
              ), 
            ], 
          ), 
 
          const SizedBox(width: 12), 
 
          const CircleAvatar( 
            radius: 21, 
            backgroundColor: Color(0xFF5136D9), 
            child: Text( 
              'H', 
              style: TextStyle( 
                color: Colors.white, 
                fontWeight: FontWeight.bold, 
              ), 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
} 
 
// ============================================================ 
// DASHBOARD CONTENT 
// ============================================================ 
 
class DashboardContent extends StatelessWidget { 
  const DashboardContent({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return LayoutBuilder( 
      builder: (context, constraints) { 
        final width = constraints.maxWidth; 
 
        final isSmall = width < 700; 
        final isTablet = width >= 700 && width < 1100; 
 
        return SingleChildScrollView( 
          padding: EdgeInsets.all( 
            isSmall ? 16 : 28, 
          ), 
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [ 
              _pageTitle(context), 
 
              const SizedBox(height: 24), 
 
              _statistics( 
                isSmall: isSmall, 
                isTablet: isTablet, 
              ), 
 
              const SizedBox(height: 24), 
 
              if (isSmall) 
                Column( 
                  children: const [ 
                    ScheduleCard(), 
                    SizedBox(height: 20), 
                    ProgressCard(), 
                    SizedBox(height: 20), 
                    ActivityCard(), 
                    SizedBox(height: 20), 
                    AnnouncementCard(), 
                  ], 
                ) 
              else 
                Row( 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [ 
                    Expanded( 
                      flex: 7, 
                      child: Column( 
                        children: const [ 
                          ScheduleCard(), 
                          SizedBox(height: 20), 
                          ProgressCard(), 
                        ], 
                      ), 
                    ), 
                    const SizedBox(width: 20), 
                    Expanded( 
                      flex: 3, 
                      child: Column( 
                        children: const [ 
                          ActivityCard(), 
                          SizedBox(height: 20), 
                          AnnouncementCard(), 
                        ], 
                      ), 
                    ), 
                  ], 
                ), 
 
              const SizedBox(height: 30), 
 
              const Divider(), 
 
              const SizedBox(height: 12), 
 
              const Row( 
                children: [ 
                  Expanded( 
                    child: Text( 
                      '© 2024 Lembaga Layanan Pendidikan Tinggi (LLDIKTI). Hak Cipta Dilindungi.', 
                      style: TextStyle( 
                        fontSize: 11, 
                        color: Color(0xFF777D87), 
                      ), 
                    ), 
                  ), 
                  Icon( 
                    Icons.circle, 
                    size: 7, 
                    color: Color(0xFF15B77B), 
                  ), 
                  SizedBox(width: 6), 
                  Text( 
                    'SLA 99.99% Available', 
                    style: TextStyle( 
                      fontSize: 11, 
                      color: Color(0xFF666C75), 
                    ), 
                  ), 
                ], 
              ), 
            ], 
          ), 
        ); 
      }, 
    ); 
  } 
 
  Widget _pageTitle(BuildContext context) { 
    return LayoutBuilder( 
      builder: (context, constraints) { 
        final small = constraints.maxWidth < 800; 
 
        return Flex( 
          direction: small 
              ? Axis.vertical 
              : Axis.horizontal, 
          crossAxisAlignment: small 
              ? CrossAxisAlignment.start 
              : CrossAxisAlignment.center, 
          children: [ 
            Expanded( 
              flex: small ? 0 : 1, 
              child: Column( 
                crossAxisAlignment: 
                    CrossAxisAlignment.start, 
                children: [ 
                  Wrap( 
                    spacing: 10, 
                    runSpacing: 8, 
                    crossAxisAlignment: 
                        WrapCrossAlignment.center, 
                    children: [ 
                      const Text( 
                        'Dashboard Dosen', 
                        style: TextStyle( 
                          fontSize: 26, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFF20242A), 
                        ), 
                      ), 
                      Container( 
                        padding: const EdgeInsets.symmetric( 
                          horizontal: 9, 
                          vertical: 5, 
                        ), 
                        decoration: BoxDecoration( 
                          color: const Color(0xFFEFEAFF), 
                          borderRadius: 
                              BorderRadius.circular(20), 
                        ), 
                        child: const Text( 
                          '2024/2025 Ganjil Aktif', 
                          style: TextStyle( 
                            fontSize: 11, 
                            color: Color(0xFF5136D9), 
                            fontWeight: FontWeight.w600, 
                          ), 
                        ), 
                      ), 
                    ], 
                  ), 
                  const SizedBox(height: 8), 
                  const Text( 
                    'Monitoring rekapitulasi capaian akademik & konfirmasi evaluasi ' 
                    'mahasiswa berbasis Outcome-Based Education (OBE).', 
                    style: TextStyle( 
                      fontSize: 13, 
                      height: 1.5, 
                      color: Color(0xFF737983), 
                    ), 
                  ), 
                ], 
              ), 
            ), 
 
            if (!small) const SizedBox(width: 20), 
 
            if (!small) 
              Row( 
                children: [ 
                  _actionButton( 
                    Icons.picture_as_pdf_outlined, 
                    'Export PDF', 
                  ), 
                  const SizedBox(width: 10), 
                  _actionButton( 
                    Icons.auto_awesome, 
                    'Generate AI', 
                    primary: true, 
                  ), 
                  const SizedBox(width: 10), 
                  _actionButton( 
                    Icons.add, 
                    'Input Nilai', 
                    primary: true, 
                  ), 
                ], 
              ), 
          ], 
        ); 
      }, 
    ); 
  } 
 
  Widget _actionButton( 
    IconData icon, 
    String text, { 
    bool primary = false, 
  }) { 
    return Container( 
      padding: const EdgeInsets.symmetric( 
        horizontal: 14, 
        vertical: 11, 
      ), 
      decoration: BoxDecoration( 
        color: primary 
            ? const Color(0xFF5136D9) 
            : Colors.white, 
        borderRadius: BorderRadius.circular(8), 
        border: Border.all( 
          color: primary 
              ? const Color(0xFF5136D9) 
              : const Color(0xFFDDE0E5), 
        ), 
      ), 
      child: Row( 
        children: [ 
          Icon( 
            icon, 
            size: 17, 
            color: primary 
                ? Colors.white 
                : const Color(0xFF555B65), 
          ), 
          const SizedBox(width: 7), 
          Text( 
            text, 
            style: TextStyle( 
              fontSize: 12, 
              color: primary 
                  ? Colors.white 
                  : const Color(0xFF555B65), 
              fontWeight: FontWeight.w600, 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _statistics({ 
    required bool isSmall, 
    required bool isTablet, 
  }) { 
    final cards = [ 
      const StatCard( 
        title: 'Total Kelas Diampu', 
        number: '4', 
        subtitle: 'Kelas Aktif', 
        icon: Icons.grid_view_rounded, 
        color: Color(0xFF5843DA), 
        bottom: 'Kapasitas ruang optimal', 
      ), 
      const StatCard( 
        title: 'Total Mahasiswa', 
        number: '128', 
        subtitle: 'Terdaftar', 
        icon: Icons.groups_outlined, 
        color: Color(0xFF46464F), 
        bottom: '128 Aktif • 2 Program Studi', 
      ), 
      const StatCard( 
        title: 'Rekap Tertunda', 
        number: '2', 
        subtitle: 'Kelas Tertunda', 
        icon: Icons.pending_actions_outlined, 
        color: Color(0xFFD46D45), 
        bottom: 'Sisa 6 hari pengisian', 
      ), 
      const StatCard( 
        title: 'Analitik OBE & AI', 
        number: '3', 
        subtitle: 'Laporan Siap', 
        icon: Icons.psychology_outlined, 
        color: Color(0xFF7144D9), 
        bottom: 'Akurasi model 98.4%', 
      ), 
    ]; 
 
    if (isSmall) { 
      return Column( 
        children: [ 
          Row( 
            children: [ 
              Expanded(child: cards[0]), 
              const SizedBox(width: 12), 
              Expanded(child: cards[1]), 
            ], 
          ), 
          const SizedBox(height: 12), 
          Row( 
            children: [ 
              Expanded(child: cards[2]), 
              const SizedBox(width: 12), 
              Expanded(child: cards[3]), 
            ], 
          ), 
        ], 
      ); 
    } 
 
    if (isTablet) { 
      return Column( 
        children: [ 
          Row( 
            children: [ 
              Expanded(child: cards[0]), 
              const SizedBox(width: 12), 
              Expanded(child: cards[1]), 
            ], 
          ), 
          const SizedBox(height: 12), 
          Row( 
            children: [ 
              Expanded(child: cards[2]), 
              const SizedBox(width: 12), 
              Expanded(child: cards[3]), 
            ], 
          ), 
        ], 
      ); 
    } 
 
    return Row( 
      children: [ 
        for (int i = 0; i < cards.length; i++) ...[ 
          Expanded(child: cards[i]), 
          if (i != cards.length - 1) 
            const SizedBox(width: 12), 
        ], 
      ], 
    ); 
  } 
} 
 
// ============================================================ 
// STAT CARD 
// ============================================================ 
 
class StatCard extends StatelessWidget { 
  final String title; 
  final String number; 
  final String subtitle; 
  final IconData icon; 
  final Color color; 
  final String bottom; 
 
  const StatCard({ 
    super.key, 
    required this.title, 
    required this.number, 
    required this.subtitle, 
    required this.icon, 
    required this.color, 
    required this.bottom, 
  }); 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      height: 145, 
      padding: const EdgeInsets.all(18), 
      decoration: BoxDecoration( 
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12), 
        border: Border.all( 
          color: const Color(0xFFE5E7EB), 
        ), 
      ), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [ 
          Row( 
            children: [ 
              Expanded( 
                child: Text( 
                  title, 
                  style: const TextStyle( 
                    fontSize: 12, 
                    color: Color(0xFF6D737D), 
                  ), 
                ), 
              ), 
              Container( 
                width: 38, 
                height: 38, 
                decoration: BoxDecoration( 
                  color: color.withOpacity(.1), 
                  borderRadius: BorderRadius.circular(9), 
                ), 
                child: Icon( 
                  icon, 
                  color: color, 
                  size: 20, 
                ), 
              ), 
            ], 
          ), 
 
          const SizedBox(height: 12), 
 
          Row( 
            crossAxisAlignment: 
                CrossAxisAlignment.end, 
            children: [ 
              Text( 
                number, 
                style: const TextStyle( 
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Color(0xFF20242A), 
                ), 
              ), 
              const SizedBox(width: 8), 
              Padding( 
                padding: const EdgeInsets.only( 
                  bottom: 4, 
                ), 
                child: Text( 
                  subtitle, 
                  style: TextStyle( 
                    fontSize: 12, 
                    color: color, 
                    fontWeight: FontWeight.w600, 
                  ), 
                ), 
              ), 
            ], 
          ), 
 
          const Spacer(), 
 
          Text( 
            bottom, 
            style: TextStyle( 
              fontSize: 11, 
              color: color, 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
} 
 
// ============================================================ 
// SECTION CARD 
// ============================================================ 
 
class SectionCard extends StatelessWidget { 
  final Widget child; 
 
  const SectionCard({ 
    super.key, 
    required this.child, 
  }); 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      width: double.infinity, 
      padding: const EdgeInsets.all(20), 
      decoration: BoxDecoration( 
        color: Colors.white, 
        borderRadius: BorderRadius.circular(14), 
        border: Border.all( 
          color: const Color(0xFFE5E7EB), 
        ), 
      ), 
      child: child, 
    ); 
  } 
} 
 
// ============================================================ 
// SCHEDULE 
// ============================================================ 
 
class ScheduleCard extends StatelessWidget { 
  const ScheduleCard({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return SectionCard( 
      child: Column( 
        crossAxisAlignment: 
            CrossAxisAlignment.start, 
        children: [ 
          const Row( 
            children: [ 
              Icon( 
                Icons.calendar_today_outlined, 
                color: Color(0xFF5136D9), 
                size: 21, 
              ), 
              SizedBox(width: 10), 
              Expanded( 
                child: Column( 
                  crossAxisAlignment: 
                      CrossAxisAlignment.start, 
                  children: [ 
                    Text( 
                      'Jadwal Mengajar Hari Ini', 
                      style: TextStyle( 
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                      ), 
                    ), 
                    SizedBox(height: 3), 
                    Text( 
                      'Sinkronisasi langsung dengan Sistem Akademik Kampus', 
                      style: TextStyle( 
                        fontSize: 12, 
                        color: Color(0xFF777D87), 
                      ), 
                    ), 
                  ], 
                ), 
              ), 
              Text( 
                'Kamis, 24 Okt 2024', 
                style: TextStyle( 
                  fontSize: 12, 
                  color: Color(0xFF5136D9), 
                  fontWeight: FontWeight.w600, 
                ), 
              ), 
            ], 
          ), 
 
          const SizedBox(height: 18), 
 
          ScheduleItem( 
            time: '08:00', 
            duration: '10:30 WIB', 
            title: 
                'Rekayasa Perangkat Lunak (IF-401)', 
            status: 'Sesi Berlangsung', 
            room: 'Lab Komputer 1', 
            students: '36 Mahasiswa Hadir', 
            button: 'Buka Presensi', 
            active: true, 
          ), 
 
          const SizedBox(height: 12), 
 
          ScheduleItem( 
            time: '13:00', 
            duration: '15:30 WIB', 
            title: 
                'Sistem Basis Data Terdistribusi (IF-204)', 
            status: 'Akan Datang', 
            room: 'Ruang Teori 402', 
            students: '42 Mahasiswa Terdaftar', 
            button: 'Mulai dalam 2 jam', 
          ), 
        ], 
      ), 
    ); 
  } 
} 
 
class ScheduleItem extends StatelessWidget { 
  final String time; 
  final String duration; 
  final String title; 
  final String status; 
  final String room; 
  final String students; 
  final String button; 
  final bool active; 
 
  const ScheduleItem({ 
    super.key, 
    required this.time, 
    required this.duration, 
    required this.title, 
    required this.status, 
    required this.room, 
    required this.students, 
    required this.button, 
    this.active = false, 
  }); 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      padding: const EdgeInsets.all(14), 
      decoration: BoxDecoration( 
        color: const Color(0xFFFAF9FF), 
        borderRadius: BorderRadius.circular(10), 
      ), 
      child: Row( 
        children: [ 
          Container( 
            width: 70, 
            padding: const EdgeInsets.symmetric( 
              vertical: 10, 
            ), 
            decoration: BoxDecoration( 
              color: Colors.white, 
              borderRadius: BorderRadius.circular(8), 
            ), 
            child: Column( 
              children: [ 
                Text( 
                  time, 
                  style: const TextStyle( 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF5136D9), 
                  ), 
                ), 
                const SizedBox(height: 3), 
                Text( 
                  duration, 
                  style: const TextStyle( 
                    fontSize: 10, 
                    color: Color(0xFF777D87), 
                  ), 
                ), 
              ], 
            ), 
          ), 
 
          const SizedBox(width: 14), 
 
          Expanded( 
            child: Column( 
              crossAxisAlignment: 
                  CrossAxisAlignment.start, 
              children: [ 
                Text( 
                  title, 
                  style: const TextStyle( 
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                  ), 
                ), 
 
                const SizedBox(height: 7), 
 
                Row( 
                  children: [ 
                    Icon( 
                      active 
                          ? Icons.circle 
                          : Icons.access_time, 
                      size: 10, 
                      color: active 
                          ? const Color(0xFF12B57D) 
                          : const Color(0xFF777D87), 
                    ), 
                    const SizedBox(width: 5), 
                    Text( 
                      status, 
                      style: TextStyle( 
                        fontSize: 11, 
                        color: active 
                            ? const Color(0xFF12B57D) 
                            : const Color(0xFF777D87), 
                      ), 
                    ), 
                  ], 
                ), 
 
                const SizedBox(height: 6), 
 
                Wrap( 
                  spacing: 15, 
                  runSpacing: 5, 
                  children: [ 
                    Text( 
                      '📍 $room', 
                      style: const TextStyle( 
                        fontSize: 11, 
                        color: Color(0xFF777D87), 
                      ), 
                    ), 
                    Text( 
                      '👥 $students', 
                      style: const TextStyle( 
                        fontSize: 11, 
                        color: Color(0xFF777D87), 
                      ), 
                    ), 
                  ], 
                ), 
              ], 
            ), 
          ), 
 
          if (active) 
            Container( 
              padding: const EdgeInsets.symmetric( 
                horizontal: 12, 
                vertical: 10, 
              ), 
              decoration: BoxDecoration( 
                color: const Color(0xFF5136D9), 
                borderRadius: BorderRadius.circular(7), 
              ), 
              child: const Text( 
                'Buka Presensi', 
                style: TextStyle( 
                  fontSize: 11, 
                  color: Colors.white, 
                  fontWeight: FontWeight.w600, 
                ), 
              ), 
            ) 
          else 
            Text( 
              button, 
              style: const TextStyle( 
                fontSize: 11, 
                color: Color(0xFF777D87), 
              ), 
            ), 
        ], 
      ), 
    ); 
  } 
} 
 
// ============================================================ 
// PROGRESS 
// ============================================================ 
 
class ProgressCard extends StatelessWidget { 
  const ProgressCard({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return SectionCard( 
      child: Column( 
        crossAxisAlignment: 
            CrossAxisAlignment.start, 
        children: [ 
          const Row( 
            children: [ 
              Icon( 
                Icons.analytics_outlined, 
                color: Color(0xFF5136D9), 
              ), 
              SizedBox(width: 10), 
              Expanded( 
                child: Column( 
                  crossAxisAlignment: 
                      CrossAxisAlignment.start, 
                  children: [ 
                    Text( 
                      'Progress Penginputan Nilai OBE', 
                      style: TextStyle( 
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                      ), 
                    ), 
                    SizedBox(height: 3), 
                    Text( 
                      'Status rekap OBE (Capaian Pembelajaran Lulusan)', 
                      style: TextStyle( 
                        fontSize: 12, 
                        color: Color(0xFF777D87), 
                      ), 
                    ), 
                  ], 
                ), 
              ), 
              Text( 
                'Target Final: 30 Nov 2024', 
                style: TextStyle( 
                  fontSize: 12, 
                  color: Color(0xFFAE7B18), 
                  fontWeight: FontWeight.w600, 
                ), 
              ), 
            ], 
          ), 
 
          const SizedBox(height: 20), 
 
          const ProgressItem( 
            title: 
                'Rekayasa Perangkat Lunak - Kls A', 
            description: 
                '32 dari 36 Mahasiswa telah dinilai komprehensif', 
            percent: '85%', 
            value: .85, 
            color: Color(0xFF6844D8), 
            button: 'Lanjutkan Edit', 
            footer: 
                'Komponen: Tugas (100%), UTS (100%), UAS (80%)', 
          ), 
 
          const SizedBox(height: 14), 
 
          const ProgressItem( 
            title: 
                'Interaksi Manusia & Komputer - Kls C', 
            description: 
                '48 dari 48 Mahasiswa sudah dinilai penuh', 
            percent: '100%', 
            value: 1, 
            color: Color(0xFF11B98A), 
            button: 'Terkunci / Selesai', 
            footer: 
                'Arsip dikirim ke BAAK pada 22 Okt 2024', 
          ), 
 
          const SizedBox(height: 14), 
 
          const ProgressItem( 
            title: 
                'Sistem Basis Data Terdistribusi - Kls B', 
            description: 
                '0 dari 42 Mahasiswa dinilai', 
            percent: '0%', 
            value: 0, 
            color: Color(0xFF6844D8), 
            button: 'Mulai Input', 
            footer: 
                'Belum ada nilai tugas terunggah', 
          ), 
        ], 
      ), 
    ); 
  } 
} 
 
class ProgressItem extends StatelessWidget { 
  final String title; 
  final String description; 
  final String percent; 
  final double value; 
  final Color color; 
  final String button; 
  final String footer; 
 
  const ProgressItem({ 
    super.key, 
    required this.title, 
    required this.description, 
    required this.percent, 
    required this.value, 
    required this.color, 
    required this.button, 
    required this.footer, 
  }); 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      padding: const EdgeInsets.all(14), 
      decoration: BoxDecoration( 
        color: const Color(0xFFFAFBFD), 
        borderRadius: BorderRadius.circular(9), 
      ), 
      child: Column( 
        crossAxisAlignment: 
            CrossAxisAlignment.start, 
        children: [ 
          Row( 
            children: [ 
              Expanded( 
                child: Column( 
                  crossAxisAlignment: 
                      CrossAxisAlignment.start, 
                  children: [ 
                    Text( 
                      title, 
                      style: const TextStyle( 
                        fontSize: 13, 
                        fontWeight: FontWeight.bold, 
                      ), 
                    ), 
                    const SizedBox(height: 4), 
                    Text( 
                      description, 
                      style: const TextStyle( 
                        fontSize: 11, 
                        color: Color(0xFF777D87), 
                      ), 
                    ), 
                  ], 
                ), 
              ), 
              Text( 
                percent, 
                style: TextStyle( 
                  fontSize: 17, 
                  fontWeight: FontWeight.bold, 
                  color: color, 
                ), 
              ), 
            ], 
          ), 
 
          const SizedBox(height: 10), 
 
          ClipRRect( 
            borderRadius: BorderRadius.circular(10), 
            child: LinearProgressIndicator( 
              value: value, 
              minHeight: 7, 
              backgroundColor: 
                  color.withOpacity(.1), 
              valueColor: 
                  AlwaysStoppedAnimation<Color>( 
                color, 
              ), 
            ), 
          ), 
 
          const SizedBox(height: 8), 
 
          Row( 
            children: [ 
              Expanded( 
                child: Text( 
                  footer, 
                  style: const TextStyle( 
                    fontSize: 10, 
                    color: Color(0xFF777D87), 
                  ), 
                ), 
              ), 
              Text( 
                button, 
                style: TextStyle( 
                  fontSize: 11, 
                  color: color, 
                  fontWeight: FontWeight.w600, 
                ), 
              ), 
            ], 
          ), 
        ], 
      ), 
    ); 
  } 
} 
 
// ============================================================ 
// ACTIVITY 
// ============================================================ 
 
class ActivityCard extends StatelessWidget { 
  const ActivityCard({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return SectionCard( 
      child: Column( 
        crossAxisAlignment: 
            CrossAxisAlignment.start, 
        children: [ 
          Row( 
            children: [ 
              const Icon( 
                Icons.notifications_none, 
                color: Color(0xFF6844D8), 
              ), 
              const SizedBox(width: 8), 
              const Expanded( 
                child: Text( 
                  'Aktivitas Terbaru', 
                  style: TextStyle( 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                  ), 
                ), 
              ), 
              Container( 
                padding: const EdgeInsets.symmetric( 
                  horizontal: 8, 
                  vertical: 5, 
                ), 
                decoration: BoxDecoration( 
                  color: const Color(0xFFF1F2F5), 
                  borderRadius: BorderRadius.circular(10), 
                ), 
                child: const Text( 
                  '4 Log Baru', 
                  style: TextStyle(fontSize: 10), 
                ), 
              ), 
            ], 
          ), 
 
          const SizedBox(height: 18), 
 
          const ActivityItem( 
            tag: 'AI Generated', 
            text: 
                'Feedback otomatis rubrik Capaian Pembelajaran kelas RPL A berhasil diaktifkan.', 
            time: '10m lalu', 
          ), 
 
          const ActivityItem( 
            tag: 'Nilai Diinput', 
            text: 
                'Penilaian Tugas Proyek Kelompok 2 dikonfirmasi ke server pusat.', 
            time: '1j lalu', 
          ), 
 
          const ActivityItem( 
            tag: 'Portal BAAK', 
            text: 
                'Batas akhir perbaikan nilai komponen semester genap: 10 Des 2024.', 
            time: '3j lalu', 
          ), 
 
          const ActivityItem( 
            tag: 'Cetak PDF', 
            text: 
                'Dokumen Berita Acara Perkuliahan resmi MK-C berhasil diekspor.', 
            time: 'Kemarin', 
          ), 
 
          const SizedBox(height: 5), 
 
          const Center( 
            child: Text( 
              'Lihat Riwayat Log Lengkap →', 
              style: TextStyle( 
                fontSize: 12, 
                color: Color(0xFF5B42D4), 
                fontWeight: FontWeight.bold, 
              ), 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
} 
 
class ActivityItem extends StatelessWidget { 
  final String tag; 
  final String text; 
  final String time; 
 
  const ActivityItem({ 
    super.key, 
    required this.tag, 
    required this.text, 
    required this.time, 
  }); 
 
  @override 
  Widget build(BuildContext context) { 
    return Padding( 
      padding: const EdgeInsets.only(bottom: 15), 
      child: Column( 
        crossAxisAlignment: 
            CrossAxisAlignment.start, 
        children: [ 
          Row( 
            children: [ 
              Container( 
                padding: const EdgeInsets.symmetric( 
                  horizontal: 7, 
                  vertical: 4, 
                ), 
                decoration: BoxDecoration( 
                  color: const Color(0xFFECE4FF), 
                  borderRadius: BorderRadius.circular(5), 
                ), 
                child: Text( 
                  tag, 
                  style: const TextStyle( 
                    fontSize: 10, 
                    color: Color(0xFF6343D4), 
                    fontWeight: FontWeight.bold, 
                  ), 
                ), 
              ), 
              const Spacer(), 
              Text( 
                time, 
                style: const TextStyle( 
                  fontSize: 10, 
                  color: Color(0xFF858B94), 
                ), 
              ), 
            ], 
          ), 
          const SizedBox(height: 6), 
          Text( 
            text, 
            style: const TextStyle( 
              fontSize: 12, 
              height: 1.5, 
              color: Color(0xFF4F545C), 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
} 
 
// ============================================================ 
// ANNOUNCEMENT 
// ============================================================ 
 
class AnnouncementCard extends StatelessWidget { 
  const AnnouncementCard({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return SectionCard( 
      child: Column( 
        crossAxisAlignment: 
            CrossAxisAlignment.start, 
        children: [ 
          Row( 
            children: [ 
              const Icon( 
                Icons.campaign_outlined, 
                color: Color(0xFF6844D8), 
              ), 
              const SizedBox(width: 8), 
              const Expanded( 
                child: Text( 
                  'Pengumuman Fakultas', 
                  style: TextStyle( 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                  ), 
                ), 
              ), 
              Container( 
                padding: const EdgeInsets.symmetric( 
                  horizontal: 8, 
                  vertical: 5, 
                ), 
                decoration: BoxDecoration( 
                  color: const Color(0xFFE7FFF5), 
                  borderRadius: BorderRadius.circular(10), 
                ), 
                child: const Text( 
                  'Penting', 
                  style: TextStyle( 
                    fontSize: 10, 
                    color: Color(0xFF12A16F), 
                  ), 
                ), 
              ), 
            ], 
          ), 
 
          const SizedBox(height: 15), 
 
          Container( 
            height: 120, 
            width: double.infinity, 
            decoration: BoxDecoration( 
              borderRadius: BorderRadius.circular(10), 
              gradient: const LinearGradient( 
                colors: [ 
                  Color(0xFF6425C8), 
                  Color(0xFFE7B6E7), 
                ], 
              ), 
            ), 
            child: const Center( 
              child: Column( 
                mainAxisAlignment: 
                    MainAxisAlignment.center, 
                children: [ 
                  Text( 
                    'FACULTY SEMINAR DIGITAL', 
                    style: TextStyle( 
                      color: Colors.white, 
                      fontSize: 12, 
                      fontWeight: FontWeight.bold, 
                    ), 
                  ), 
                  SizedBox(height: 5), 
                  Text( 
                    'Campus Transformation', 
                    style: TextStyle( 
                      color: Colors.white, 
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                    ), 
                  ), 
                ], 
              ), 
            ), 
          ), 
 
          const SizedBox(height: 14), 
 
          const Text( 
            'Sosialisasi Penjaminan Mutu Akademik & Evaluasi OBE', 
            style: TextStyle( 
              fontSize: 14, 
              fontWeight: FontWeight.bold, 
              height: 1.4, 
            ), 
          ), 
 
          const SizedBox(height: 8), 
 
          const Text( 
            'Diharapkan seluruh koordinator mata kuliah menghadiri ' 
            'agenda pembekalan kurikulum digital dan penyiapan ' 
            'administrasi internal pada hari Jumat mendatang.', 
            style: TextStyle( 
              fontSize: 12, 
              height: 1.5, 
              color: Color(0xFF737983), 
            ), 
          ), 
 
          const SizedBox(height: 15), 
 
          Row( 
            children: [ 
              const Expanded( 
                child: Text( 
                  '📍 Auditorium Utama & Zoom', 
                  style: TextStyle( 
                    fontSize: 11, 
                    color: Color(0xFF656B74), 
                  ), 
                ), 
              ), 
              Container( 
                padding: const EdgeInsets.symmetric( 
                  horizontal: 10, 
                  vertical: 8, 
                ), 
                decoration: BoxDecoration( 
                  border: Border.all( 
                    color: const Color(0xFF6544D8), 
                  ), 
                  borderRadius: BorderRadius.circular(6), 
                ), 
                child: const Text( 
                  'Daftar Sekarang →', 
                  style: TextStyle( 
                    fontSize: 11, 
                    color: Color(0xFF6544D8), 
                    fontWeight: FontWeight.bold, 
                  ), 
                ), 
              ), 
            ], 
          ), 
        ], 
      ), 
    ); 
  } 
} 
