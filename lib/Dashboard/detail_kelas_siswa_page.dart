import 'package:flutter/material.dart';

class DetailKelasSiswaPage extends StatelessWidget {
  final String namaKelas;
  final String kodeKelas;

  const DetailKelasSiswaPage({
    super.key,
    required this.namaKelas,
    required this.kodeKelas,
  });

  final Color royalBlue = const Color(0xFF2166D5);
  final Color deepBlue = const Color(0xFF123B70);
  final Color skyBlue = const Color(0xFF56B4F8);
  final Color paleBlue = const Color(0xFFDCEBFF);
  final Color textBlue = const Color(0xFF18365D);
  final Color mutedBlue = const Color(0xFF7288A8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: deepBlue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Kelas Saya',
          style: TextStyle(
            color: deepBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClassHeader(),
            const SizedBox(height: 24),

            Text(
              'Perjalanan Belajar',
              style: TextStyle(
                color: textBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Ikuti pembelajaran secara bertahap.',
              style: TextStyle(
                color: mutedBlue,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 15),

            _buildMenuCard(
              icon: Icons.menu_book_rounded,
              iconColor: royalBlue,
              title: 'Materi',
              subtitle: 'Pelajari materi dari guru',
              onTap: () {
                _showMessage(
                  context,
                  'Materi akan tersedia setelah guru menambahkan materi.',
                );
              },
            ),

            const SizedBox(height: 12),

            _buildMenuCard(
              icon: Icons.explore_rounded,
              iconColor: skyBlue,
              title: 'Eksplorasi',
              subtitle: 'Jelajahi pembelajaran lebih lanjut',
              onTap: () {
                _showMessage(
                  context,
                  'Fitur eksplorasi akan tersedia setelah materi ditambahkan.',
                );
              },
            ),

            const SizedBox(height: 12),

            _buildMenuCard(
              icon: Icons.flag_rounded,
              iconColor: const Color(0xFFE0A500),
              title: 'Tantangan',
              subtitle: 'Kerjakan tantangan dari guru',
              onTap: () {
                _showMessage(
                  context,
                  'Belum ada tantangan yang tersedia.',
                );
              },
            ),

            const SizedBox(height: 24),

            Text(
              'Progress Kelas',
              style: TextStyle(
                color: textBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            _buildProgressCard(),
          ],
        ),
      ),
    );
  }

  // =========================
  // HEADER KELAS
  // =========================

  Widget _buildClassHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            deepBlue,
            royalBlue,
            skyBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.class_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Text(
                  namaKelas,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15),
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
                  kodeKelas,
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
        ],
      ),
    );
  }

  // =========================
  // MENU KELAS
  // =========================

  Widget _buildMenuCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: paleBlue,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: paleBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 25,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: mutedBlue,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: mutedBlue,
              size: 16,
            ),
          ],
        ),
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
        color: Colors.white,
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              valueColor: AlwaysStoppedAnimation<Color>(
                royalBlue,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              _progressItem(
                Icons.menu_book_rounded,
                'Materi',
                '0',
              ),

              const SizedBox(width: 35),

              _progressItem(
                Icons.flag_rounded,
                'Tantangan',
                '0',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: royalBlue,
          size: 20,
        ),

        const SizedBox(width: 7),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: textBlue,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              title,
              style: TextStyle(
                color: mutedBlue,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}