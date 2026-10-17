import 'package:flutter/material.dart';

import 'detail_kelas_siswa_page.dart';

class HasilTantanganPage extends StatelessWidget {
  final String namaKelas;
  final String kodeKelas;
  final String judulTantangan;
  final int nilai;
  final int benar;
  final int salah;
  final int totalSoal;

  const HasilTantanganPage({
    super.key,
    required this.namaKelas,
    required this.kodeKelas,
    required this.judulTantangan,
    required this.nilai,
    required this.benar,
    required this.salah,
    required this.totalSoal,
  });

  @override
  Widget build(BuildContext context) {
    final double persentase =
        totalSoal == 0 ? 0.0 : benar / totalSoal;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text('Hasil Tantangan'),
        backgroundColor: const Color(0xFF2166D5),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildNilaiCard(),
              const SizedBox(height: 18),
              _buildStatistikCard(),
              const SizedBox(height: 18),
              _buildPesan(persentase),
              const SizedBox(height: 28),
              _buildTombol(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: const BoxDecoration(
            color: Color(0xFFDCEBFF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.emoji_events_rounded,
            size: 44,
            color: Color(0xFF2166D5),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tantangan Selesai!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Color(0xFF18365D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          judulTantangan,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF7288A8),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '$namaKelas • $kodeKelas',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF7288A8),
          ),
        ),
      ],
    );
  }

  Widget _buildNilaiCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 26,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2166D5),
            Color(0xFF56B4F8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0x332166D5),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Nilai Kamu',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$nilai',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'dari 100',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistikCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2EAF5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Jawaban',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF18365D),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.check_circle_rounded,
                  label: 'Benar',
                  value: '$benar',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.cancel_rounded,
                  label: 'Salah',
                  value: '$salah',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.quiz_rounded,
                  label: 'Total',
                  value: '$totalSoal',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF2166D5),
            size: 27,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF18365D),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7288A8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPesan(double persentase) {
    String judul;
    String pesan;

    if (nilai >= 90) {
      judul = 'Hebat sekali! 🎉';
      pesan =
          'Pemahaman kamu terhadap materi sangat baik. Pertahankan hasil belajar kamu!';
    } else if (nilai >= 75) {
      judul = 'Bagus! 👍';
      pesan =
          'Kamu sudah memahami sebagian besar materi. Terus tingkatkan hasil belajarmu!';
    } else if (nilai >= 60) {
      judul = 'Lumayan!';
      pesan =
          'Kamu sudah mencoba dengan baik. Coba pelajari kembali materi dan tantangan yang tersedia.';
    } else {
      judul = 'Tetap semangat! 💪';
      pesan =
          'Jangan menyerah. Pelajari kembali materi dan coba tingkatkan pemahamanmu.';
    }

    final String persenText =
        '${(persentase * 100).round()}%';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFDCEBFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            judul,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF18365D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pesan,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF526B8A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Persentase benar: $persenText',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2166D5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTombol(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => DetailKelasSiswaPage(
                namaKelas: namaKelas,
                kodeKelas: kodeKelas,
              ),
            ),
            (route) => false,
          );
        },
        icon: const Icon(Icons.home_rounded),
        label: const Text(
          'Kembali ke Kelas',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2166D5),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}