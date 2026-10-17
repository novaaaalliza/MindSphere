import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data_global.dart';
import 'kelola_materi_page.dart';
import 'kelola_tantangan_page.dart';
import 'daftar_siswa_page.dart';
import 'hasil_siswa_page.dart';

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
  State<DetailKelasGuruPage> createState() =>
      _DetailKelasGuruPageState();
}

class _DetailKelasGuruPageState
    extends State<DetailKelasGuruPage> {
  static const Color royalBlue = Color(0xFF2166D5);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  // ============================================================
  // DATA KELAS
  // ============================================================

  int get jumlahSiswaKelas {
    return daftarSiswaGlobal
        .where(
          (siswa) =>
              siswa['kodeKelas'] == widget.kodeKelas &&
              siswa['namaKelas'] == widget.namaKelas,
        )
        .length;
  }

  int get jumlahMateriKelas {
    return ambilMateriKelas(
      widget.kodeKelas,
      widget.namaKelas,
    ).length;
  }

  int get jumlahTantanganKelas {
    return ambilTantanganKelas(
      widget.kodeKelas,
      widget.namaKelas,
    ).length;
  }

  int get jumlahHasilKelas {
    return hasilSiswaDiKelas(
      widget.kodeKelas,
    ).length;
  }

  // ============================================================
  // BUILD
  // ============================================================

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
          'Detail Kelas',
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
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    widget.namaKelas,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    'Kode Kelas: ${widget.kodeKelas}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ====================================================
            // RINGKASAN KELAS
            // ====================================================

            const Text(
              'Ringkasan Kelas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textBlue,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: buildInfoCard(
                    icon: Icons.people_alt_rounded,
                    title: 'Siswa',
                    value: jumlahSiswaKelas.toString(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: buildInfoCard(
                    icon: Icons.menu_book_rounded,
                    title: 'Materi',
                    value: jumlahMateriKelas.toString(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: buildInfoCard(
                    icon: Icons.quiz_rounded,
                    title: 'Tantangan',
                    value: jumlahTantanganKelas.toString(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: buildInfoCard(
                    icon: Icons.bar_chart_rounded,
                    title: 'Hasil',
                    value: jumlahHasilKelas.toString(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            // ====================================================
            // KELOLA KELAS
            // ====================================================

            const Text(
              'Kelola Kelas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textBlue,
              ),
            ),

            const SizedBox(height: 12),

            // ====================================================
            // DAFTAR SISWA
            // ====================================================

            buildMenuItem(
              icon: Icons.people_alt_rounded,
              title: 'Daftar Siswa',
              subtitle: 'Lihat siswa yang bergabung di kelas',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DaftarSiswaPage(
                      namaKelas: widget.namaKelas,
                      kodeKelas: widget.kodeKelas,
                    ),
                  ),
                );

                setState(() {});
              },
            ),

            // ====================================================
            // MATERI KELAS
            // ====================================================

            buildMenuItem(
              icon: Icons.menu_book_rounded,
              title: 'Materi Kelas',
              subtitle: 'Kelola materi pembelajaran kelas',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KelolaMateriPage(
                      namaKelas: widget.namaKelas,
                      kodeKelas: widget.kodeKelas,
                    ),
                  ),
                );

                setState(() {});
              },
            ),

            // ====================================================
            // TANTANGAN KELAS
            // ====================================================

            buildMenuItem(
              icon: Icons.quiz_rounded,
              title: 'Tantangan Kelas',
              subtitle: 'Kelola soal tantangan untuk siswa',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KelolaTantanganPage(
                      namaKelas: widget.namaKelas,
                      kodeKelas: widget.kodeKelas,
                    ),
                  ),
                );

                setState(() {});
              },
            ),

            // ====================================================
            // HASIL SISWA
            // ====================================================

            buildMenuItem(
              icon: Icons.bar_chart_rounded,
              title: 'Hasil Siswa',
              subtitle: 'Lihat perkembangan dan hasil siswa',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HasilSiswaPage(
                      namaKelas: widget.namaKelas,
                      kodeKelas: widget.kodeKelas,
                    ),
                  ),
                );

                setState(() {});
              },
            ),

            const SizedBox(height: 20),

            // ====================================================
            // KODE KELAS
            // ====================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE1E9F5),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.key_rounded,
                    color: royalBlue,
                    size: 30,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Kode Kelas',
                    style: TextStyle(
                      fontSize: 13,
                      color: mutedBlue,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.kodeKelas,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: textBlue,
                    ),
                  ),

                  const SizedBox(height: 14),

                  OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: widget.kodeKelas,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Kode kelas berhasil disalin.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.copy_rounded,
                      size: 18,
                    ),
                    label: const Text('Salin Kode'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: royalBlue,
                      side: const BorderSide(
                        color: royalBlue,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E9F5),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
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

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: textBlue,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: mutedBlue,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E9F5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: paleBlue,
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: royalBlue,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textBlue,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: mutedBlue,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: mutedBlue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}