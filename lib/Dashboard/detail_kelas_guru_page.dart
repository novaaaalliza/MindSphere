import 'package:flutter/material.dart';

class DetailKelasGuruPage extends StatefulWidget {
  final String namaKelas;
  final String kodeKelas;
  final int jumlahSiswa;

  const DetailKelasGuruPage({
    super.key,
    required this.namaKelas,
    required this.kodeKelas,
    required this.jumlahSiswa,
  });

  @override
  State<DetailKelasGuruPage> createState() => _DetailKelasGuruPageState();
}

class _DetailKelasGuruPageState extends State<DetailKelasGuruPage> {
  static const Color royalBlue = Color(0xFF2166D5);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  int selectedMenu = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: textBlue,
          ),
        ),
        title: const Text(
          'Detail Kelas',
          style: TextStyle(
            color: textBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildClassHeader(),
              const SizedBox(height: 24),
              buildMenu(),
              const SizedBox(height: 22),
              buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // HEADER KELAS
  // =========================

  Widget buildClassHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            royalBlue,
            skyBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: royalBlue.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.namaKelas,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.key_rounded,
                color: Colors.white70,
                size: 18,
              ),
              const SizedBox(width: 7),
              const Text(
                'Kode Kelas:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                widget.kodeKelas,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              buildHeaderStat(
                Icons.people_alt_rounded,
                '${widget.jumlahSiswa}',
                'Siswa',
              ),
              const SizedBox(width: 25),
              buildHeaderStat(
                Icons.menu_book_rounded,
                '0',
                'Materi',
              ),
              const SizedBox(width: 25),
              buildHeaderStat(
                Icons.quiz_rounded,
                '0',
                'Tantangan',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeaderStat(
    IconData icon,
    String value,
    String label,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 19,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // MENU
  // =========================

  Widget buildMenu() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildMenuItem(
            icon: Icons.dashboard_rounded,
            label: 'Ringkasan',
            index: 0,
          ),
          buildMenuItem(
            icon: Icons.menu_book_rounded,
            label: 'Materi',
            index: 1,
          ),
          buildMenuItem(
            icon: Icons.quiz_rounded,
            label: 'Tantangan',
            index: 2,
          ),
          buildMenuItem(
            icon: Icons.people_alt_rounded,
            label: 'Siswa',
            index: 3,
          ),
          buildMenuItem(
            icon: Icons.bar_chart_rounded,
            label: 'Hasil',
            index: 4,
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool active = selectedMenu == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenu = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 9),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: active ? royalBlue : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active
                ? royalBlue
                : const Color(0xFFE1E8F2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: active ? Colors.white : mutedBlue,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : textBlue,
                fontSize: 12,
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // CONTENT
  // =========================

  Widget buildContent() {
    switch (selectedMenu) {
      case 1:
        return buildMateri();
      case 2:
        return buildTantangan();
      case 3:
        return buildSiswa();
      case 4:
        return buildHasil();
      default:
        return buildRingkasan();
    }
  }

  // =========================
  // RINGKASAN
  // =========================

  Widget buildRingkasan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Kelas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textBlue,
          ),
        ),
        const SizedBox(height: 12),
        buildInfoCard(
          icon: Icons.school_rounded,
          title: 'Mulai Kelola Pembelajaran',
          description:
              'Tambahkan materi dan tantangan untuk mulai membangun perjalanan belajar siswa di kelas ini.',
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: buildSmallCard(
                Icons.menu_book_rounded,
                'Materi',
                '0',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildSmallCard(
                Icons.quiz_rounded,
                'Tantangan',
                '0',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildSmallCard(
                Icons.people_alt_rounded,
                'Siswa',
                '${widget.jumlahSiswa}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildSmallCard(
                Icons.bar_chart_rounded,
                'Hasil',
                '0',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // MATERI
  // =========================

  Widget buildMateri() {
    return buildEmptySection(
      icon: Icons.menu_book_rounded,
      title: 'Belum Ada Materi',
      description:
          'Tambahkan materi pembelajaran yang akan dipelajari siswa di kelas ini.',
      buttonText: 'Tambah Materi',
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Fitur tambah materi akan dibuat selanjutnya.',
            ),
          ),
        );
      },
    );
  }

  // =========================
  // TANTANGAN
  // =========================

  Widget buildTantangan() {
    return buildEmptySection(
      icon: Icons.quiz_rounded,
      title: 'Belum Ada Tantangan',
      description:
          'Buat tantangan atau kuis untuk mengukur pemahaman siswa.',
      buttonText: 'Buat Tantangan',
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Fitur tambah tantangan akan dibuat selanjutnya.',
            ),
          ),
        );
      },
    );
  }

  // =========================
  // SISWA
  // =========================

  Widget buildSiswa() {
    if (widget.jumlahSiswa == 0) {
      return buildEmptySection(
        icon: Icons.people_alt_rounded,
        title: 'Belum Ada Siswa',
        description:
            'Bagikan kode kelas kepada siswa agar mereka dapat bergabung ke kelas ini.',
        buttonText: 'Salin Kode Kelas',
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Kode kelas: ${widget.kodeKelas}',
              ),
            ),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daftar Siswa',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textBlue,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          widget.jumlahSiswa,
          (index) => buildStudentCard(
            'Siswa ${index + 1}',
          ),
        ),
      ],
    );
  }

  Widget buildStudentCard(String nama) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE2E9F3),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: paleBlue,
            child: const Icon(
              Icons.person_rounded,
              color: royalBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              nama,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: textBlue,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: mutedBlue,
          ),
        ],
      ),
    );
  }

  // =========================
  // HASIL
  // =========================

  Widget buildHasil() {
    return buildEmptySection(
      icon: Icons.bar_chart_rounded,
      title: 'Belum Ada Hasil',
      description:
          'Hasil belajar siswa akan muncul setelah siswa menyelesaikan tantangan.',
      buttonText: 'Kelola Tantangan',
      onPressed: () {
        setState(() {
          selectedMenu = 2;
        });
      },
    );
  }

  // =========================
  // KOMPONEN
  // =========================

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E9F3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: paleBlue,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: royalBlue,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textBlue,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: mutedBlue,
                    fontSize: 12,
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

  Widget buildSmallCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 17,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E9F3),
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
              color: textBlue,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: mutedBlue,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptySection({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE2E9F3),
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
            child: Icon(
              icon,
              color: royalBlue,
              size: 32,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: textBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: mutedBlue,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 17),
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(
              Icons.add_rounded,
              size: 18,
            ),
            label: Text(buttonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: royalBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
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
}