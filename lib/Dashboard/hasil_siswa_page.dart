
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================================
// HASIL SISWA - FIRESTORE
// ============================================================

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
  static const Color royalBlue = Color(0xFF2166D5);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);
  static const Color paleBlue = Color(0xFFDCEBFF);

  // ============================================================
  // STREAM HASIL DARI FIRESTORE
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> _streamHasil() {
    return FirebaseFirestore.instance
        .collection('hasil_tantangan')
        .where('kodeKelas', isEqualTo: widget.kodeKelas)
        .snapshots();
  }

  // ============================================================
  // MEMPROSES DAN MENGURUTKAN HASIL
  // ============================================================

  List<Map<String, dynamic>> _prosesHasil(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final hasil = snapshot.docs
        .map((doc) {
          return <String, dynamic>{
            ...doc.data(),
            'id': doc.id,
          };
        })
        .where((data) {
          return data['kodeKelas']?.toString() == widget.kodeKelas &&
              data['namaKelas']?.toString() == widget.namaKelas;
        })
        .toList();

    hasil.sort((a, b) {
      final waktuA = a['createdAt'];
      final waktuB = b['createdAt'];

      DateTime? tanggalA;
      DateTime? tanggalB;

      if (waktuA is Timestamp) {
        tanggalA = waktuA.toDate();
      } else if (waktuA is DateTime) {
        tanggalA = waktuA;
      }

      if (waktuB is Timestamp) {
        tanggalB = waktuB.toDate();
      } else if (waktuB is DateTime) {
        tanggalB = waktuB;
      }

      if (tanggalA == null && tanggalB == null) return 0;
      if (tanggalA == null) return 1;
      if (tanggalB == null) return -1;

      return tanggalB.compareTo(tanggalA);
    });

    return hasil;
  }

  // ============================================================
  // JUMLAH SISWA
  // ============================================================

  int _jumlahSiswa(List<Map<String, dynamic>> hasil) {
    final siswa = <String>{};

    for (final data in hasil) {
      final uid = data['uid']?.toString() ?? '';
      final nama = data['namaSiswa']?.toString() ?? '';

      if (uid.isNotEmpty) {
        siswa.add(uid);
      } else if (nama.isNotEmpty) {
        siswa.add(nama);
      }
    }

    return siswa.length;
  }

  // ============================================================
  // RATA-RATA NILAI
  // ============================================================

  double _rataRata(List<Map<String, dynamic>> hasil) {
    final dataValid = hasil
        .where((data) => data['nilai'] is num)
        .toList();

    if (dataValid.isEmpty) return 0;

    double total = 0;

    for (final data in dataValid) {
      total += (data['nilai'] as num).toDouble();
    }

    return total / dataValid.length;
  }

  // ============================================================
  // NILAI TERTINGGI
  // ============================================================

  int _nilaiTertinggi(List<Map<String, dynamic>> hasil) {
    if (hasil.isEmpty) return 0;

    int tertinggi = 0;

    for (final data in hasil) {
      final nilai = data['nilai'];

      if (nilai is num && nilai.toInt() > tertinggi) {
        tertinggi = nilai.toInt();
      }
    }

    return tertinggi;
  }

  // ============================================================
  // FORMAT TANGGAL
  // ============================================================

  String _formatTanggal(dynamic tanggal) {
    DateTime? waktu;

    if (tanggal is Timestamp) {
      waktu = tanggal.toDate();
    } else if (tanggal is DateTime) {
      waktu = tanggal;
    } else if (tanggal is String) {
      waktu = DateTime.tryParse(tanggal);
    }

    if (waktu == null) {
      return 'Tanggal tidak tersedia';
    }

    final hari = waktu.day.toString().padLeft(2, '0');
    final bulan = waktu.month.toString().padLeft(2, '0');
    final tahun = waktu.year;

    final jam = waktu.hour.toString().padLeft(2, '0');
    final menit = waktu.minute.toString().padLeft(2, '0');

    return '$hari/$bulan/$tahun • $jam:$menit';
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: textBlue,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _streamHasil(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: royalBlue,
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return _buildEmptyState();
          }

          final hasilKelas = _prosesHasil(snapshot.data!);

          return _buildContent(hasilKelas);
        },
      ),
    );
  }

  // ============================================================
  // KONTEN UTAMA
  // ============================================================

  Widget _buildContent(List<Map<String, dynamic>> hasilKelas) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [royalBlue, skyBlue],
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

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.people_alt_rounded,
                title: 'Siswa',
                value: _jumlahSiswa(hasilKelas).toString(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.star_rounded,
                title: 'Rata-rata',
                value: _rataRata(hasilKelas).toStringAsFixed(0),
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
                value: _nilaiTertinggi(hasilKelas).toString(),
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

        const Text(
          'Daftar Hasil Siswa',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textBlue,
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
              color: paleBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: royalBlue,
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
                    color: mutedBlue,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: textBlue,
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
              color: paleBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              size: 42,
              color: royalBlue,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Belum Ada Hasil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textBlue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hasil siswa akan muncul di sini setelah siswa mengerjakan tantangan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: mutedBlue,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 14),
            const Text(
              'Gagal Mengambil Hasil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textBlue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Periksa koneksi internet dan aturan akses Firestore.',
              textAlign: TextAlign.center,
              style: TextStyle(color: mutedBlue),
            ),
            const SizedBox(height: 10),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 11,
              ),
            ),
          ],
        ),
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

    final int totalSoal = hasil['totalSoal'] is num
        ? (hasil['totalSoal'] as num).toInt()
        : benar + salah;

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
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: paleBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: royalBlue,
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
                        color: textBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasil['judulTantangan']?.toString() ?? '-',
                      style: const TextStyle(
                        fontSize: 13,
                        color: mutedBlue,
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
                  color: paleBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$nilai',
                  style: const TextStyle(
                    color: royalBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

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

          const SizedBox(height: 10),

          _buildAnswerInfo(
            icon: Icons.assignment_rounded,
            title: 'Total Soal',
            value: totalSoal.toString(),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 17,
                color: mutedBlue,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _formatTanggal(
                    hasil['createdAt'] ?? hasil['tanggal'],
                  ),
                  style: const TextStyle(
                    color: mutedBlue,
                    fontSize: 12,
                  ),
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
            color: royalBlue,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: mutedBlue,
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: textBlue,
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
