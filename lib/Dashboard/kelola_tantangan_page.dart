import 'package:flutter/material.dart';
import 'data_global.dart';

// =======================================================
// KELOLA TANTANGAN
// =======================================================

class KelolaTantanganPage extends StatefulWidget {
  final String? namaKelas;
  final String? kodeKelas;

  const KelolaTantanganPage({
    super.key,
    this.namaKelas,
    this.kodeKelas,
  });

  @override
  State<KelolaTantanganPage> createState() =>
      _KelolaTantanganPageState();
}

class _KelolaTantanganPageState extends State<KelolaTantanganPage> {
  static const Color royalBlue = Color(0xFF2166D5);
  static const Color deepBlue = Color(0xFF123B70);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);
  static const Color backgroundColor = Color(0xFFF6F9FE);

  bool get sedangDiDalamKelas =>
      widget.namaKelas != null && widget.kodeKelas != null;

  List<Map<String, dynamic>> get daftarTantanganTampil {
    if (!sedangDiDalamKelas) {
      return daftarTantanganGlobal;
    }

    return daftarTantanganGlobal
        .where(
          (tantangan) =>
              tantangan['kodeKelas'] == widget.kodeKelas &&
              tantangan['namaKelas'] == widget.namaKelas,
        )
        .toList();
  }

  // =========================================================
  // BUAT TANTANGAN
  // =========================================================

  void showTambahTantanganDialog() {
    final judulController = TextEditingController();
    final deskripsiController = TextEditingController();

    final namaKelasController = TextEditingController(
      text: widget.namaKelas ?? '',
    );

    final kodeKelasController = TextEditingController(
      text: widget.kodeKelas ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(
            24,
            22,
            24,
            8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            24,
            8,
            24,
            8,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            18,
            4,
            18,
            18,
          ),
          title: const Text(
            'Buat Tantangan',
            style: TextStyle(
              fontSize: 21,
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaKelasController,
                  enabled: !sedangDiDalamKelas,
                  decoration: InputDecoration(
                    labelText: 'Nama Kelas',
                    hintText: 'Contoh: Pemrograman Dasar X',
                    prefixIcon: const Icon(
                      Icons.class_rounded,
                      color: royalBlue,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F8FD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    disabledBorder: OutlineInputBorder(
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
                      color: royalBlue,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F8FD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: judulController,
                  decoration: InputDecoration(
                    labelText: 'Judul Tantangan',
                    hintText: 'Contoh: Dasar Pemrograman',
                    prefixIcon: const Icon(
                      Icons.quiz_rounded,
                      color: royalBlue,
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
                  controller: deskripsiController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    hintText:
                        'Jelaskan singkat tentang tantangan ini',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 35),
                      child: Icon(
                        Icons.description_outlined,
                        color: royalBlue,
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: TextButton.styleFrom(
                foregroundColor: mutedBlue,
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final namaKelas =
                    namaKelasController.text.trim();

                final kodeKelas =
                    kodeKelasController.text.trim();

                final judul =
                    judulController.text.trim();

                final deskripsi =
                    deskripsiController.text.trim();

                if (namaKelas.isEmpty ||
                    kodeKelas.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Nama kelas dan kode kelas wajib diisi.',
                      ),
                    ),
                  );
                  return;
                }

                if (judul.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Judul tantangan harus diisi.',
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  daftarTantanganGlobal.add({
                    'namaKelas': namaKelas,
                    'kodeKelas': kodeKelas,
                    'judul': judul,
                    'deskripsi': deskripsi,
                    'soal': <Map<String, dynamic>>[],
                  });
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Tantangan berhasil dibuat.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buat Tantangan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // EDIT TANTANGAN
  // =========================================================

  void showEditTantanganDialog(
    Map<String, dynamic> tantangan,
  ) {
    final judulController = TextEditingController(
      text: tantangan['judul'] ?? '',
    );

    final deskripsiController = TextEditingController(
      text: tantangan['deskripsi'] ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(
            24,
            22,
            24,
            8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            24,
            8,
            24,
            8,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            18,
            4,
            18,
            18,
          ),
          title: const Text(
            'Edit Tantangan',
            style: TextStyle(
              fontSize: 21,
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulController,
                  decoration: InputDecoration(
                    labelText: 'Judul Tantangan',
                    prefixIcon: const Icon(
                      Icons.quiz_rounded,
                      color: royalBlue,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F8FD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: deskripsiController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 35),
                      child: Icon(
                        Icons.description_outlined,
                        color: royalBlue,
                      ),
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: const Color(0xFFF5F8FD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: TextButton.styleFrom(
                foregroundColor: mutedBlue,
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final judul =
                    judulController.text.trim();

                if (judul.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Judul tantangan harus diisi.',
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  tantangan['judul'] = judul;
                  tantangan['deskripsi'] =
                      deskripsiController.text.trim();
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Tantangan berhasil diperbarui.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // HAPUS TANTANGAN
  // =========================================================

  void hapusTantangan(
    Map<String, dynamic> tantangan,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Hapus Tantangan?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textBlue,
            ),
          ),
          content: Text(
            'Tantangan "${tantangan['judul']}" beserta semua '
            'soal di dalamnya akan dihapus.',
            style: const TextStyle(
              color: mutedBlue,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: TextButton.styleFrom(
                foregroundColor: mutedBlue,
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  daftarTantanganGlobal.remove(tantangan);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Tantangan berhasil dihapus.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // HALAMAN KELOLA SOAL
  // =========================================================

  void bukaKelolaSoal(
    Map<String, dynamic> tantangan,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KelolaSoalPage(
          judulTantangan:
              tantangan['judul']?.toString() ?? 'Tantangan',
          daftarSoal:
              tantangan['soal'] as List<Map<String, dynamic>>,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  // =========================================================
  // CARD TANTANGAN
  // =========================================================

  Widget buildTantanganCard(
    Map<String, dynamic> tantangan,
  ) {
    final List soal = tantangan['soal'] ?? [];

    final String judul =
        tantangan['judul']?.toString() ?? '';

    final String namaKelas =
        tantangan['namaKelas']?.toString() ?? '';

    final String kodeKelas =
        tantangan['kodeKelas']?.toString() ?? '';

    final String deskripsi =
        tantangan['deskripsi']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE1E9F5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Colors.white,
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textBlue,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: paleBlue,
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$namaKelas • $kodeKelas',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: royalBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.list_alt_rounded,
                          size: 15,
                          color: mutedBlue,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${soal.length} soal',
                          style: const TextStyle(
                            fontSize: 12,
                            color: mutedBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: mutedBlue,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    showEditTantanganDialog(
                      tantangan,
                    );
                  } else if (value == 'hapus') {
                    hapusTantangan(tantangan);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: royalBlue,
                        ),
                        SizedBox(width: 8),
                        Text('Edit Tantangan'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'hapus',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('Hapus Tantangan'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (deskripsi.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              deskripsi,
              style: const TextStyle(
                fontSize: 13,
                color: mutedBlue,
                height: 1.4,
              ),
            ),
          ],

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  bukaKelolaSoal(tantangan),
              icon: const Icon(
                Icons.edit_note_rounded,
                size: 20,
              ),
              label: const Text(
                'Kelola Soal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final tantangan = daftarTantanganTampil;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: textBlue,
        ),
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kelola Tantangan',
              style: TextStyle(
                color: textBlue,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            if (sedangDiDalamKelas)
              Text(
                widget.namaKelas!,
                style: const TextStyle(
                  fontSize: 11,
                  color: mutedBlue,
                ),
              ),
          ],
        ),
      ),
      body: tantangan.isEmpty
          ? buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                110,
              ),
              itemCount: tantangan.length,
              itemBuilder: (context, index) {
                return buildTantanganCard(
                  tantangan[index],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showTambahTantanganDialog,
        backgroundColor: royalBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Buat Tantangan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: const BoxDecoration(
                color: paleBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.quiz_outlined,
                color: royalBlue,
                size: 42,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              sedangDiDalamKelas
                  ? 'Belum Ada Tantangan di Kelas Ini'
                  : 'Belum Ada Tantangan',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: textBlue,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              sedangDiDalamKelas
                  ? 'Buat tantangan untuk ${widget.namaKelas}.'
                  : 'Buat tantangan untuk menambahkan soal '
                    'pembelajaran bagi siswa.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: mutedBlue,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: showTambahTantanganDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Buat Tantangan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
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
    );
  }
}

// =============================================================
// HALAMAN KELOLA SOAL
// =============================================================

class KelolaSoalPage extends StatefulWidget {
  final String judulTantangan;
  final List<Map<String, dynamic>> daftarSoal;

  const KelolaSoalPage({
    super.key,
    required this.judulTantangan,
    required this.daftarSoal,
  });

  @override
  State<KelolaSoalPage> createState() =>
      _KelolaSoalPageState();
}

class _KelolaSoalPageState extends State<KelolaSoalPage> {
  static const Color royalBlue = Color(0xFF2166D5);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);
  static const Color backgroundColor = Color(0xFFF6F9FE);

  // =========================================================
  // TAMBAH SOAL
  // =========================================================

  void tambahSoal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (bottomSheetContext) {
        final tinggiLayar =
            MediaQuery.of(bottomSheetContext).size.height;

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: tinggiLayar * 0.78,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              24,
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(
                    bottom: 18,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7DFEA),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),

                const Text(
                  'Pilih Model Soal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textBlue,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Pilih jenis soal yang ingin ditambahkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: mutedBlue,
                  ),
                ),

                const SizedBox(height: 18),

                buildTipeSoal(
                  icon: Icons.radio_button_checked_rounded,
                  title: 'Pilihan Ganda',
                  subtitle:
                      'Siswa memilih satu jawaban',
                  tipe: 'Pilihan Ganda',
                ),

                buildTipeSoal(
                  icon: Icons.check_circle_outline_rounded,
                  title: 'Benar / Salah',
                  subtitle:
                      'Siswa menentukan benar atau salah',
                  tipe: 'Benar / Salah',
                ),

                buildTipeSoal(
                  icon: Icons.checklist_rounded,
                  title: 'Pilihan Ganda Kompleks',
                  subtitle:
                      'Siswa dapat memilih beberapa jawaban',
                  tipe: 'Pilihan Ganda Kompleks',
                ),

                buildTipeSoal(
                  icon: Icons.keyboard_alt_outlined,
                  title: 'Isian Singkat',
                  subtitle:
                      'Siswa mengetik jawaban',
                  tipe: 'Isian Singkat',
                ),

                buildTipeSoal(
                  icon: Icons.compare_arrows_rounded,
                  title: 'Menjodohkan',
                  subtitle:
                      'Siswa memasangkan soal dan jawaban',
                  tipe: 'Menjodohkan',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // PILIH MODEL SOAL
  // =========================================================

  Widget buildTipeSoal({
    required IconData icon,
    required String title,
    required String subtitle,
    required String tipe,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE4EBF5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pop(context);
            showFormSoal(tipe);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 12,
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: paleBlue,
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    color: royalBlue,
                    size: 24,
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
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textBlue,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: mutedBlue,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: mutedBlue,
                  size: 23,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // FORM SOAL
  // =========================================================

  void showFormSoal(
    String tipe, {
    int? editIndex,
  }) {
    final bool isEdit = editIndex != null;

    final Map<String, dynamic>? soalLama =
        isEdit ? widget.daftarSoal[editIndex!] : null;

    final pertanyaanController = TextEditingController(
      text: soalLama?['pertanyaan'] ?? '',
    );

    final jawabanController = TextEditingController(
      text: soalLama?['jawaban'] ?? '',
    );

    final pilihanAController = TextEditingController(
      text: soalLama?['pilihanA'] ?? '',
    );

    final pilihanBController = TextEditingController(
      text: soalLama?['pilihanB'] ?? '',
    );

    final pilihanCController = TextEditingController(
      text: soalLama?['pilihanC'] ?? '',
    );

    final pilihanDController = TextEditingController(
      text: soalLama?['pilihanD'] ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(
            24,
            22,
            24,
            8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            24,
            8,
            24,
            8,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            18,
            4,
            18,
            18,
          ),
          title: Text(
            isEdit ? 'Edit Soal' : 'Tambah Soal',
            style: const TextStyle(
              fontSize: 21,
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: paleBlue,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.category_outlined,
                          color: royalBlue,
                          size: 19,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tipe,
                            style: const TextStyle(
                              color: royalBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: pertanyaanController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Pertanyaan',
                      hintText:
                          'Tulis pertanyaan di sini...',
                      alignLabelWithHint: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(
                          bottom: 45,
                        ),
                        child: Icon(
                          Icons.help_outline_rounded,
                          color: royalBlue,
                        ),
                      ),
                      filled: true,
                      fillColor:
                          const Color(0xFFF5F8FD),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(13),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (tipe == 'Pilihan Ganda' ||
                      tipe ==
                          'Pilihan Ganda Kompleks') ...[
                    buildTextField(
                      pilihanAController,
                      'Pilihan A',
                      icon: Icons.looks_one_outlined,
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      pilihanBController,
                      'Pilihan B',
                      icon: Icons.looks_two_outlined,
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      pilihanCController,
                      'Pilihan C',
                      icon: Icons.looks_3_outlined,
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      pilihanDController,
                      'Pilihan D',
                      icon: Icons.looks_4_outlined,
                    ),
                    const SizedBox(height: 10),
                  ],

                  buildTextField(
                    jawabanController,
                    tipe == 'Benar / Salah'
                        ? 'Jawaban (Benar / Salah)'
                        : tipe ==
                                'Pilihan Ganda Kompleks'
                            ? 'Jawaban benar (contoh: A, C)'
                            : 'Jawaban Benar',
                    icon: Icons.check_circle_outline_rounded,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: TextButton.styleFrom(
                foregroundColor: mutedBlue,
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (pertanyaanController.text
                        .trim()
                        .isEmpty ||
                    jawabanController.text
                        .trim()
                        .isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Pertanyaan dan jawaban harus diisi.',
                      ),
                    ),
                  );
                  return;
                }

                final data = {
                  'tipe': tipe,
                  'pertanyaan':
                      pertanyaanController.text.trim(),
                  'jawaban':
                      jawabanController.text.trim(),
                  'pilihanA':
                      pilihanAController.text.trim(),
                  'pilihanB':
                      pilihanBController.text.trim(),
                  'pilihanC':
                      pilihanCController.text.trim(),
                  'pilihanD':
                      pilihanDController.text.trim(),
                };

                setState(() {
                  if (isEdit) {
                    widget.daftarSoal[editIndex!] =
                        data;
                  } else {
                    widget.daftarSoal.add(data);
                  }
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit
                          ? 'Soal berhasil diperbarui.'
                          : 'Soal berhasil ditambahkan.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isEdit ? 'Simpan' : 'Tambah',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // TEXT FIELD
  // =========================================================

  Widget buildTextField(
    TextEditingController controller,
    String label, {
    IconData icon = Icons.edit_outlined,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: royalBlue,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F8FD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // =========================================================
  // HAPUS SOAL
  // =========================================================

  void hapusSoal(int index) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Hapus Soal?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textBlue,
            ),
          ),
          content: const Text(
            'Soal ini akan dihapus dari tantangan.',
            style: TextStyle(
              color: mutedBlue,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: TextButton.styleFrom(
                foregroundColor: mutedBlue,
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.daftarSoal.removeAt(index);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Soal berhasil dihapus.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // CARD SOAL
  // =========================================================

  Widget buildSoalCard(
    int index,
    Map<String, dynamic> soal,
  ) {
    final String tipe =
        soal['tipe']?.toString() ?? '';

    final String pertanyaan =
        soal['pertanyaan']?.toString() ?? '';

    final String jawaban =
        soal['jawaban']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE1E9F5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: paleBlue,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Text(
                  tipe,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: royalBlue,
                  ),
                ),
              ),

              const Spacer(),

              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: mutedBlue,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    showFormSoal(
                      tipe,
                      editIndex: index,
                    );
                  } else if (value == 'hapus') {
                    hapusSoal(index);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: royalBlue,
                        ),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
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

          const SizedBox(height: 12),

          Text(
            '${index + 1}. $pertanyaan',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textBlue,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FD),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 17,
                  color: royalBlue,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Jawaban: $jawaban',
                    style: const TextStyle(
                      fontSize: 12,
                      color: mutedBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: textBlue,
        ),
        titleSpacing: 20,
        title: Text(
          widget.judulTantangan,
          style: const TextStyle(
            color: textBlue,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
      body: widget.daftarSoal.isEmpty
          ? buildEmptySoal()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                110,
              ),
              itemCount: widget.daftarSoal.length,
              itemBuilder: (context, index) {
                return buildSoalCard(
                  index,
                  widget.daftarSoal[index],
                );
              },
            ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: tambahSoal,
        backgroundColor: royalBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Soal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // EMPTY SOAL
  // =========================================================

  Widget buildEmptySoal() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: paleBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                color: royalBlue,
                size: 42,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Belum Ada Soal',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: textBlue,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Tambahkan soal dengan berbagai model '
              'untuk tantangan ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: mutedBlue,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: tambahSoal,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Tambah Soal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}