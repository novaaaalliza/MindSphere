import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  static const Color primaryBlue = Color(0xFF2166D5);
  static const Color lightBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFEAF6FF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  final List<Map<String, dynamic>> materials = [
    {
      'title': 'Pengenalan Teknologi Informasi',
      'subtitle': 'Materi Dasar',
      'icon': Icons.computer_rounded,
    },
    {
      'title': 'Sistem Informasi',
      'subtitle': 'Materi Pembelajaran',
      'icon': Icons.storage_rounded,
    },
    {
      'title': 'Pemrograman Dasar',
      'subtitle': 'Materi Pembelajaran',
      'icon': Icons.code_rounded,
    },
  ];

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
              const SizedBox(height: 22),
              _buildSectionTitle(
                'Menu Belajar',
                'Pilih aktivitas pembelajaranmu',
              ),
              const SizedBox(height: 12),
              _buildMenuGrid(context),
              const SizedBox(height: 24),
              _buildSectionTitle(
                'Materi Terbaru',
                'Lanjutkan pembelajaranmu',
              ),
              const SizedBox(height: 12),
              _buildMaterials(),
              const SizedBox(height: 24),
              _buildProgressCard(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // Bottom Navigation
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
              right: -18,
              top: -22,
              child: Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              right: 38,
              bottom: -45,
              child: Container(
                width: 85,
                height: 85,
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
                        'Yuk lanjut belajar hari ini!',
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
  // MENU BELAJAR
  // =========================

  Widget _buildMenuGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _menuCard(
              icon: Icons.menu_book_rounded,
              title: 'Materi',
              subtitle: 'Pelajari materi',
              color: primaryBlue,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _menuCard(
              icon: Icons.explore_rounded,
              title: 'Eksplorasi',
              subtitle: 'Jelajahi topik',
              color: lightBlue,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _menuCard(
              icon: Icons.flag_rounded,
              title: 'Tantangan',
              subtitle: 'Uji pemahaman',
              color: const Color(0xFF6A7FF2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      height: 132,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5EEF7),
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
  // MATERI
  // =========================

  Widget _buildMaterials() {
    return SizedBox(
      height: 142,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: materials.length,
        itemBuilder: (context, index) {
          final material = materials[index];

          return Container(
            width: 245,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(17),
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
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: paleBlue,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        material['icon'],
                        color: primaryBlue,
                        size: 22,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Materi',
                        style: TextStyle(
                          fontSize: 9,
                          color: primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  material['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: textBlue,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  material['subtitle'],
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: mutedBlue,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =========================
  // PROGRESS
  // =========================

  Widget _buildProgressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(19),
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
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: paleBlue,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.auto_graph_rounded,
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
                        'Progress Belajar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: textBlue,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Pantau perkembangan belajarmu',
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
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: 0.35,
                minHeight: 9,
                backgroundColor: const Color(0xFFEAF1F7),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  primaryBlue,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terus tingkatkan belajarmu!',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: mutedBlue,
                  ),
                ),
                Text(
                  '35% selesai',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: textBlue,
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