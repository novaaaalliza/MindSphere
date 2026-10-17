import 'package:flutter/material.dart';

import 'data_global.dart';
import 'kerjakan_tantangan_page.dart';

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

  // ============================================================
  // DATA KELAS
  // ============================================================

  List<Map<String, String>> get daftarMateriKelas {
    return ambilMateriKelas(
      widget.kodeKelas,
      widget.namaKelas,
    );
  }

  List<Map<String, dynamic>> get daftarTantanganKelas {
    return ambilTantanganKelas(
      widget.kodeKelas,
      widget.namaKelas,
    );
  }

  List<Map<String, dynamic>> get daftarHasilKelas {
    return hasilSiswaDiKelas(widget.kodeKelas)
        .where(
          (hasil) =>
              hasil['namaSiswa'] == namaSiswaAktif,
        )
        .toList();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final jumlahMateri = daftarMateriKelas.length;
    final jumlahTantangan = daftarTantanganKelas.length;

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
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),
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

            // ==================================================
            // MATERI
            // ==================================================

            _buildMenuCard(
              icon: Icons.menu_book_rounded,
              iconColor: royalBlue,
              title: 'Materi',
              subtitle: '$jumlahMateri materi tersedia',
              onTap: _showMateriPage,
            ),

            const SizedBox(height: 12),

            // ==================================================
            // EKSPLORASI
            // ==================================================

            _buildMenuCard(
              icon: Icons.explore_rounded,
              iconColor: skyBlue,
              title: 'Eksplorasi',
              subtitle: 'Jelajahi pembelajaran lebih lanjut',
              onTap: _showEksplorasiPage,
            ),

            const SizedBox(height: 12),

            // ==================================================
            // TANTANGAN
            // ==================================================

            _buildMenuCard(
              icon: Icons.flag_rounded,
              iconColor: const Color(0xFFE0A500),
              title: 'Tantangan',
              subtitle: jumlahTantangan == 0
                  ? 'Belum ada tantangan'
                  : '$jumlahTantangan tantangan tersedia',
              onTap: _showTantanganPage,
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

  // ============================================================
  // HEADER KELAS
  // ============================================================

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

  // ============================================================
  // MENU KELAS
  // ============================================================

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
                crossAxisAlignment: CrossAxisAlignment.start,
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

  // ============================================================
  // HALAMAN MATERI
  // ============================================================

  void _showMateriPage() {
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

  // ============================================================
  // HALAMAN EKSPLORASI
  // ============================================================

  void _showEksplorasiPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EksplorasiSiswaPage(
          namaKelas: widget.namaKelas,
          daftarMateri: daftarMateriKelas,
        ),
      ),
    );
  }

  // ============================================================
  // HALAMAN TANTANGAN
  // ============================================================

  void _showTantanganPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TantanganSiswaPage(
          namaKelas: widget.namaKelas,
          kodeKelas: widget.kodeKelas,
          daftarTantangan: daftarTantanganKelas,
        ),
      ),
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgressCard() {
    final int jumlahMateri = daftarMateriKelas.length;

    final int jumlahTantangan = daftarTantanganKelas.length;

    final int jumlahTantanganSelesai =
        daftarTantanganKelas.where(
      (tantangan) {
        final String judul =
            tantangan['judul']?.toString() ?? '';

        return daftarHasilKelas.any(
          (hasil) =>
              hasil['judulTantangan']?.toString() == judul,
        );
      },
    ).length;

    final double progress = jumlahTantangan == 0
        ? 0
        : jumlahTantanganSelesai / jumlahTantangan;

    final int persen = (progress * 100).round();

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                jumlahTantangan == 0
                    ? 'Belum ada aktivitas'
                    : '$jumlahTantanganSelesai dari $jumlahTantangan tantangan selesai',
                style: TextStyle(
                  color: mutedBlue,
                  fontSize: 12,
                ),
              ),

              Text(
                '$persen%',
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
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: const Color(0xFFE0EAF7),
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
                jumlahMateri.toString(),
              ),

              const SizedBox(width: 35),

              _progressItem(
                Icons.flag_rounded,
                'Tantangan',
                jumlahTantangan.toString(),
              ),

              const SizedBox(width: 35),

              _progressItem(
                Icons.check_circle_rounded,
                'Selesai',
                jumlahTantanganSelesai.toString(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
}

// ============================================================
// HALAMAN DAFTAR MATERI SISWA
// ============================================================

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

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                deskripsi: materi['deskripsi'] ?? '',
                isi: materi['isi'] ?? '',
                link: materi['link'] ?? '',
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                borderRadius: BorderRadius.circular(15),
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
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: mutedBlue,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        size: 15,
                        color: royalBlue,
                      ),

                      const SizedBox(width: 5),

                      const Text(
                        'Baca materi',
                        style: TextStyle(
                          color: royalBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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

// ============================================================
// HALAMAN BACA MATERI
// ============================================================

class BacaMateriPage extends StatelessWidget {
  final String judul;
  final String deskripsi;
  final String isi;
  final String link;

  const BacaMateriPage({
    super.key,
    required this.judul,
    required this.deskripsi,
    required this.isi,
    required this.link,
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
                borderRadius: BorderRadius.circular(23),
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
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: paleBlue,
                ),
              ),
              child: Text(
                isi.isEmpty
                    ? 'Belum ada isi materi.'
                    : isi,
                style: const TextStyle(
                  color: textBlue,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ),

            // ==================================================
            // LINK TAMBAHAN
            // ==================================================

            if (link.isNotEmpty) ...[
              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F9FF),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: paleBlue,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: paleBlue,
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.play_circle_outline_rounded,
                        color: royalBlue,
                      ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Materi Tambahan',
                            style: TextStyle(
                              color: textBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            link,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: mutedBlue,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Link materi tambahan siap dibuka.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.open_in_new_rounded,
                        color: royalBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],

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
                  padding: const EdgeInsets.symmetric(
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

// ============================================================
// EKSPLORASI SISWA
// ============================================================

class EksplorasiSiswaPage extends StatelessWidget {
  final String namaKelas;
  final List<Map<String, String>> daftarMateri;

  const EksplorasiSiswaPage({
    super.key,
    required this.namaKelas,
    required this.daftarMateri,
  });

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
            color: Color(0xFF18365D),
          ),
        ),
        title: const Text(
          'Eksplorasi',
          style: TextStyle(
            color: Color(0xFF18365D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: daftarMateri.isEmpty
          ? const Center(
              child: Text(
                'Belum ada materi untuk dieksplorasi.',
                style: TextStyle(
                  color: Color(0xFF7288A8),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: daftarMateri.length,
              itemBuilder: (context, index) {
                final materi = daftarMateri[index];

                return Card(
                  margin:
                      const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                    side: const BorderSide(
                      color: Color(0xFFDCEBFF),
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(14),
                    leading: const Icon(
                      Icons.explore_rounded,
                      color: Color(0xFF56B4F8),
                    ),
                    title: Text(
                      materi['judul'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF18365D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Jelajahi materi pembelajaran',
                        style: TextStyle(
                          color: Color(0xFF7288A8),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BacaMateriPage(
                            judul:
                                materi['judul'] ?? '',
                            deskripsi:
                                materi['deskripsi'] ?? '',
                            isi: materi['isi'] ?? '',
                            link: materi['link'] ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
// TANTANGAN SISWA
// ============================================================

class TantanganSiswaPage extends StatelessWidget {
  final String namaKelas;
  final String kodeKelas;
  final List<Map<String, dynamic>> daftarTantangan;

  const TantanganSiswaPage({
    super.key,
    required this.namaKelas,
    required this.kodeKelas,
    required this.daftarTantangan,
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
          'Tantangan',
          style: TextStyle(
            color: textBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: daftarTantangan.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: daftarTantangan.length,
              itemBuilder: (context, index) {
                final tantangan =
                    daftarTantangan[index];

                return _buildChallengeCard(
                  context,
                  tantangan,
                  index,
                );
              },
            ),
    );
  }

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
                Icons.flag_rounded,
                color: royalBlue,
                size: 38,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Belum Ada Tantangan',
              style: TextStyle(
                color: textBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Guru belum menambahkan tantangan untuk kelas ini.',
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

  Widget _buildChallengeCard(
    BuildContext context,
    Map<String, dynamic> tantangan,
    int index,
  ) {
    final String judul =
        tantangan['judul']?.toString() ?? 'Tantangan';

    final String deskripsi =
        tantangan['deskripsi']?.toString() ?? '';

    final List soal =
        (tantangan['soal'] as List?) ?? [];

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
          _showChallengeInfo(
            context,
            tantangan,
          );
        },
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: royalBlue,
                borderRadius:
                    BorderRadius.circular(16),
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
                    judul,
                    style: const TextStyle(
                      color: textBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    deskripsi.isEmpty
                        ? 'Tantangan pembelajaran'
                        : deskripsi,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: mutedBlue,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${soal.length} soal',
                    style: const TextStyle(
                      color: royalBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
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

  void _showChallengeInfo(
    BuildContext context,
    Map<String, dynamic> tantangan,
  ) {
    final String judul =
        tantangan['judul']?.toString() ?? 'Tantangan';

    final String deskripsi =
        tantangan['deskripsi']?.toString() ?? '';

    final List soal =
        (tantangan['soal'] as List?) ?? [];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(
                  color: textBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                deskripsi.isEmpty
                    ? 'Tantangan pembelajaran dari guru.'
                    : deskripsi,
                style: const TextStyle(
                  color: mutedBlue,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F9FF),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.quiz_rounded,
                      color: royalBlue,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      '${soal.length} soal tersedia',
                      style: const TextStyle(
                        color: textBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: soal.isEmpty
                      ? null
                      : () {
                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  KerjakanTantanganPage(
                                tantangan: tantangan,
                                namaKelas: namaKelas,
                                kodeKelas: kodeKelas,
                              ),
                            ),
                          );
                        },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        Colors.grey.shade300,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    soal.isEmpty
                        ? 'Belum Ada Soal'
                        : 'Mulai Tantangan',
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}