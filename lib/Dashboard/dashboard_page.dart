import 'package:flutter/material.dart';
import 'detail_kelas_siswa_page.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Color royalBlue = const Color(0xFF2166D5);
  final Color deepBlue = const Color(0xFF123B70);
  final Color skyBlue = const Color(0xFF56B4F8);
  final Color paleBlue = const Color(0xFFDCEBFF);
  final Color textBlue = const Color(0xFF18365D);
  final Color mutedBlue = const Color(0xFF7288A8);

  String? namaKelas;
  String? kodeKelas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),

              _buildWelcomeCard(),
              const SizedBox(height: 20),

              _buildClassCard(context),
              const SizedBox(height: 24),

              _buildSectionTitle(
                'Perjalanan Belajar',
                'Mulai perjalanan belajarmu',
              ),
              const SizedBox(height: 14),

              _buildLearningJourney(),
              const SizedBox(height: 24),

              _buildSectionTitle(
                'Lanjutkan Belajar',
                'Materi akan muncul setelah kamu bergabung',
              ),
              const SizedBox(height: 14),

              _buildEmptyLearningCard(),
              const SizedBox(height: 24),

              _buildSectionTitle(
                'Tantangan',
                'Selesaikan tantangan dari kelasmu',
              ),
              const SizedBox(height: 14),

              _buildEmptyChallengeCard(),
              const SizedBox(height: 24),

              _buildProgressCard(),
              const SizedBox(height: 24),

              _buildAchievementCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // =========================
  // HEADER
  // =========================

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [royalBlue, skyBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.public_rounded,
            color: Colors.white,
            size: 27,
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MindSphere',
                style: TextStyle(
                  color: deepBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Dashboard Siswa',
                style: TextStyle(
                  color: mutedBlue,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: paleBlue,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: royalBlue,
          ),
        ),
      ],
    );
  }

  // =========================
  // WELCOME
  // =========================

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [deepBlue, royalBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo, Siswa! 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Siap memulai perjalanan belajar hari ini?',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // KELAS SAYA
  // =========================

  Widget _buildClassCard(BuildContext context) {
    if (kodeKelas == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: paleBlue,
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: paleBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.class_rounded,
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
                        'Kelas Saya',
                        style: TextStyle(
                          color: textBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Belum bergabung dengan kelas',
                        style: TextStyle(
                          color: mutedBlue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F9FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: royalBlue,
                    size: 22,
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Masukkan kode kelas dari guru untuk mulai belajar.',
                      style: TextStyle(
                        color: textBlue,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showJoinClassDialog(context);
                },
                icon: const Icon(
                  Icons.add_rounded,
                  size: 21,
                ),
                label: const Text(
                  'Gabung Kelas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: royalBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // =========================
    // JIKA SUDAH BERGABUNG
    // =========================

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [deepBlue, royalBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: royalBlue.withOpacity(0.18),
            blurRadius: 15,
            offset: const Offset(0, 7),
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
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.class_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kelas Saya',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      namaKelas ?? 'Kelas',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.key_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 9),

                const Text(
                  'Kode Kelas',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),

                const Spacer(),

                Text(
                  kodeKelas ?? '-',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailKelasSiswaPage(
                      namaKelas: namaKelas!,
                      kodeKelas: kodeKelas!,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.arrow_forward_rounded,
              ),
              label: const Text(
                'Masuk Kelas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: royalBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // DIALOG GABUNG KELAS
  // =========================

  void _showJoinClassDialog(BuildContext context) {
    final TextEditingController codeController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            'Gabung Kelas',
            style: TextStyle(
              color: deepBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Masukkan kode kelas yang diberikan oleh guru.',
                style: TextStyle(
                  color: mutedBlue,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),

              TextField(
                controller: codeController,
                textCapitalization:
                    TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'Contoh: PDX-01',
                  prefixIcon: Icon(
                    Icons.key_rounded,
                    color: royalBlue,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F9FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: mutedBlue,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final kode =
                    codeController.text.trim().toUpperCase();

                if (kode.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Kode kelas harus diisi.',
                      ),
                    ),
                  );
                  return;
                }

                // Simpan kelas sementara
                setState(() {
                  kodeKelas = kode;
                  namaKelas = 'Kelas $kode';
                });

                // Tutup dialog
                Navigator.pop(dialogContext);

                // Langsung masuk ke halaman kelas
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailKelasSiswaPage(
                      namaKelas: namaKelas!,
                      kodeKelas: kodeKelas!,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'Gabung',
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // SECTION TITLE
  // =========================

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: mutedBlue,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // =========================
  // LEARNING JOURNEY
  // =========================

  Widget _buildLearningJourney() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: paleBlue,
        ),
      ),
      child: Column(
        children: [
          _journeyItem(
            icon: Icons.menu_book_rounded,
            title: 'Materi',
            subtitle: 'Belum dimulai',
            active: false,
          ),

          _journeyLine(),

          _journeyItem(
            icon: Icons.explore_rounded,
            title: 'Eksplorasi',
            subtitle: 'Belum dimulai',
            active: false,
          ),

          _journeyLine(),

          _journeyItem(
            icon: Icons.flag_rounded,
            title: 'Tantangan',
            subtitle: 'Belum dimulai',
            active: false,
          ),
        ],
      ),
    );
  }

  Widget _journeyItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool active,
  }) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: active
                ? royalBlue
                : const Color(0xFFEAF1FC),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: active ? Colors.white : mutedBlue,
            size: 22,
          ),
        ),
        const SizedBox(width: 13),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(
                color: mutedBlue,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _journeyLine() {
    return Container(
      margin: const EdgeInsets.only(
        left: 21,
        top: 4,
        bottom: 4,
      ),
      width: 2,
      height: 25,
      color: paleBlue,
    );
  }

  // =========================
  // EMPTY LEARNING
  // =========================

  Widget _buildEmptyLearningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: paleBlue,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: paleBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_outlined,
              color: royalBlue,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            'Belum ada materi',
            style: TextStyle(
              color: textBlue,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Bergabung dengan kelas terlebih dahulu untuk melihat materi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: mutedBlue,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // EMPTY CHALLENGE
  // =========================

  Widget _buildEmptyChallengeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: paleBlue,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.flag_outlined,
              color: royalBlue,
              size: 26,
            ),
          ),
          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Belum ada tantangan',
                  style: TextStyle(
                    color: textBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tantangan akan tersedia setelah kamu bergabung dengan kelas.',
                  style: TextStyle(
                    color: mutedBlue,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // PROGRESS
  // =========================

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEAF3FF),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: paleBlue,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: royalBlue,
                size: 25,
              ),
              const SizedBox(width: 9),
              Text(
                'Progress Saya',
                style: TextStyle(
                  color: textBlue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Belum ada aktivitas',
                style: TextStyle(
                  color: mutedBlue,
                  fontSize: 12,
                ),
              ),
              Text(
                '0%',
                style: TextStyle(
                  color: royalBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0,
              minHeight: 9,
              backgroundColor: const Color(0xFFE0EAF7),
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                royalBlue,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              _progressInfo(
                'Materi',
                '0',
              ),
              const SizedBox(width: 35),
              _progressInfo(
                'Tantangan',
                '0',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressInfo(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: textBlue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: TextStyle(
            color: mutedBlue,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // =========================
  // ACHIEVEMENT
  // =========================

  Widget _buildAchievementCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: paleBlue,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4D9),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.emoji_events_outlined,
                  color: Color(0xFFE0A500),
                  size: 24,
                ),
              ),
              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pencapaian Kelas',
                      style: TextStyle(
                        color: textBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Hasil akan muncul setelah siswa mengerjakan tantangan.',
                      style: TextStyle(
                        color: mutedBlue,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 14,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFF),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  color: mutedBlue,
                  size: 30,
                ),
                const SizedBox(height: 7),
                Text(
                  'Belum ada hasil',
                  style: TextStyle(
                    color: textBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Belum ada siswa yang menyelesaikan tantangan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: mutedBlue,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // BOTTOM NAVIGATION
  // =========================

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: royalBlue,
      unselectedItemColor: mutedBlue,
      elevation: 10,
      selectedFontSize: 11,
      unselectedFontSize: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded),
          label: 'Materi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flag_rounded),
          label: 'Tantangan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up_rounded),
          label: 'Progress',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profil',
        ),
      ],
    );
  }
}