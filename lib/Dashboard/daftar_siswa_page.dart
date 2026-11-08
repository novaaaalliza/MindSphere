
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaftarSiswaPage extends StatelessWidget {
  final String namaKelas;
  final String kodeKelas;

  const DaftarSiswaPage({
    super.key,
    required this.namaKelas,
    required this.kodeKelas,
  });

  static const Color royalBlue = Color(0xFF2166D5);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

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
        stream: FirebaseFirestore.instance
            .collection('kelas')
            .where('kode', isEqualTo: kodeKelas)
            .limit(1)
            .snapshots(),
        builder: (context, kelasSnapshot) {
          if (kelasSnapshot.hasError) {
            return _pesanError();
          }

          if (kelasSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: royalBlue,
              ),
            );
          }

          if (kelasSnapshot.data == null ||
              kelasSnapshot.data!.docs.isEmpty) {
            return _pesanKosong();
          }

          final kelasDoc = kelasSnapshot.data!.docs.first;

          return StreamBuilder<
              QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('kelas')
                .doc(kelasDoc.id)
                .collection('anggota')
                .snapshots(),
            builder: (context, anggotaSnapshot) {
              if (anggotaSnapshot.hasError) {
                return _pesanError();
              }

              if (anggotaSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: royalBlue,
                  ),
                );
              }

              final siswa = anggotaSnapshot.data?.docs ?? [];

              siswa.sort((a, b) {
                final namaA =
                    (a.data()['namaSiswa'] ?? '')
                        .toString()
                        .toLowerCase();

                final namaB =
                    (b.data()['namaSiswa'] ?? '')
                        .toString()
                        .toLowerCase();

                return namaA.compareTo(namaB);
              });

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerKelas(),
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
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${siswa.length} Siswa',
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

                    if (siswa.isEmpty)
                      _pesanKosong()
                    else
                      ListView.builder(
                        itemCount: siswa.length,
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = siswa[index].data();

                          return _kartuSiswa(
                            nama: (data['namaSiswa'] ??
                                    'Nama Siswa')
                                .toString(),
                            uid: (data['uidSiswa'] ?? '')
                                .toString(),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _headerKelas() {
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
                  namaKelas,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Kode: $kodeKelas',
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

  Widget _kartuSiswa({
    required String nama,
    required String uid,
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
                const Text(
                  'Siswa',
                  style: TextStyle(
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

  Widget _pesanKosong() {
    return Center(
      child: Container(
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
        child: const Column(
          children: [
            Icon(
              Icons.people_outline_rounded,
              color: royalBlue,
              size: 55,
            ),
            SizedBox(height: 15),
            Text(
              'Belum Ada Siswa',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textBlue,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Belum ada siswa yang bergabung dengan kelas ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: mutedBlue,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pesanError() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Gagal mengambil data siswa. Periksa koneksi dan aturan Firestore.',
          textAlign: TextAlign.center,
          style: TextStyle(color: mutedBlue),
        ),
      ),
    );
  }
}
