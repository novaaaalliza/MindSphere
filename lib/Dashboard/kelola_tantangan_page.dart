import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// =======================================================
// KELOLA TANTANGAN MINDSHPERE - FIRESTORE
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

class _KelolaTantanganPageState
    extends State<KelolaTantanganPage> {
  static const Color royalBlue = Color(0xFF2166D5);
  static const Color deepBlue = Color(0xFF123B70);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);
  static const Color backgroundColor = Color(0xFFF6F9FE);

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  bool get sedangDiDalamKelas =>
      widget.namaKelas != null &&
      widget.kodeKelas != null;

  CollectionReference<Map<String, dynamic>>
      get koleksiTantangan =>
          firestore.collection('tantangan');

  // =====================================================
  // STREAM TANTANGAN
  // =====================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
      get streamTantangan {
    if (sedangDiDalamKelas) {
      return koleksiTantangan
          .where(
            'kodeKelas',
            isEqualTo: widget.kodeKelas,
          )
          .snapshots();
    }

    return koleksiTantangan.snapshots();
  }

  // =====================================================
  // NOTIFIKASI
  // =====================================================

  void tampilkanPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  // =====================================================
  // CEK LOGIN
  // =====================================================

  bool get sudahLogin =>
      FirebaseAuth.instance.currentUser != null;

  // =====================================================
  // BUAT TANTANGAN
  // =====================================================

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Buat Tantangan',
            style: TextStyle(
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildField(
                  namaKelasController,
                  'Nama Kelas',
                  icon: Icons.class_rounded,
                  enabled: !sedangDiDalamKelas,
                ),
                const SizedBox(height: 12),
                buildField(
                  kodeKelasController,
                  'Kode Kelas',
                  icon: Icons.key_rounded,
                  enabled: !sedangDiDalamKelas,
                ),
                const SizedBox(height: 12),
                buildField(
                  judulController,
                  'Judul Tantangan',
                  icon: Icons.quiz_rounded,
                ),
                const SizedBox(height: 12),
                buildField(
                  deskripsiController,
                  'Deskripsi',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final namaKelas =
                    namaKelasController.text.trim();
                final kodeKelas =
                    kodeKelasController.text.trim();
                final judul =
                    judulController.text.trim();
                final deskripsi =
                    deskripsiController.text.trim();

                if (namaKelas.isEmpty ||
                    kodeKelas.isEmpty ||
                    judul.isEmpty) {
                  tampilkanPesan(
                    'Nama kelas, kode kelas, dan judul wajib diisi.',
                  );
                  return;
                }

                final user =
                    FirebaseAuth.instance.currentUser;

                if (user == null) {
                  tampilkanPesan(
                    'Silakan login terlebih dahulu.',
                  );
                  return;
                }

                try {
                  await koleksiTantangan.add({
                    'namaKelas': namaKelas,
                    'kodeKelas': kodeKelas,
                    'judul': judul,
                    'deskripsi': deskripsi,
                    'soal': <Map<String, dynamic>>[],
                    'createdBy': user.uid,
                    'createdAt':
                        FieldValue.serverTimestamp(),
                    'updatedAt':
                        FieldValue.serverTimestamp(),
                  });

                  if (!mounted) return;

                  Navigator.pop(dialogContext);

                  tampilkanPesan(
                    'Tantangan berhasil dibuat.',
                  );
                } catch (e) {
                  tampilkanPesan(
                    'Gagal membuat tantangan: $e',
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Buat Tantangan'),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // EDIT TANTANGAN
  // =====================================================

  void showEditTantanganDialog(
    String id,
    Map<String, dynamic> tantangan,
  ) {
    final judulController = TextEditingController(
      text: tantangan['judul']?.toString() ?? '',
    );

    final deskripsiController = TextEditingController(
      text: tantangan['deskripsi']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Edit Tantangan',
            style: TextStyle(
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildField(
                judulController,
                'Judul Tantangan',
                icon: Icons.quiz_rounded,
              ),
              const SizedBox(height: 12),
              buildField(
                deskripsiController,
                'Deskripsi',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final judul =
                    judulController.text.trim();

                if (judul.isEmpty) {
                  tampilkanPesan(
                    'Judul tantangan harus diisi.',
                  );
                  return;
                }

                try {
                  await koleksiTantangan.doc(id).update({
                    'judul': judul,
                    'deskripsi':
                        deskripsiController.text.trim(),
                    'updatedAt':
                        FieldValue.serverTimestamp(),
                  });

                  if (!mounted) return;

                  Navigator.pop(dialogContext);

                  tampilkanPesan(
                    'Tantangan berhasil diperbarui.',
                  );
                } catch (e) {
                  tampilkanPesan(
                    'Gagal mengedit tantangan: $e',
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // HAPUS TANTANGAN
  // =====================================================

  void hapusTantangan(
    String id,
    String judul,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Hapus Tantangan?',
            style: TextStyle(
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Tantangan "$judul" beserta soal di dalamnya akan dihapus.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await koleksiTantangan.doc(id).delete();

                  if (!mounted) return;

                  Navigator.pop(dialogContext);

                  tampilkanPesan(
                    'Tantangan berhasil dihapus.',
                  );
                } catch (e) {
                  tampilkanPesan(
                    'Gagal menghapus tantangan: $e',
                  );
                }
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

  // =====================================================
  // KELOLA SOAL
  // =====================================================

  void bukaKelolaSoal(
    String id,
    Map<String, dynamic> tantangan,
  ) {
    final List<Map<String, dynamic>> soal =
        (tantangan['soal'] as List? ?? [])
            .map(
              (item) => Map<String, dynamic>.from(item),
            )
            .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KelolaSoalPage(
          idTantangan: id,
          judulTantangan:
              tantangan['judul']?.toString() ?? 'Tantangan',
          daftarSoal: soal,
        ),
      ),
    );
  }

  // =====================================================
  // FIELD INPUT
  // =====================================================

  Widget buildField(
    TextEditingController controller,
    String label, {
    IconData icon = Icons.edit_outlined,
    bool enabled = true,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: royalBlue,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F8FD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // =====================================================
  // CARD TANTANGAN
  // =====================================================

  Widget buildTantanganCard(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final tantangan = doc.data();

    final judul =
        tantangan['judul']?.toString() ?? '';

    final namaKelas =
        tantangan['namaKelas']?.toString() ?? '';

    final kodeKelas =
        tantangan['kodeKelas']?.toString() ?? '';

    final deskripsi =
        tantangan['deskripsi']?.toString() ?? '';

    final List soal = tantangan['soal'] as List? ?? [];

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
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [royalBlue, skyBlue],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(
                      '$namaKelas • $kodeKelas',
                      style: const TextStyle(
                        fontSize: 11,
                        color: royalBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${soal.length} soal',
                      style: const TextStyle(
                        fontSize: 12,
                        color: mutedBlue,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    showEditTantanganDialog(
                      doc.id,
                      tantangan,
                    );
                  } else if (value == 'hapus') {
                    hapusTantangan(doc.id, judul);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Tantangan'),
                  ),
                  PopupMenuItem(
                    value: 'hapus',
                    child: Text('Hapus Tantangan'),
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
                  bukaKelolaSoal(doc.id, tantangan),
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('Kelola Soal'),
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

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: textBlue,
        ),
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
      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: streamTantangan,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Gagal mengambil tantangan:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: royalBlue,
              ),
            );
          }

          // Data sudah difilter berdasarkan kode kelas
          // pada streamTantangan.
          final docs = snapshot.data?.docs ?? [];

          final daftar = docs;

          if (daftar.isEmpty) {
            return buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              110,
            ),
            itemCount: daftar.length,
            itemBuilder: (context, index) {
              return buildTantanganCard(daftar[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showTambahTantanganDialog,
        backgroundColor: royalBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Buat Tantangan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // =====================================================
  // EMPTY STATE
  // =====================================================

  Widget buildEmptyState() {
    return Center(
      child: Padding(
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
            const Text(
              'Buat tantangan untuk menambahkan soal pembelajaran bagi siswa.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: mutedBlue,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: showTambahTantanganDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Buat Tantangan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// HALAMAN KELOLA SOAL - FIRESTORE
// =============================================================

class KelolaSoalPage extends StatefulWidget {
  final String idTantangan;
  final String judulTantangan;
  final List<Map<String, dynamic>> daftarSoal;

  const KelolaSoalPage({
    super.key,
    required this.idTantangan,
    required this.judulTantangan,
    required this.daftarSoal,
  });

  @override
  State<KelolaSoalPage> createState() =>
      _KelolaSoalPageState();
}

class _KelolaSoalPageState extends State<KelolaSoalPage> {
  static const Color royalBlue = Color(0xFF2166D5);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);
  static const Color backgroundColor = Color(0xFFF6F9FE);

  CollectionReference<Map<String, dynamic>>
      get koleksiTantangan =>
          FirebaseFirestore.instance.collection('tantangan');

  bool sedangMenyimpan = false;

  // =====================================================
  // SIMPAN SOAL KE FIRESTORE
  // =====================================================

  Future<void> simpanSoal() async {
    if (sedangMenyimpan) return;

    setState(() => sedangMenyimpan = true);

    try {
      await koleksiTantangan
          .doc(widget.idTantangan)
          .update({
        'soal': widget.daftarSoal,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Soal berhasil disimpan ke Firebase.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan soal: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => sedangMenyimpan = false);
      }
    }
  }

  // =====================================================
  // PILIH JENIS SOAL
  // =====================================================

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
      builder: (sheetContext) {
        final tipeSoal = [
          {
            'nama': 'Pilihan Ganda',
            'keterangan': 'Siswa memilih satu jawaban.',
            'icon': Icons.radio_button_checked_rounded,
          },
          {
            'nama': 'Benar / Salah',
            'keterangan': 'Siswa menentukan benar atau salah.',
            'icon': Icons.check_circle_outline_rounded,
          },
          {
            'nama': 'Pilihan Ganda Kompleks',
            'keterangan': 'Siswa memilih beberapa jawaban.',
            'icon': Icons.checklist_rounded,
          },
          {
            'nama': 'Isian Singkat',
            'keterangan': 'Siswa mengetik jawaban.',
            'icon': Icons.keyboard_alt_outlined,
          },
          {
            'nama': 'Menjodohkan',
            'keterangan': 'Siswa memasangkan jawaban.',
            'icon': Icons.compare_arrows_rounded,
          },
        ];

        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilih Model Soal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textBlue,
                  ),
                ),
                const SizedBox(height: 16),
                ...tipeSoal.map((item) {
                  return ListTile(
                    leading: Icon(
                      item['icon'] as IconData,
                      color: royalBlue,
                    ),
                    title: Text(
                      item['nama'] as String,
                      style: const TextStyle(
                        color: textBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      item['keterangan'] as String,
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      showFormSoal(
                        item['nama'] as String,
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // =====================================================
  // FORM SOAL
  // =====================================================

  void showFormSoal(
    String tipe, {
    int? editIndex,
  }) {
    final isEdit = editIndex != null;

    final Map<String, dynamic>? soalLama =
        isEdit ? widget.daftarSoal[editIndex!] : null;

    final pertanyaan = TextEditingController(
      text: soalLama?['pertanyaan']?.toString() ?? '',
    );

    final jawaban = TextEditingController(
      text: soalLama?['jawaban']?.toString() ?? '',
    );

    final pilihanA = TextEditingController(
      text: soalLama?['pilihanA']?.toString() ?? '',
    );

    final pilihanB = TextEditingController(
      text: soalLama?['pilihanB']?.toString() ?? '',
    );

    final pilihanC = TextEditingController(
      text: soalLama?['pilihanC']?.toString() ?? '',
    );

    final pilihanD = TextEditingController(
      text: soalLama?['pilihanD']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            isEdit ? 'Edit Soal' : 'Tambah Soal',
            style: const TextStyle(
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: paleBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tipe,
                      style: const TextStyle(
                        color: royalBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  buildInput(
                    pertanyaan,
                    'Pertanyaan',
                    maxLines: 3,
                  ),
                  if (tipe == 'Pilihan Ganda' ||
                      tipe == 'Pilihan Ganda Kompleks') ...[
                    const SizedBox(height: 12),
                    buildInput(pilihanA, 'Pilihan A'),
                    const SizedBox(height: 10),
                    buildInput(pilihanB, 'Pilihan B'),
                    const SizedBox(height: 10),
                    buildInput(pilihanC, 'Pilihan C'),
                    const SizedBox(height: 10),
                    buildInput(pilihanD, 'Pilihan D'),
                  ],
                  const SizedBox(height: 12),
                  buildInput(
                    jawaban,
                    tipe == 'Benar / Salah'
                        ? 'Jawaban (Benar / Salah)'
                        : tipe == 'Pilihan Ganda Kompleks'
                            ? 'Jawaban benar (contoh: A, C)'
                            : 'Jawaban Benar',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (pertanyaan.text.trim().isEmpty ||
                    jawaban.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Pertanyaan dan jawaban harus diisi.',
                      ),
                    ),
                  );
                  return;
                }

                final data = <String, dynamic>{
                  'tipe': tipe,
                  'pertanyaan': pertanyaan.text.trim(),
                  'jawaban': jawaban.text.trim(),
                  'pilihanA': pilihanA.text.trim(),
                  'pilihanB': pilihanB.text.trim(),
                  'pilihanC': pilihanC.text.trim(),
                  'pilihanD': pilihanD.text.trim(),
                };

                setState(() {
                  if (isEdit) {
                    widget.daftarSoal[editIndex!] = data;
                  } else {
                    widget.daftarSoal.add(data);
                  }
                });

                Navigator.pop(dialogContext);
                await simpanSoal();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
              ),
              child: Text(isEdit ? 'Simpan' : 'Tambah'),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // INPUT
  // =====================================================

  Widget buildInput(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF5F8FD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // =====================================================
  // HAPUS SOAL
  // =====================================================

  Future<void> hapusSoal(int index) async {
    final soalDihapus = widget.daftarSoal.removeAt(index);

    setState(() {});

    try {
      await koleksiTantangan
          .doc(widget.idTantangan)
          .update({
        'soal': widget.daftarSoal,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Soal berhasil dihapus.'),
        ),
      );
    } catch (e) {
      widget.daftarSoal.insert(index, soalDihapus);

      if (mounted) setState(() {});

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus soal: $e'),
        ),
      );
    }
  }

  // =====================================================
  // CARD SOAL
  // =====================================================

  Widget buildSoalCard(
    int index,
    Map<String, dynamic> soal,
  ) {
    final tipe = soal['tipe']?.toString() ?? '';
    final pertanyaan =
        soal['pertanyaan']?.toString() ?? '';
    final jawaban =
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tipe,
                  style: const TextStyle(
                    color: royalBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PopupMenuButton<String>(
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
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'hapus',
                    child: Text('Hapus'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${index + 1}. $pertanyaan',
            style: const TextStyle(
              fontSize: 15,
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Jawaban: $jawaban',
            style: const TextStyle(
              fontSize: 12,
              color: mutedBlue,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: textBlue,
        ),
        title: Text(
          widget.judulTantangan,
          style: const TextStyle(
            color: textBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: widget.daftarSoal.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit_note_rounded,
                    color: royalBlue,
                    size: 60,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum Ada Soal',
                    style: TextStyle(
                      color: textBlue,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tambahkan soal untuk tantangan ini.',
                    style: TextStyle(color: mutedBlue),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: tambahSoal,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Soal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: royalBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: tambahSoal,
        backgroundColor: royalBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Soal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}