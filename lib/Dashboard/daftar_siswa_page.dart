import 'package:flutter/material.dart';
import 'data_global.dart';

class DaftarSiswaPage extends StatefulWidget {
  final String namaKelas;
  final String kodeKelas;

  const DaftarSiswaPage({
    super.key,
    required this.namaKelas,
    required this.kodeKelas,
  });

  @override
  State<DaftarSiswaPage> createState() => _DaftarSiswaPageState();
}

class _DaftarSiswaPageState extends State<DaftarSiswaPage> {
  static const Color royalBlue = Color(0xFF2166D5);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  // ============================================================
  // MENGAMBIL DATA SISWA SESUAI KELAS
  // ============================================================

  List<Map<String, String>> get daftarSiswa {
    return daftarSiswaGlobal
        .where(
          (siswa) =>
              siswa['kodeKelas'] == widget.kodeKelas &&
              siswa['namaKelas'] == widget.namaKelas,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),

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
          'Daftar Siswa',
          style: TextStyle(
            color: textBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====================================================
            // HEADER KELAS
            // ====================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    royalBlue,
                    skyBlue,
                  ],
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
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.people_alt_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.namaKelas,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Kode: ${widget.kodeKelas}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ====================================================
            // JUDUL DAN JUMLAH SISWA
            // ====================================================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Siswa yang Bergabung',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textBlue,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: paleBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${daftarSiswa.length} Siswa',
                    style: const TextStyle(
                      color: royalBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ====================================================
            // DAFTAR SISWA
            // ====================================================

            if (daftarSiswa.isEmpty)
              buildEmptyState()
            else
              ListView.builder(
                itemCount: daftarSiswa.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final siswa = daftarSiswa[index];

                  return buildStudentCard(
                    nama: siswa['namaSiswa'] ?? 'Nama Siswa',
                    email: '-',
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE1E9F5),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: paleBlue,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.people_outline_rounded,
              color: royalBlue,
              size: 36,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Belum Ada Siswa',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: textBlue,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Belum ada siswa yang bergabung\ndengan kelas ini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: mutedBlue,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: royalBlue,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Text(
                  'Kode kelas: ${widget.kodeKelas}',
                  style: const TextStyle(
                    color: textBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
  // STUDENT CARD
  // ============================================================

  Widget buildStudentCard({
    required String nama,
    required String email,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E9F5),
        ),
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
            child: const Icon(
              Icons.person_rounded,
              color: royalBlue,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    color: textBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  email,
                  style: const TextStyle(
                    color: mutedBlue,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}