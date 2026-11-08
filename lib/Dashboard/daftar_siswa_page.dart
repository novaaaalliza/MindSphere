
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Mengambil data siswa dari Firestore berdasarkan kode kelas.
  Stream<QuerySnapshot<Map<String, dynamic>>> _streamSiswa() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('kodeKelas', isEqualTo: widget.kodeKelas)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _streamSiswa(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorState();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: royalBlue,
              ),
            );
          }

          final semuaDokumen = snapshot.data?.docs ?? [];

          // Hanya mengambil akun siswa yang sesuai dengan kelas ini.
          final daftarSiswa = semuaDokumen.where((doc) {
            final data = doc.data();

            final role = (data['role'] ?? '')
                .toString()
                .toLowerCase();

            final namaKelas = (data['namaKelas'] ?? '')
                .toString();

            return role == 'siswa' &&
                (namaKelas.isEmpty ||
                    namaKelas == widget.namaKelas);
          }).toList();

          // Mengurutkan nama siswa.
          daftarSiswa.sort((a, b) {
            final namaA = (a.data()['nama'] ??
                    a.data()['namaSiswa'] ??
                    a.data()['name'] ??
                    '')
                .toString()
                .toLowerCase();

            final namaB = (b.data()['nama'] ??
                    b.data()['namaSiswa'] ??
                    b.data()['name'] ??
                    '')
                .toString()
                .toLowerCase();

            return namaA.compareTo(namaB);
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
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

                if (daftarSiswa.isEmpty)
                  _buildEmptyState()
                else
                  ListView.builder(
                    itemCount: daftarSiswa.length,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = daftarSiswa[index].data();

                      final nama = (data['nama'] ??
                              data['namaSiswa'] ??
                              data['name'] ??
                              'Nama Siswa')
                          .toString();

                      final email =
                          (data['email'] ?? '-').toString();

                      return _buildStudentCard(
                        nama: nama,
                        email: email,
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // HEADER KELAS
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [royalBlue, skyBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: royalBlue.withValues(alpha: 0.18),
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
              color: Colors.white.withValues(alpha: 0.18),
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
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
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

  // STUDENT CARD
  Widget _buildStudentCard({
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

  // ERROR STATE
  Widget _buildErrorState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 45,
              color: Colors.redAccent,
            ),
            SizedBox(height: 12),
            Text(
              'Gagal mengambil data siswa.',
              style: TextStyle(
                color: textBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Periksa koneksi Firebase dan aturan Firestore.',
              textAlign: TextAlign.center,
              style: TextStyle(color: mutedBlue),
            ),
          ],
        ),
      ),
    );
  }
}
