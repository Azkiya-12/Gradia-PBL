import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Row(
        children: [
          // ================= SIDEBAR =================
          Container(
            width: 220,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school,
                      color: Colors.deepPurple,
                      size: 30,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Gradia\nPortal Dosen",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                _sidebarTitle("UTAMA"),

                _menuItem(
                  icon: Icons.dashboard_outlined,
                  title: "Dashboard",
                ),

                _sidebarTitle("PERKULIAHAN & MAHASISWA"),

                _menuItem(
                  icon: Icons.people_outline,
                  title: "Manajemen Data Kelas",
                ),

                _menuItem(
                  icon: Icons.menu_book_outlined,
                  title: "Tambah Kelas & Mata Kuliah",
                ),

                _sidebarTitle("PENILAIAN & REKAPITULASI"),

                _menuItem(
                  icon: Icons.edit_note,
                  title: "Input Rekap Nilai",
                ),

                _menuItem(
                  icon: Icons.analytics_outlined,
                  title: "Analitik Nilai",
                ),

                _sidebarTitle("KECERDASAN BUATAN & LAPORAN"),

                _menuItem(
                  icon: Icons.auto_awesome,
                  title: "Analitik & Feedback",
                ),

                _menuItem(
                  icon: Icons.picture_as_pdf_outlined,
                  title: "Cetak PDF Laporan",
                ),

                _sidebarTitle("PENGATURAN AKUN"),

                _menuItem(
                  icon: Icons.person_outline,
                  title: "Kelola Profil",
                  active: true,
                ),

                _menuItem(
                  icon: Icons.lock_outline,
                  title: "Keamanan & Akun",
                ),

                _menuItem(
                  icon: Icons.notifications_none,
                  title: "Panduan Dosen",
                ),
              ],
            ),
          ),

          // ================= MAIN CONTENT =================
          Expanded(
            child: Column(
              children: [
                // HEADER
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Akademik / Portal Dosen",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1EEFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Semester Ganjil 2024/2025",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            "Dr. Ir. Hendra, M.T.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "NIDN: 0412088201",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 10),

                      CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.deepPurple,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= CONTENT =================
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BREADCRUMB
                        const Text(
                          "Kelola Profil Dosen",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          "Kelola identitas akademik terintegrasi, singkatkan NIDN/PDDIKTI, "
                          "beban SKS mengajar, publikasi triwulan, dan tanda tangan digital BAP perkuliahan.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ================= PROFILE HEADER =================
                        _profileHeader(),

                        const SizedBox(height: 18),

                        // TAB
                        Row(
                          children: [
                            _tabItem(
                              "Informasi Pribadi & Identitas",
                              true,
                            ),
                            _tabItem(
                              "Data Akademik & NIDK",
                              false,
                            ),
                            _tabItem(
                              "Beban Mengajar",
                              false,
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // GRID CONTENT
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 900) {
                              return Column(
                                children: [
                                  _leftContent(),
                                  const SizedBox(height: 15),
                                  _rightContent(),
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _leftContent(),
                                ),
                                const SizedBox(width: 18),
                                SizedBox(
                                  width: 320,
                                  child: _rightContent(),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // SAVE BUTTON
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text(
                                  "Batalkan Perubahan",
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.save_outlined),
                                label: const Text(
                                  "Simpan Perubahan Profil",
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIDEBAR
  // ============================================================

  static Widget _sidebarTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 10, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget _menuItem({
    required IconData icon,
    required String title,
    bool active = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFEDE8FF)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          size: 18,
          color: active
              ? Colors.deepPurple
              : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: active
                ? Colors.deepPurple
                : Colors.grey.shade700,
            fontWeight:
                active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  static Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 45,
              color: Colors.deepPurple.shade300,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dr. Ir. Hendra, M.T.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Dosen Tetap Yayasan",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "NIDN: 0412088201",
                  style: TextStyle(fontSize: 11),
                ),
                const Text(
                  "Teknik Informatika • Fakultas Ilmu Komputer",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              _smallBadge(
                Icons.verified,
                "Terverifikasi PDDIKTI",
                Colors.green,
              ),
              const SizedBox(height: 8),
              _smallBadge(
                Icons.school,
                "SKS Mengajar 24",
                Colors.deepPurple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _smallBadge(
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAB
  // ============================================================

  static Widget _tabItem(
    String title,
    bool active,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: active
            ? Colors.deepPurple
            : Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          color: active
              ? Colors.white
              : Colors.grey.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ============================================================
  // LEFT CONTENT
  // ============================================================

  static Widget _leftContent() {
    return Column(
      children: [
        _card(
          title: "Identitas Resmi & Kepegawaian",
          subtitle:
              "Sesuai data resmi terintegrasi ke Biro Kepegawaian Yayasan",
          child: Column(
            children: [
              _inputRow(
                "Gelar Depan",
                "Dr. Ir.",
                "Nama Lengkap (Tanpa Gelar)",
                "Hendra",
              ),
              _inputRow(
                "Gelar Belakang",
                "M.T.",
                "NIDN / NUP",
                "0412088201",
              ),
              _inputRow(
                "Email Resmi Kampus",
                "hendra.dosen@kampus.ac.id",
                "Nomor Kontak WhatsApp / HP",
                "+62 812-3456-7890",
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        _card(
          title: "Homebase & Penugasan Tridharma",
          subtitle:
              "Unit pengampu, laboratorium, dan informasi studi",
          child: Column(
            children: [
              _infoRow(
                "Fakultas",
                "Fakultas Ilmu Komputer",
              ),
              _infoRow(
                "Program Studi Homebase",
                "S1 Teknik Informatika",
              ),
              _infoRow(
                "Bidang Keahlian & Fokus Riset",
                "Software Engineering, Enterprise Architecture & Cloud Computing",
              ),
              _infoRow(
                "Jam Kerja Dosen",
                "Senin - Jumat",
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        _card(
          title: "Sinta & Google Scholar ID",
          subtitle:
              "Integrasi identitas publikasi akademik",
          child: Row(
            children: [
              const Icon(
                Icons.science_outlined,
                color: Colors.deepPurple,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "SINTA ID: 12345678 • H-Index: 10",
                  style: TextStyle(fontSize: 11),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Buka Profil Sinta",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RIGHT CONTENT
  // ============================================================

  static Widget _rightContent() {
    return Column(
      children: [
        _card(
          title: "Kelengkapan Berkas BKD",
          subtitle: "88% Lengkap",
          child: Column(
            children: [
              _statusRow(
                "Sertifikasi Dosen",
                "Terverifikasi",
                Colors.green,
              ),
              _statusRow(
                "SK Mengajar Semester Ganjil",
                "Terunggah",
                Colors.green,
              ),
              _statusRow(
                "Laporan BKD Dosen",
                "Sesuai",
                Colors.green,
              ),
              _statusRow(
                "Bukti Pengabdian Masyarakat",
                "Menunggu Upload",
                Colors.orange,
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        _card(
          title: "Tanda Tangan Elektronik Resmi",
          subtitle: "BAP",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tanda tangan digunakan otomatis pada Berita Acara "
                "Perkuliahan (BAP).",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "Dr. Ir. Hendra, M.T.\nNIDN: 0412088201",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.upload_file,
                        size: 15,
                      ),
                      label: const Text(
                        "Unggah Baru",
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.visibility_outlined,
                        size: 15,
                      ),
                      label: const Text(
                        "Lihat Dokumen",
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        _card(
          title: "Notifikasi & AI Ode Advisor",
          subtitle: "",
          child: Column(
            children: [
              _switchRow(
                "Ringkasan AI Capaian OMB",
                true,
              ),
              _switchRow(
                "Peringatan Deadline Input Rekap Nilai",
                true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  static Widget _card({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
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
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade500,
            ),
          ),

          const SizedBox(height: 15),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // INPUT
  // ============================================================

  static Widget _inputRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: _inputField(label1, value1),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _inputField(label2, value2),
          ),
        ],
      ),
    );
  }

  static Widget _inputField(
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: value,
          style: const TextStyle(fontSize: 10),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFO
  // ============================================================

  static Widget _infoRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  static Widget _statusRow(
    String title,
    String status,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 15,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 10),
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SWITCH
  // ============================================================

  static Widget _switchRow(
    String title,
    bool value,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: (value) {},
          activeColor: Colors.deepPurple,
        ),
      ],
    );
  }
}