import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  static const Color primaryBlue = Color(0xFF2166D5);
  static const Color lightBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFEAF6FF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);
  static const Color softBackground = Color(0xFFF7FBFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 18),

              _buildWelcomeCard(),

              const SizedBox(height: 24),

              _buildSectionTitle(
                'Perjalanan Belajar',
                'Lihat langkah belajarmu hari ini',
              ),

              const SizedBox(height: 12),

              _buildLearningJourney(),

              const SizedBox(height: 24),

              _buildSectionTitle(
                'Lanjutkan Belajar',
                'Teruskan dari materi terakhir',
              ),

              const SizedBox(height: 12),

              _buildContinueLearning(),

              const SizedBox(height: 24),

              _buildSectionTitle(
                'Tantangan Hari Ini',
                'Uji pemahamanmu dengan tantangan singkat',
              ),

              const SizedBox(height: 12),

              _buildChallengeCard(),

              const SizedBox(height: 24),

              _buildSectionTitle(
                'Progress Saya',
                'Pantau perkembangan belajarmu',
              ),

              const SizedBox(height: 12),

              _buildProgressCard(),

              const SizedBox(height: 24),

              _buildSectionTitle(
                'Pencapaian Kelas',
                'Lihat pencapaian belajar di kelasmu',
              ),

              const SizedBox(height: 12),

              _buildAchievementCard(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  lightBlue,
                  primaryBlue,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withOpacity(0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
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
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textBlue,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Dashboard Siswa',
                  style: TextStyle(
                    fontSize: 11.5,
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
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE2ECF5),
              ),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: textBlue,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WELCOME CARD
  // ============================================================

  Widget _buildWelcomeCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              lightBlue,
              primaryBlue,
            ],
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.22),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -25,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              right: 35,
              bottom: -45,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo, Siswa! 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Selamat datang kembali di MindSphere.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.90),
                    fontSize: 12.5,
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Yuk lanjutkan perjalanan belajarmu!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textBlue,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11.5,
              color: mutedBlue,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEARNING JOURNEY
  // ============================================================

  Widget _buildLearningJourney() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE2ECF5),
          ),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: paleBlue,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.route_rounded,
                    color: primaryBlue,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Perjalanan Belajarmu',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: textBlue,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Selesaikan setiap langkah secara bertahap',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: mutedBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                _journeyStep(
                  icon: Icons.menu_book_rounded,
                  label: 'Materi',
                  completed: true,
                ),

                _journeyLine(completed: true),

                _journeyStep(
                  icon: Icons.explore_rounded,
                  label: 'Eksplorasi',
                  completed: true,
                ),

                _journeyLine(completed: false),

                _journeyStep(
                  icon: Icons.flag_rounded,
                  label: 'Tantangan',
                  completed: false,
                  current: true,
                ),
              ],
            ),

            const SizedBox(height: 17),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF5FAFF),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: primaryBlue,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Langkah berikutnya: selesaikan tantanganmu.',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: textBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _journeyStep({
    required IconData icon,
    required String label,
    required bool completed,
    bool current = false,
  }) {
    return Column(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: completed
                ? primaryBlue
                : current
                    ? paleBlue
                    : const Color(0xFFF0F4F8),
            shape: BoxShape.circle,
            border: current
                ? Border.all(
                    color: primaryBlue,
                    width: 2,
                  )
                : null,
          ),
          child: Icon(
            completed ? Icons.check_rounded : icon,
            size: 20,
            color: completed
                ? Colors.white
                : current
                    ? primaryBlue
                    : mutedBlue,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: current || completed
                ? FontWeight.w700
                : FontWeight.w500,
            color: current || completed ? textBlue : mutedBlue,
          ),
        ),
      ],
    );
  }

  Widget _journeyLine({
    required bool completed,
  }) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(
          left: 5,
          right: 5,
          bottom: 22,
        ),
        decoration: BoxDecoration(
          color: completed
              ? primaryBlue
              : const Color(0xFFDDE7F0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // ============================================================
  // CONTINUE LEARNING
  // ============================================================

  Widget _buildContinueLearning() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE2ECF5),
          ),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.05),
              blurRadius: 16,
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
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFDDF1FF),
                        Color(0xFFEAF6FF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.code_rounded,
                    color: primaryBlue,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pemrograman Dasar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: textBlue,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Materi 2 dari 5',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: mutedBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: paleBlue,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Text(
                    '40%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: primaryBlue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 17),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const LinearProgressIndicator(
                value: 0.40,
                minHeight: 8,
                backgroundColor: Color(0xFFEAF1F7),
                valueColor: AlwaysStoppedAnimation<Color>(
                  primaryBlue,
                ),
              ),
            ),

            const SizedBox(height: 13),

            SizedBox(
              width: double.infinity,
              height: 43,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Lanjutkan Belajar',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CHALLENGE
  // ============================================================

  Widget _buildChallengeCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEAF6FF),
              Color(0xFFF7FBFF),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFD9EAF8),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.08),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.flag_rounded,
                color: primaryBlue,
                size: 27,
              ),
            ),

            const SizedBox(width: 13),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tantangan Pemrograman Dasar',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: textBlue,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '10 soal • Uji pemahamanmu',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: mutedBlue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE2ECF5),
          ),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
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
                  child: const Icon(
                    Icons.auto_graph_rounded,
                    color: primaryBlue,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress Belajar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: textBlue,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Perkembangan belajarmu saat ini',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: mutedBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                const Text(
                  '35%',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const LinearProgressIndicator(
                value: 0.35,
                minHeight: 9,
                backgroundColor: Color(0xFFEAF1F7),
                valueColor: AlwaysStoppedAnimation<Color>(
                  primaryBlue,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _progressInfo(
                    icon: Icons.menu_book_rounded,
                    value: '8',
                    label: 'Materi dipelajari',
                  ),
                ),

                Container(
                  width: 1,
                  height: 35,
                  color: const Color(0xFFE5EDF4),
                ),

                Expanded(
                  child: _progressInfo(
                    icon: Icons.flag_rounded,
                    value: '4',
                    label: 'Tantangan selesai',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressInfo({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: primaryBlue,
          size: 18,
        ),
        const SizedBox(width: 7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: textBlue,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 8.5,
                color: mutedBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // ACHIEVEMENT
  // ============================================================

  Widget _buildAchievementCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE2ECF5),
          ),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6D9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xFFD79B00),
                    size: 25,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pencapaian Kelas',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: textBlue,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Hasil pencapaian dari tantangan terakhir',
                        style: TextStyle(
                          fontSize: 10,
                          color: mutedBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _achievementRow(
              position: '1',
              name: 'Alya',
              score: '95',
              icon: Icons.looks_one_rounded,
            ),

            const SizedBox(height: 9),

            _achievementRow(
              position: '2',
              name: 'Budi',
              score: '90',
              icon: Icons.looks_two_rounded,
            ),

            const SizedBox(height: 9),

            _achievementRow(
              position: '3',
              name: 'Citra',
              score: '88',
              icon: Icons.looks_3_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _achievementRow({
    required String position,
    required String name,
    required String score,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFE),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryBlue,
            size: 22,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: textBlue,
              ),
            ),
          ),

          Text(
            score,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: primaryBlue,
            ),
          ),

          const SizedBox(width: 4),

          const Text(
            'nilai',
            style: TextStyle(
              fontSize: 9,
              color: mutedBlue,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomItem(
                icon: Icons.home_rounded,
                label: 'Beranda',
                active: true,
              ),
              _bottomItem(
                icon: Icons.menu_book_rounded,
                label: 'Materi',
              ),
              _bottomItem(
                icon: Icons.flag_rounded,
                label: 'Tantangan',
              ),
              _bottomItem(
                icon: Icons.auto_graph_rounded,
                label: 'Progress',
              ),
              _bottomItem(
                icon: Icons.person_rounded,
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required String label,
    bool active = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: active ? paleBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 21,
            color: active ? primaryBlue : mutedBlue,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? primaryBlue : mutedBlue,
          ),
        ),
      ],
    );
  }
}