import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'detail_kelas_guru_page.dart';

class GuruDashboardPage extends StatefulWidget {
  const GuruDashboardPage({super.key});

  @override
  State<GuruDashboardPage> createState() => _GuruDashboardPageState();
}

class _GuruDashboardPageState extends State<GuruDashboardPage> {
  int selectedIndex = 0;

  // Menyimpan daftar kelas yang dibuat guru
  final List<Map<String, dynamic>> daftarKelas = [];

  // Warna utama MindSphere
  static const Color royalBlue = Color(0xFF2166D5);
  static const Color deepBlue = Color(0xFF123B70);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  // Membuat kode kelas otomatis
  String generateKodeKelas(String namaKelas) {
    final words = namaKelas
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toList();

    String kode = '';

    if (words.length >= 2) {
      kode = words
          .take(3)
          .map((word) => word[0].toUpperCase())
          .join();
    } else if (words.isNotEmpty) {
      kode = words[0].length >= 3
          ? words[0].substring(0, 3).toUpperCase()
          : words[0].toUpperCase();
    } else {
      kode = 'KLS';
    }

    final nomor = (daftarKelas.length + 1).toString().padLeft(2, '0');

    return '$kode-$nomor';
  }

  // =========================
  // BUAT KELAS
  // =========================

  void showBuatKelasDialog() {
    final namaKelasController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Buat Kelas Baru',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textBlue,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masukkan nama kelas yang ingin dibuat.',
                style: TextStyle(
                  color: mutedBlue,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: namaKelasController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Nama Kelas',
                  hintText: 'Contoh: Pemrograman Dasar X',
                  prefixIcon: const Icon(
                    Icons.class_rounded,
                    color: royalBlue,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F8FD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: royalBlue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: mutedBlue,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final namaKelas = namaKelasController.text.trim();

                if (namaKelas.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nama kelas harus diisi.'),
                    ),
                  );
                  return;
                }

                final kodeKelas = generateKodeKelas(namaKelas);

                setState(() {
                  daftarKelas.add({
                    'nama': namaKelas,
                    'kode': kodeKelas,
                    'jumlahSiswa': 0,
                  });
                });

                Navigator.pop(context);

                showKodeKelasDialog(
                  namaKelas,
                  kodeKelas,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buat Kelas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // DIALOG KODE KELAS
  // =========================

  void showKodeKelasDialog(
    String namaKelas,
    String kodeKelas,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: paleBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: royalBlue,
                  size: 42,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Kelas Berhasil Dibuat!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                namaKelas,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: mutedBlue,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Kode Kelas',
                style: TextStyle(
                  fontSize: 13,
                  color: mutedBlue,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: paleBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kodeKelas,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: royalBlue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: 'Salin kode',
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: kodeKelas),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Kode kelas berhasil disalin.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.copy_rounded,
                        color: royalBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bagikan kode ini kepada siswa agar mereka dapat bergabung ke kelas.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: mutedBlue,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: royalBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // SALIN KODE
  // =========================

  void salinKode(String kode) {
    Clipboard.setData(
      ClipboardData(text: kode),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kode kelas berhasil disalin.'),
      ),
    );
  }

  // =========================
  // HEADER
  // =========================

  Widget buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                royalBlue,
                skyBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.public_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MindSphere',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: textBlue,
                ),
              ),
              Text(
                'Dashboard Guru',
                style: TextStyle(
                  fontSize: 12,
                  color: mutedBlue,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: textBlue,
          ),
        ),
      ],
    );
  }

  // =========================
  // WELCOME CARD
  // =========================

  Widget buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            royalBlue,
            Color(0xFF4C9BF5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: royalBlue.withOpacity(0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang, Guru! 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bangun perjalanan belajar siswa bersama MindSphere.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: showBuatKelasDialog,
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 19,
                  ),
                  label: const Text('Buat Kelas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: royalBlue,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // KELAS SAYA
  // =========================

  Widget buildKelasSaya() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Kelas Saya',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textBlue,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: showBuatKelasDialog,
              icon: const Icon(
                Icons.add_rounded,
                size: 18,
              ),
              label: const Text('Buat Kelas'),
              style: TextButton.styleFrom(
                foregroundColor: royalBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (daftarKelas.isEmpty)
          buildEmptyClass()
        else
          ...daftarKelas.map(
            (kelas) {
              return buildClassCard(
                kelas['nama'],
                kelas['kode'],
                kelas['jumlahSiswa'],
              );
            },
          ),
      ],
    );
  }

  Widget buildEmptyClass() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE4EBF5),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              color: paleBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.class_outlined,
              color: royalBlue,
              size: 32,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Belum Ada Kelas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textBlue,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Buat kelas terlebih dahulu untuk mulai mengelola pembelajaran siswa.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: mutedBlue,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: showBuatKelasDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Buat Kelas'),
            style: ElevatedButton.styleFrom(
              backgroundColor: royalBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // CARD KELAS
  // =========================

  Widget buildClassCard(
    String nama,
    String kode,
    int jumlahSiswa,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE1E9F5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: paleBlue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: royalBlue,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$jumlahSiswa Siswa',
                      style: const TextStyle(
                        fontSize: 12,
                        color: mutedBlue,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  salinKode(kode);
                },
                tooltip: 'Salin kode',
                icon: const Icon(
                  Icons.copy_rounded,
                  color: royalBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F7FD),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.key_rounded,
                  color: royalBlue,
                  size: 20,
                ),
                const SizedBox(width: 9),
                const Text(
                  'Kode Kelas:',
                  style: TextStyle(
                    fontSize: 12,
                    color: mutedBlue,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  kode,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: textBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    salinKode(kode);
                  },
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 17,
                  ),
                  label: const Text('Salin Kode'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: royalBlue,
                    side: const BorderSide(
                      color: royalBlue,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // =========================
              // TOMBOL LIHAT KELAS
              // =========================
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailKelasGuruPage(
                          namaKelas: nama,
                          kodeKelas: kode,
                          jumlahSiswa: jumlahSiswa,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Lihat Kelas'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================
  // KELOLA PEMBELAJARAN
  // =========================

  Widget buildKelolaPembelajaran() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kelola Pembelajaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textBlue,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildMenuCard(
                icon: Icons.menu_book_rounded,
                title: 'Kelola Materi',
                subtitle: 'Tambah dan atur materi',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Halaman Kelola Materi akan dibuat selanjutnya.',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildMenuCard(
                icon: Icons.quiz_rounded,
                title: 'Kelola Tantangan',
                subtitle: 'Buat kuis dan soal',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Halaman Kelola Tantangan akan dibuat selanjutnya.',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildMenuCard(
                icon: Icons.bar_chart_rounded,
                title: 'Hasil Siswa',
                subtitle: 'Lihat perkembangan siswa',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Halaman Hasil Siswa akan dibuat selanjutnya.',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildMenuCard(
                icon: Icons.person_rounded,
                title: 'Profil',
                subtitle: 'Kelola profil guru',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Halaman Profil akan dibuat selanjutnya.',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE3EAF4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: paleBlue,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Icon(
                icon,
                color: royalBlue,
                size: 22,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: mutedBlue,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // RINGKASAN
  // =========================

  Widget buildRingkasan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Pembelajaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textBlue,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildStatCard(
                icon: Icons.people_alt_rounded,
                title: 'Siswa',
                value: totalSiswa().toString(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildStatCard(
                icon: Icons.menu_book_rounded,
                title: 'Materi',
                value: '0',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildStatCard(
                icon: Icons.quiz_rounded,
                title: 'Tantangan',
                value: '0',
              ),
            ),
          ],
        ),
      ],
    );
  }

  int totalSiswa() {
    int total = 0;

    for (final kelas in daftarKelas) {
      total += kelas['jumlahSiswa'] as int;
    }

    return total;
  }

  Widget buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE3EAF4),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: royalBlue,
            size: 25,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textBlue,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: mutedBlue,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // AKTIVITAS
  // =========================

  Widget buildAktivitas() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE3EAF4),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: paleBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: royalBlue,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum Ada Aktivitas',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textBlue,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Aktivitas siswa akan muncul di sini setelah kelas mulai digunakan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: mutedBlue,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // BOTTOM NAVIGATION
  // =========================

  Widget buildBottomNavigation() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            index: 0,
          ),
          buildNavItem(
            icon: Icons.menu_book_rounded,
            label: 'Materi',
            index: 1,
          ),
          buildNavItem(
            icon: Icons.quiz_rounded,
            label: 'Soal',
            index: 2,
          ),
          buildNavItem(
            icon: Icons.bar_chart_rounded,
            label: 'Hasil',
            index: 3,
          ),
          buildNavItem(
            icon: Icons.person_rounded,
            label: 'Profil',
            index: 4,
          ),
        ],
      ),
    );
  }

  Widget buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? paleBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 21,
              color: isSelected ? royalBlue : mutedBlue,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? royalBlue : mutedBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FE),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(),
                    const SizedBox(height: 22),
                    buildWelcomeCard(),
                    const SizedBox(height: 26),
                    buildKelasSaya(),
                    const SizedBox(height: 26),
                    buildKelolaPembelajaran(),
                    const SizedBox(height: 26),
                    buildRingkasan(),
                    const SizedBox(height: 26),
                    const Text(
                      'Aktivitas Terbaru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildAktivitas(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            buildBottomNavigation(),
          ],
        ),
      ),
    );
  }
}