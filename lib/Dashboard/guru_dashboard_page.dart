import 'package:flutter/material.dart';

class GuruDashboardPage extends StatelessWidget {
  const GuruDashboardPage({super.key});

  static const Color primaryBlue = Color(0xFF2166D5);
  static const Color lightBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFEAF6FF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildWelcomeCard(),
              const SizedBox(height: 24),
              _buildSectionTitle(
                'Menu Pengelolaan',
                'Kelola pembelajaran di MindSphere',
              ),
              const SizedBox(height: 13),
              _buildManagementMenu(),
              const SizedBox(height: 25),
              _buildSectionTitle(
                'Ringkasan Pembelajaran',
                'Informasi aktivitas siswa',
              ),
              const SizedBox(height: 13),
              _buildSummary(),
              const SizedBox(height: 25),
              _buildRecentActivity(),
              const SizedBox(height: 30),
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
                  'Dashboard Guru',
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

  // =========================
  // WELCOME CARD
  // =========================

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
              Color(0xFF56B4F8),
              Color(0xFF2166D5),
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
              right: 30,
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
                  'Halo, Guru! 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Selamat datang di dashboard MindSphere.',
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
                        'Kelola pembelajaran dengan mudah',
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

  // =========================
  // SECTION TITLE
  // =========================

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

  // =========================
  // MANAGEMENT MENU
  // =========================

  Widget _buildManagementMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _managementCard(
                  icon: Icons.menu_book_rounded,
                  title: 'Kelola Materi',
                  subtitle: 'Tambah dan ubah materi',
                  color: primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _managementCard(
                  icon: Icons.quiz_rounded,
                  title: 'Kelola Soal',
                  subtitle: 'Buat dan atur soal',
                  color: lightBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _managementCard(
                  icon: Icons.bar_chart_rounded,
                  title: 'Hasil Siswa',
                  subtitle: 'Lihat hasil belajar',
                  color: const Color(0xFF6A7FF2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _managementCard(
                  icon: Icons.person_rounded,
                  title: 'Profil',
                  subtitle: 'Kelola profil guru',
                  color: const Color(0xFF4C9FEF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _managementCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      height: 125,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE3EDF6),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 23,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: textBlue,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9.5,
              color: mutedBlue,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // SUMMARY
  // =========================

  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _summaryCard(
              icon: Icons.people_alt_rounded,
              value: '24',
              label: 'Siswa',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _summaryCard(
              icon: Icons.menu_book_rounded,
              value: '8',
              label: 'Materi',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _summaryCard(
              icon: Icons.quiz_rounded,
              value: '12',
              label: 'Soal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE3EDF6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: primaryBlue,
            size: 22,
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: textBlue,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: mutedBlue,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // RECENT ACTIVITY
  // =========================

  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE3EDF6),
          ),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textBlue,
              ),
            ),
            const SizedBox(height: 15),
            _activityItem(
              icon: Icons.menu_book_rounded,
              title: 'Materi baru ditambahkan',
              subtitle: 'Pengenalan Teknologi Informasi',
            ),
            const Divider(
              height: 22,
              color: Color(0xFFEAF0F5),
            ),
            _activityItem(
              icon: Icons.quiz_rounded,
              title: 'Soal evaluasi diperbarui',
              subtitle: 'Pemrograman Dasar',
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: paleBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: primaryBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: textBlue,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: mutedBlue,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          color: mutedBlue,
          size: 20,
        ),
      ],
    );
  }

  // =========================
  // BOTTOM NAVIGATION
  // =========================

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
                icon: Icons.dashboard_rounded,
                label: 'Dashboard',
                active: true,
              ),
              _bottomItem(
                icon: Icons.menu_book_rounded,
                label: 'Materi',
              ),
              _bottomItem(
                icon: Icons.quiz_rounded,
                label: 'Soal',
              ),
              _bottomItem(
                icon: Icons.bar_chart_rounded,
                label: 'Hasil',
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