
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  StreamSubscription? _siswaSubscription;
  StreamSubscription? _materiSubscription;
  StreamSubscription? _tantanganSubscription;
  StreamSubscription? _hasilSubscription;

  int jumlahSiswaFirebase = 0;
  int jumlahMateriFirebase = 0;
  int jumlahTantanganFirebase = 0;
  int jumlahHasilFirebase = 0;

  bool sedangMemuatSiswa = true;
  bool sedangMemuatMateri = true;
  bool sedangMemuatTantangan = true;
  bool sedangMemuatHasil = true;

  String? errorSiswa;
  String? errorMateri;
  String? errorTantangan;
  String? errorHasil;

  @override
  void initState() {
    super.initState();

    _dengarkanSiswa();
    _dengarkanMateri();
    _dengarkanTantangan();
    _dengarkanHasil();
  }

  @override
  void dispose() {
    _siswaSubscription?.cancel();
    _materiSubscription?.cancel();
    _tantanganSubscription?.cancel();
    _hasilSubscription?.cancel();
    super.dispose();
  }

  // ============================================================
  // MENGAMBIL JUMLAH SISWA DARI FIRESTORE
  // ============================================================

  void _dengarkanSiswa() {
    _siswaSubscription = FirebaseFirestore.instance
        .collectionGroup('anggota')
        .where(
          'kodeKelas',
          isEqualTo: widget.kodeKelas,
        )
        .snapshots()
        .listen(
      (snapshot) {
        final jumlah = snapshot.docs.where((doc) {
          return doc.data()['namaKelas'] ==
              widget.namaKelas;
        }).length;

        if (!mounted) return;

        setState(() {
          jumlahSiswaFirebase = jumlah;
          sedangMemuatSiswa = false;
          errorSiswa = null;
        });
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          sedangMemuatSiswa = false;
          errorSiswa = error.toString();
        });

        debugPrint('Gagal mengambil siswa: $error');
      },
    );
  }

  // ============================================================
  // MENGAMBIL JUMLAH MATERI DARI FIRESTORE
  // ============================================================

  void _dengarkanMateri() {
    _materiSubscription = FirebaseFirestore.instance
        .collection('materi')
        .where(
          'kodeKelas',
          isEqualTo: widget.kodeKelas,
        )
        .snapshots()
        .listen(
      (snapshot) {
        final jumlah = snapshot.docs.where((doc) {
          return doc.data()['namaKelas'] ==
              widget.namaKelas;
        }).length;

        if (!mounted) return;

        setState(() {
          jumlahMateriFirebase = jumlah;
          sedangMemuatMateri = false;
          errorMateri = null;
        });
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          sedangMemuatMateri = false;
          errorMateri = error.toString();
        });

        debugPrint('Gagal mengambil materi: $error');
      },
    );
  }

  // ============================================================
  // MENGAMBIL JUMLAH TANTANGAN DARI FIRESTORE
  // ============================================================

  void _dengarkanTantangan() {
    _tantanganSubscription = FirebaseFirestore.instance
        .collection('tantangan')
        .where(
          'kodeKelas',
          isEqualTo: widget.kodeKelas,
        )
        .snapshots()
        .listen(
      (snapshot) {
        final jumlah = snapshot.docs.where((doc) {
          return doc.data()['namaKelas'] ==
              widget.namaKelas;
        }).length;

        if (!mounted) return;

        setState(() {
          jumlahTantanganFirebase = jumlah;
          sedangMemuatTantangan = false;
          errorTantangan = null;
        });
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          sedangMemuatTantangan = false;
          errorTantangan = error.toString();
        });

        debugPrint('Gagal mengambil tantangan: $error');
      },
    );
  }

  // ============================================================
  // MENGAMBIL JUMLAH HASIL SISWA DARI FIRESTORE
  // ============================================================

  void _dengarkanHasil() {
    _hasilSubscription = FirebaseFirestore.instance
        .collection('hasil_tantangan')
        .where(
          'kodeKelas',
          isEqualTo: widget.kodeKelas,
        )
        .snapshots()
        .listen(
      (snapshot) {
        final jumlah = snapshot.docs.where((doc) {
          return doc.data()['namaKelas'] ==
              widget.namaKelas;
        }).length;

        if (!mounted) return;

        setState(() {
          jumlahHasilFirebase = jumlah;
          sedangMemuatHasil = false;
          errorHasil = null;
        });
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          sedangMemuatHasil = false;
          errorHasil = error.toString();
        });

        debugPrint('Gagal mengambil hasil: $error');
      },
    );
  }

  // ============================================================
  // MEMBUKA HALAMAN LAIN
  // ============================================================

  Future<void> _bukaHalaman(Widget halaman) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => halaman,
      ),
    );
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
                    value: sedangMemuatSiswa
                        ? '...'
                        : errorSiswa != null
                            ? '!'
                            : jumlahSiswaFirebase.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildInfoCard(
                    icon: Icons.menu_book_rounded,
                    title: 'Materi',
                    value: sedangMemuatMateri
                        ? '...'
                        : errorMateri != null
                            ? '!'
                            : jumlahMateriFirebase.toString(),
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
                    value: sedangMemuatTantangan
                        ? '...'
                        : errorTantangan != null
                            ? '!'
                            : jumlahTantanganFirebase.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildInfoCard(
                    icon: Icons.bar_chart_rounded,
                    title: 'Hasil',
                    value: sedangMemuatHasil
                        ? '...'
                        : errorHasil != null
                            ? '!'
                            : jumlahHasilFirebase.toString(),
                  ),
                ),
              ],
            ),

            if (errorSiswa != null ||
                errorMateri != null ||
                errorTantangan != null ||
                errorHasil != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5E5),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Text(
                  'Sebagian data belum dapat dimuat. Periksa koneksi Firebase, Firestore Rules, dan struktur data.',
                  style: TextStyle(
                    color: Color(0xFF936018),
                    fontSize: 12,
                  ),
                ),
              ),
            ],

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

            // DAFTAR SISWA

            buildMenuItem(
              icon: Icons.people_alt_rounded,
              title: 'Daftar Siswa',
              subtitle: 'Lihat siswa yang bergabung di kelas',
              onTap: () {
                _bukaHalaman(
                  DaftarSiswaPage(
                    namaKelas: widget.namaKelas,
                    kodeKelas: widget.kodeKelas,
                  ),
                );
              },
            ),

            // MATERI KELAS

            buildMenuItem(
              icon: Icons.menu_book_rounded,
              title: 'Materi Kelas',
              subtitle: 'Kelola materi pembelajaran kelas',
              onTap: () {
                _bukaHalaman(
                  KelolaMateriPage(
                    namaKelas: widget.namaKelas,
                    kodeKelas: widget.kodeKelas,
                  ),
                );
              },
            ),

            // TANTANGAN KELAS

            buildMenuItem(
              icon: Icons.quiz_rounded,
              title: 'Tantangan Kelas',
              subtitle: 'Kelola soal tantangan untuk siswa',
              onTap: () {
                _bukaHalaman(
                  KelolaTantanganPage(
                    namaKelas: widget.namaKelas,
                    kodeKelas: widget.kodeKelas,
                  ),
                );
              },
            ),

            // HASIL SISWA

            buildMenuItem(
              icon: Icons.bar_chart_rounded,
              title: 'Hasil Siswa',
              subtitle: 'Lihat perkembangan dan hasil siswa',
              onTap: () {
                _bukaHalaman(
                  HasilSiswaPage(
                    namaKelas: widget.namaKelas,
                    kodeKelas: widget.kodeKelas,
                  ),
                );
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
                        borderRadius: BorderRadius.circular(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    borderRadius: BorderRadius.circular(14),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
