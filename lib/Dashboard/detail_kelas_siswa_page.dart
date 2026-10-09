import 'package:flutter/material.dart';
import '../data/materi_data.dart';

class DetailKelasSiswaPage extends StatefulWidget {
  final String namaKelas;
  final String kodeKelas;

  const DetailKelasSiswaPage({
    super.key,
    required this.namaKelas,
    required this.kodeKelas,
  });

  @override
  State<DetailKelasSiswaPage> createState() =>
      _DetailKelasSiswaPageState();
}

class _DetailKelasSiswaPageState
    extends State<DetailKelasSiswaPage> {
  final Color royalBlue = const Color(0xFF2166D5);
  final Color deepBlue = const Color(0xFF123B70);
  final Color skyBlue = const Color(0xFF56B4F8);
  final Color paleBlue = const Color(0xFFDCEBFF);
  final Color textBlue = const Color(0xFF18365D);
  final Color mutedBlue = const Color(0xFF7288A8);

  @override
  Widget build(BuildContext context) {
    final jumlahMateri =
        MateriData.getMateriByKelas(widget.kodeKelas).length;

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

            // =========================
            // MATERI
            // =========================

            _buildMenuCard(
              icon: Icons.menu_book_rounded,
              iconColor: royalBlue,
              title: 'Materi',
              subtitle:
                  '$jumlahMateri materi tersedia',
              onTap: () {
                _showMateriPage();
              },
            ),

            const SizedBox(height: 12),

            // =========================
            // EKSPLORASI
            // =========================

            _buildMenuCard(
              icon: Icons.explore_rounded,
              iconColor: skyBlue,
              title: 'Eksplorasi',
              subtitle:
                  'Jelajahi pembelajaran lebih lanjut',
              onTap: () {
                _showMessage(
                  'Fitur eksplorasi akan dibuat setelah materi.',
                );
              },
            ),

            const SizedBox(height: 12),

            // =========================
            // TANTANGAN
            // =========================

            _buildMenuCard(
              icon: Icons.flag_rounded,
              iconColor: const Color(0xFFE0A500),
              title: 'Tantangan',
              subtitle:
                  'Kerjakan tantangan dari guru',
              onTap: () {
                _showMessage(
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
                  widget.namaKelas,
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
                  widget.kodeKelas,
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
                crossAxisAlignment:
                    CrossAxisAlignment.start,
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
  // HALAMAN DAFTAR MATERI
  // =========================

  void _showMateriPage() {
    final daftarMateriKelas =
        MateriData.getMateriByKelas(widget.kodeKelas);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MateriSiswaPage(
          namaKelas: widget.namaKelas,
          daftarMateri: daftarMateriKelas,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
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
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
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
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0,
              minHeight: 9,
              backgroundColor:
                  const Color(0xFFE0EAF7),
              valueColor:
                  AlwaysStoppedAnimation<Color>(
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
          crossAxisAlignment:
              CrossAxisAlignment.start,
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

  // =========================
  // PESAN
  // =========================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

// =====================================================
// HALAMAN MATERI SISWA
// =====================================================

class MateriSiswaPage extends StatelessWidget {
  final String namaKelas;
  final List<Map<String, String>> daftarMateri;

  const MateriSiswaPage({
    super.key,
    required this.namaKelas,
    required this.daftarMateri,
  });

  static const Color royalBlue = Color(0xFF2166D5);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
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
          'Materi Pembelajaran',
          style: TextStyle(
            color: textBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: daftarMateri.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: daftarMateri.length,
              itemBuilder: (context, index) {
                final materi = daftarMateri[index];

                return _buildMateriCard(
                  context,
                  materi,
                  index,
                );
              },
            ),
    );
  }

  // =========================
  // EMPTY
  // =========================

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                color: paleBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: royalBlue,
                size: 38,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Belum Ada Materi',
              style: TextStyle(
                color: textBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Guru belum menambahkan materi untuk kelas ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedBlue,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // CARD MATERI
  // =========================

  Widget _buildMateriCard(
    BuildContext context,
    Map<String, String> materi,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BacaMateriPage(
                judul: materi['judul'] ?? '',
                deskripsi:
                    materi['deskripsi'] ?? '',
                isi: materi['isi'] ?? '',
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    royalBlue,
                    skyBlue,
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    materi['judul'] ?? '',
                    style: const TextStyle(
                      color: textBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    materi['deskripsi'] ?? '',
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: mutedBlue,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 9),

                  const Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 15,
                        color: royalBlue,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Baca materi',
                        style: TextStyle(
                          color: royalBlue,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: mutedBlue,
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// HALAMAN BACA MATERI
// =====================================================

class BacaMateriPage extends StatelessWidget {
  final String judul;
  final String deskripsi;
  final String isi;

  const BacaMateriPage({
    super.key,
    required this.judul,
    required this.deskripsi,
    required this.isi,
  });

  static const Color royalBlue = Color(0xFF2166D5);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
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
          'Baca Materi',
          style: TextStyle(
            color: textBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    royalBlue,
                    Color(0xFF56B4F8),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(23),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 42,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              judul,
              style: const TextStyle(
                color: textBlue,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              deskripsi,
              style: const TextStyle(
                color: mutedBlue,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
                border: Border.all(
                  color: paleBlue,
                ),
              ),
              child: Text(
                isi,
                style: const TextStyle(
                  color: textBlue,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Materi selesai dipelajari.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.check_circle_outline_rounded,
                ),
                label: const Text(
                  'Tandai Sudah Dipelajari',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: royalBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}