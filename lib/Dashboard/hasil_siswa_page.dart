import 'package:flutter/material.dart';

// ============================================================
// DATA HASIL SISWA BERSAMA
// ============================================================
//
// Data ini sementara masih disimpan selama aplikasi berjalan.
// Nanti bisa dihubungkan ke database.
//
// Halaman siswa yang menyelesaikan tantangan dapat menambahkan
// hasil ke daftar ini.
// Halaman guru akan membaca data yang sama.
//
final List<Map<String, dynamic>> daftarHasilGlobal = [];

class HasilSiswaPage extends StatefulWidget {
  final String namaKelas;
  final String kodeKelas;

  const HasilSiswaPage({
    super.key,
    required this.namaKelas,
    required this.kodeKelas,
  });

  @override
  State<HasilSiswaPage> createState() => _HasilSiswaPageState();
}

class _HasilSiswaPageState extends State<HasilSiswaPage> {
  // ============================================================
  // FILTER HASIL BERDASARKAN KELAS
  // ============================================================

  List<Map<String, dynamic>> get hasilKelas {
    return daftarHasilGlobal
        .where(
          (hasil) =>
              hasil['kodeKelas'] == widget.kodeKelas &&
              hasil['namaKelas'] == widget.namaKelas,
        )
        .toList();
  }

  // ============================================================
  // JUMLAH SISWA
  // ============================================================

  int get jumlahSiswa {
    final siswa = <String>{};

    for (final hasil in hasilKelas) {
      final nama = hasil['namaSiswa']?.toString() ?? '';

      if (nama.isNotEmpty) {
        siswa.add(nama);
      }
    }

    return siswa.length;
  }

  // ============================================================
  // RATA-RATA NILAI
  // ============================================================

  double get rataRata {
    if (hasilKelas.isEmpty) {
      return 0;
    }

    double total = 0;

    for (final hasil in hasilKelas) {
      final nilai = hasil['nilai'];

      if (nilai is num) {
        total += nilai.toDouble();
      }
    }

    return total / hasilKelas.length;
  }

  // ============================================================
  // NILAI TERTINGGI
  // ============================================================

  int get nilaiTertinggi {
    if (hasilKelas.isEmpty) {
      return 0;
    }

    int tertinggi = 0;

    for (final hasil in hasilKelas) {
      final nilai = hasil['nilai'];

      if (nilai is num && nilai.toInt() > tertinggi) {
        tertinggi = nilai.toInt();
      }
    }

    return tertinggi;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        title: const Text(
          'Hasil Siswa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18365D),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ========================================================
          // HEADER KELAS
          // ========================================================

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2166D5),
                  Color(0xFF56B4F8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 34,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Hasil Pembelajaran',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.namaKelas,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kode kelas: ${widget.kodeKelas}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ========================================================
          // RINGKASAN HASIL
          // ========================================================

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.people_alt_rounded,
                  title: 'Siswa',
                  value: jumlahSiswa.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.star_rounded,
                  title: 'Rata-rata',
                  value: rataRata.toStringAsFixed(0),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.emoji_events_rounded,
                  title: 'Tertinggi',
                  value: nilaiTertinggi.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.assignment_turned_in_rounded,
                  title: 'Pengumpulan',
                  value: hasilKelas.length.toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ========================================================
          // DAFTAR HASIL
          // ========================================================

          const Text(
            'Daftar Hasil Siswa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF18365D),
            ),
          ),

          const SizedBox(height: 12),

          if (hasilKelas.isEmpty)
            _buildEmptyState()
          else
            ...hasilKelas.map(
              (hasil) => _buildResultCard(hasil),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFDCEBFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2166D5),
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF7288A8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF18365D),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 36,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Color(0xFFDCEBFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              size: 42,
              color: Color(0xFF2166D5),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Belum Ada Hasil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF18365D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hasil siswa akan muncul di sini setelah siswa mengerjakan tantangan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF7288A8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RESULT CARD
  // ============================================================

  Widget _buildResultCard(Map<String, dynamic> hasil) {
    final int nilai = hasil['nilai'] is num
        ? (hasil['nilai'] as num).toInt()
        : 0;

    final int benar = hasil['benar'] is num
        ? (hasil['benar'] as num).toInt()
        : 0;

    final int salah = hasil['salah'] is num
        ? (hasil['salah'] as num).toInt()
        : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------------------------------------
          // NAMA SISWA + NILAI
          // --------------------------------------------------------

          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCEBFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF2166D5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasil['namaSiswa']?.toString() ?? '-',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF18365D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasil['judulTantangan']?.toString() ?? '-',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7288A8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEBFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$nilai',
                  style: const TextStyle(
                    color: Color(0xFF2166D5),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // --------------------------------------------------------
          // BENAR / SALAH
          // --------------------------------------------------------

          Row(
            children: [
              Expanded(
                child: _buildAnswerInfo(
                  icon: Icons.check_circle_rounded,
                  title: 'Benar',
                  value: benar.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAnswerInfo(
                  icon: Icons.cancel_rounded,
                  title: 'Salah',
                  value: salah.toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // --------------------------------------------------------
          // TANGGAL
          // --------------------------------------------------------

          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 17,
                color: Color(0xFF7288A8),
              ),
              const SizedBox(width: 6),
              Text(
                hasil['tanggal']?.toString() ?? 'Belum ada tanggal',
                style: const TextStyle(
                  color: Color(0xFF7288A8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO BENAR / SALAH
  // ============================================================

  Widget _buildAnswerInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF2166D5),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF7288A8),
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF18365D),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}