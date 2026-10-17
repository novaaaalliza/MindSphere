import 'package:flutter/material.dart';

class KelolaMateriPage extends StatefulWidget {
  final String? namaKelas;
  final String? kodeKelas;

  const KelolaMateriPage({
    super.key,
    this.namaKelas,
    this.kodeKelas,
  });

  @override
  State<KelolaMateriPage> createState() => _KelolaMateriPageState();
}

// =======================================================
// DATA MATERI BERSAMA
// =======================================================
// Data ini digunakan bersama oleh halaman Kelola Materi
// selama aplikasi sedang berjalan.
final List<Map<String, String>> daftarMateriGlobal = [];

class _KelolaMateriPageState extends State<KelolaMateriPage> {
  bool get sedangDiDalamKelas =>
      widget.namaKelas != null && widget.kodeKelas != null;

  List<Map<String, String>> get daftarMateriTampil {
    if (!sedangDiDalamKelas) {
      return daftarMateriGlobal;
    }

    return daftarMateriGlobal
        .where(
          (materi) =>
              materi['kodeKelas'] == widget.kodeKelas &&
              materi['namaKelas'] == widget.namaKelas,
        )
        .toList();
  }

  // =======================================================
  // TAMBAH MATERI
  // =======================================================

  void tambahMateri() {
    final judulController = TextEditingController();
    final isiController = TextEditingController();
    final sumberController = TextEditingController();

    final namaKelasController = TextEditingController(
      text: widget.namaKelas ?? '',
    );

    final kodeKelasController = TextEditingController(
      text: widget.kodeKelas ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Tambah Materi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF18365D),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =================================================
                // INFORMASI KELAS
                // =================================================

                TextField(
                  controller: namaKelasController,
                  enabled: !sedangDiDalamKelas,
                  decoration: InputDecoration(
                    labelText: 'Nama Kelas',
                    hintText: 'Contoh: Pemrograman Dasar X',
                    prefixIcon: const Icon(
                      Icons.class_rounded,
                      color: Color(0xFF2166D5),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F8FD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: kodeKelasController,
                  enabled: !sedangDiDalamKelas,
                  decoration: InputDecoration(
                    labelText: 'Kode Kelas',
                    hintText: 'Contoh: PDX-01',
                    prefixIcon: const Icon(
                      Icons.key_rounded,
                      color: Color(0xFF2166D5),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F8FD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // JUDUL MATERI
                // =================================================

                TextField(
                  controller: judulController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Judul Materi',
                    hintText: 'Contoh: Pengenalan Algoritma',
                    prefixIcon: const Icon(
                      Icons.menu_book_outlined,
                      color: Color(0xFF2166D5),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F8FD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // =================================================
                // ISI MATERI
                // =================================================

                TextField(
                  controller: isiController,
                  maxLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Isi Materi',
                    hintText: 'Tuliskan materi pembelajaran...',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 90),
                      child: Icon(
                        Icons.article_outlined,
                        color: Color(0xFF2166D5),
                      ),
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: const Color(0xFFF5F8FD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // =================================================
                // LINK SUMBER
                // =================================================

                TextField(
                  controller: sumberController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: 'Link Sumber Tambahan',
                    hintText: 'Opsional, misalnya link YouTube',
                    prefixIcon: const Icon(
                      Icons.link_rounded,
                      color: Color(0xFF2166D5),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F8FD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Color(0xFF7288A8),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final namaKelas = namaKelasController.text.trim();
                final kodeKelas = kodeKelasController.text.trim();
                final judul = judulController.text.trim();
                final isi = isiController.text.trim();
                final sumber = sumberController.text.trim();

                if (namaKelas.isEmpty || kodeKelas.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Nama kelas dan kode kelas wajib diisi.',
                      ),
                    ),
                  );
                  return;
                }

                if (judul.isEmpty || isi.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Judul dan isi materi wajib diisi.',
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  daftarMateriGlobal.add({
                    'namaKelas': namaKelas,
                    'kodeKelas': kodeKelas,
                    'judul': judul,
                    'isi': isi,
                    'sumber': sumber,
                  });
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Materi berhasil ditambahkan.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2166D5),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =======================================================
  // LIHAT MATERI
  // =======================================================

  void lihatMateri(Map<String, String> materi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailMateriPage(
          namaKelas: materi['namaKelas'] ?? '',
          kodeKelas: materi['kodeKelas'] ?? '',
          judul: materi['judul'] ?? '',
          isi: materi['isi'] ?? '',
          sumber: materi['sumber'] ?? '',
        ),
      ),
    );
  }

  // =======================================================
  // HAPUS MATERI
  // =======================================================

  void hapusMateri(Map<String, String> materi) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Hapus Materi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF18365D),
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus materi "${materi['judul']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  daftarMateriGlobal.remove(materi);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Materi berhasil dihapus.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // =======================================================
  // CARD MATERI
  // =======================================================

  Widget buildMateriCard(
    Map<String, String> materi,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE1E9F5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => lihatMateri(materi),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEBFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF2166D5),
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materi['judul'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF18365D),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCEBFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${materi['namaKelas']} • ${materi['kodeKelas']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2166D5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      materi['isi'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7288A8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'hapus') {
                    hapusMateri(materi);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'hapus',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('Hapus'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =======================================================
  // BUILD
  // =======================================================

  @override
  Widget build(BuildContext context) {
    final materi = daftarMateriTampil;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FE),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kelola Materi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF18365D),
              ),
            ),

            if (sedangDiDalamKelas)
              Text(
                widget.namaKelas!,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF7288A8),
                ),
              ),
          ],
        ),
      ),

      body: materi.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCEBFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu_book_outlined,
                        size: 45,
                        color: Color(0xFF2166D5),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      sedangDiDalamKelas
                          ? 'Belum Ada Materi di Kelas Ini'
                          : 'Belum Ada Materi',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF18365D),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      sedangDiDalamKelas
                          ? 'Tambahkan materi untuk ${widget.namaKelas}.'
                          : 'Tambahkan materi pembelajaran untuk kelas yang dikelola.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF7288A8),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: tambahMateri,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Tambah Materi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2166D5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                100,
              ),
              itemCount: materi.length,
              itemBuilder: (context, index) {
                return buildMateriCard(materi[index]);
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: tambahMateri,
        backgroundColor: const Color(0xFF2166D5),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Materi'),
      ),
    );
  }
}

// =======================================================
// DETAIL MATERI
// =======================================================

class DetailMateriPage extends StatelessWidget {
  final String namaKelas;
  final String kodeKelas;
  final String judul;
  final String isi;
  final String sumber;

  const DetailMateriPage({
    super.key,
    required this.namaKelas,
    required this.kodeKelas,
    required this.judul,
    required this.isi,
    required this.sumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FE),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Detail Materi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF18365D),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // KELAS
            // =================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCEBFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.class_rounded,
                    color: Color(0xFF2166D5),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          namaKelas,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF18365D),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Kode: $kodeKelas',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7288A8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // =================================================
            // JUDUL
            // =================================================

            Text(
              judul,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF18365D),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Isi Materi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF18365D),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE1E9F5),
                ),
              ),
              child: Text(
                isi,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF425B78),
                  height: 1.7,
                ),
              ),
            ),

            // =================================================
            // SUMBER
            // =================================================

            if (sumber.isNotEmpty) ...[
              const SizedBox(height: 24),

              const Text(
                'Sumber Tambahan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18365D),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE1E9F5),
                  ),
                ),
                child: SelectableText(
                  sumber,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2166D5),
                    height: 1.5,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}