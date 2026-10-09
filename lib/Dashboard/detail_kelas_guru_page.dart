import 'package:flutter/material.dart';
import '../data/materi_data.dart';

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
      backgroundColor: const Color(0xFFF6F9FE),
      appBar: AppBar(
        backgroundColor: royalBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Kelas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // HEADER KELAS
            // =========================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
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
                    color: royalBlue.withOpacity(0.20),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.namaKelas,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kode kelas: ${widget.kodeKelas}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _infoHeader(
                        Icons.people_alt_rounded,
                        '${widget.jumlahSiswa}',
                        'Siswa',
                      ),
                      const SizedBox(width: 28),
                      _infoHeader(
                        Icons.menu_book_rounded,
                        '$jumlahMateri',
                        'Materi',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // MATERI PEMBELAJARAN
            // =========================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Materi Pembelajaran',
                  style: TextStyle(
                    color: Color(0xFF18365D),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: tambahMateri,
                  icon: const Icon(
                    Icons.add,
                    size: 19,
                  ),
                  label: const Text('Tambah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            buildMateri(),

            const SizedBox(height: 25),

            // =========================
            // MENU TANTANGAN
            // =========================

            const Text(
              'Pembelajaran',
              style: TextStyle(
                color: Color(0xFF18365D),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _buildFeatureCard(
              icon: Icons.flag_rounded,
              iconColor: const Color(0xFFE0A500),
              title: 'Tantangan',
              subtitle:
                  'Buat dan kelola tantangan untuk siswa',
              onTap: () {
                _showTantangan();
              },
            ),

            const SizedBox(height: 12),

            // =========================
            // MENU HASIL
            // =========================

            _buildFeatureCard(
              icon: Icons.assessment_rounded,
              iconColor: skyBlue,
              title: 'Hasil',
              subtitle:
                  'Lihat hasil belajar dan nilai siswa',
              onTap: () {
                _showHasil();
              },
            ),

            const SizedBox(height: 25),

            // =========================
            // RINGKASAN
            // =========================

            buildRingkasan(),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // INFO HEADER
  // =========================================================

  Widget _infoHeader(
    IconData icon,
    String jumlah,
    String label,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 7),
        Text(
          jumlah,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // FEATURE CARD
  // =========================================================

  Widget _buildFeatureCard({
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: paleBlue,
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 26,
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

  // =========================================================
  // DAFTAR MATERI
  // =========================================================

  Widget buildMateri() {
    final daftarMateriKelas =
        MateriData.getMateriByKelas(widget.kodeKelas);

    if (daftarMateriKelas.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 35,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: paleBlue,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: paleBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_outlined,
                color: royalBlue,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Belum ada materi',
              style: TextStyle(
                color: textBlue,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tambahkan materi pertama untuk kelas ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedBlue,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: List.generate(
        daftarMateriKelas.length,
        (index) {
          final materi =
              daftarMateriKelas[index];

          return buildMateriCard(
            index,
            materi,
          );
        },
      ),
    );
  }

  // =========================================================
  // CARD MATERI
  // =========================================================

  Widget buildMateriCard(
    int index,
    Map<String, String> materi,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(17),
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
        border: Border.all(
          color: const Color(0xFFE4EDFA),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: paleBlue,
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: royalBlue,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      materi['judul'] ??
                          'Tanpa Judul',
                      style: TextStyle(
                        color: textBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      materi['deskripsi'] ?? '',
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color: mutedBlue,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: mutedBlue,
                ),
                onSelected: (value) {
                  if (value == 'hapus') {
                    hapusMateri(materi);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'hapus',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text('Hapus'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFF),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Text(
              materi['isi'] ?? '',
              maxLines: 3,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color: textBlue,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // RINGKASAN
  // =========================================================

  Widget buildRingkasan() {
    final jumlahMateri =
        MateriData.getMateriByKelas(widget.kodeKelas).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE4EDFA),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Kelas',
            style: TextStyle(
              color: textBlue,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  Icons.people_alt_rounded,
                  '${widget.jumlahSiswa}',
                  'Total Siswa',
                ),
              ),
              Expanded(
                child: _summaryItem(
                  Icons.menu_book_rounded,
                  '$jumlahMateri',
                  'Total Materi',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    IconData icon,
    String value,
    String label,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: paleBlue,
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: royalBlue,
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: textBlue,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: mutedBlue,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================
  // TAMBAH MATERI
  // =========================================================

  void tambahMateri() {
    final judulController =
        TextEditingController();
    final deskripsiController =
        TextEditingController();
    final isiController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          title: Text(
            'Tambah Materi',
            style: TextStyle(
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller:
                      judulController,
                  decoration:
                      InputDecoration(
                    labelText:
                        'Judul Materi',
                    prefixIcon:
                        const Icon(Icons.title),
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                TextField(
                  controller:
                      deskripsiController,
                  maxLines: 2,
                  decoration:
                      InputDecoration(
                    labelText:
                        'Deskripsi',
                    prefixIcon:
                        const Icon(
                      Icons
                          .description_outlined,
                    ),
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                TextField(
                  controller:
                      isiController,
                  maxLines: 5,
                  decoration:
                      InputDecoration(
                    labelText:
                        'Isi Materi',
                    alignLabelWithHint:
                        true,
                    prefixIcon:
                        const Icon(
                      Icons
                          .menu_book_outlined,
                    ),
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: mutedBlue,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final judul =
                    judulController.text.trim();
                final deskripsi =
                    deskripsiController.text.trim();
                final isi =
                    isiController.text.trim();

                if (judul.isEmpty ||
                    deskripsi.isEmpty ||
                    isi.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Semua data materi harus diisi.',
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  MateriData.daftarMateri
                      .add({
                    'kodeKelas':
                        widget.kodeKelas,
                    'judul': judul,
                    'deskripsi':
                        deskripsi,
                    'isi': isi,
                  });
                });

                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Materi berhasil ditambahkan.',
                    ),
                  ),
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    royalBlue,
                foregroundColor:
                    Colors.white,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
              child:
                  const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // HAPUS MATERI
  // =========================================================

  void hapusMateri(
    Map<String, String> materi,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: const Text(
            'Hapus Materi?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus materi '
            '"${materi['judul']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  MateriData.daftarMateri
                      .remove(materi);
                });

                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Materi berhasil dihapus.',
                    ),
                  ),
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
              ),
              child:
                  const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // TANTANGAN
  // =========================================================

  void _showTantangan() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: Text(
            'Tantangan',
            style: TextStyle(
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Fitur tantangan akan digunakan untuk '
            'membuat tugas atau kuis yang dikerjakan siswa.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Fitur pembuatan tantangan akan dikembangkan selanjutnya.',
                    ),
                  ),
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    royalBlue,
                foregroundColor:
                    Colors.white,
              ),
              child:
                  const Text('Buat Tantangan'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // HASIL
  // =========================================================

  void _showHasil() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: Text(
            'Hasil Belajar',
            style: TextStyle(
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Hasil belajar siswa akan ditampilkan '
            'setelah siswa mengerjakan tantangan atau kuis.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}