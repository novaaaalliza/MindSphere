import 'package:flutter/material.dart';
import '../data/tantangan_data.dart';

class TantanganGuruPage extends StatefulWidget {
  final String namaKelas;
  final String kodeKelas;

  const TantanganGuruPage({
    super.key,
    required this.namaKelas,
    required this.kodeKelas,
  });

  @override
  State<TantanganGuruPage> createState() => _TantanganGuruPageState();
}

class _TantanganGuruPageState extends State<TantanganGuruPage> {
  final Color royalBlue = const Color(0xFF2166D5);
  final Color deepBlue = const Color(0xFF123B70);
  final Color skyBlue = const Color(0xFF56B4F8);
  final Color paleBlue = const Color(0xFFDCEBFF);
  final Color textBlue = const Color(0xFF18365D);
  final Color mutedBlue = const Color(0xFF7288A8);

  @override
  Widget build(BuildContext context) {
    final daftarTantangan =
        TantanganData.getTantanganByKelas(widget.kodeKelas);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(
        backgroundColor: royalBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tantangan',
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
            // HEADER KELAS
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
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.flag_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
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
                          'Kode kelas: ${widget.kodeKelas}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // JUDUL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tantangan Kelas',
                  style: TextStyle(
                    color: Color(0xFF18365D),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showTambahTantangan,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Tambah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // DAFTAR TANTANGAN
            if (daftarTantangan.isEmpty)
              _buildEmptyState()
            else
              ...daftarTantangan.map(
                (tantangan) => _buildTantanganCard(tantangan),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: paleBlue,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: paleBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.flag_outlined,
              color: royalBlue,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada tantangan',
            style: TextStyle(
              color: textBlue,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Buat tantangan pertama untuk siswa di kelas ini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: mutedBlue,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showTambahTantangan,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Buat Tantangan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: royalBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTantanganCard(
    Map<String, dynamic> tantangan,
  ) {
    final soal =
        tantangan['soal'] as List<Map<String, dynamic>>;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: paleBlue,
        ),
        boxShadow: [
          BoxShadow(
            color: royalBlue.withValues(alpha: 0.06),
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: paleBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.flag_rounded,
                  color: royalBlue,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tantangan['judul'] ?? 'Tanpa Judul',
                  style: TextStyle(
                    color: textBlue,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'hapus') {
                    _hapusTantangan(tantangan);
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

          Text(
            tantangan['deskripsi'] ?? '',
            style: TextStyle(
              color: mutedBlue,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Icon(
                Icons.quiz_outlined,
                size: 18,
                color: royalBlue,
              ),
              const SizedBox(width: 7),
              Text(
                '${soal.length} soal',
                style: TextStyle(
                  color: textBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  _showKelolaSoal(tantangan);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: royalBlue,
                  side: BorderSide(
                    color: royalBlue,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Kelola Soal'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTambahTantangan() {
    final judulController = TextEditingController();
    final deskripsiController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Tambah Tantangan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: judulController,
                decoration: InputDecoration(
                  labelText: 'Judul Tantangan',
                  hintText: 'Contoh: Kuis Dasar Komputer',
                  prefixIcon: const Icon(
                    Icons.flag_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Jelaskan tantangan ini...',
                  prefixIcon: const Icon(
                    Icons.description_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final judul =
                    judulController.text.trim();
                final deskripsi =
                    deskripsiController.text.trim();

                if (judul.isEmpty ||
                    deskripsi.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Judul dan deskripsi harus diisi.',
                      ),
                    ),
                  );
                  return;
                }

                TantanganData.tambahTantangan(
                  kodeKelas: widget.kodeKelas,
                  judul: judul,
                  deskripsi: deskripsi,
                );

                Navigator.pop(dialogContext);

                setState(() {});

                ScaffoldMessenger.of(context)
                    .showSnackBar(
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
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _hapusTantangan(
    Map<String, dynamic> tantangan,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Hapus Tantangan?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Tantangan ini beserta soal di dalamnya akan dihapus.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                TantanganData.hapusTantangan(
                  tantangan,
                );

                Navigator.pop(dialogContext);

                setState(() {});

                ScaffoldMessenger.of(context)
                    .showSnackBar(
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
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _showKelolaSoal(
    Map<String, dynamic> tantangan,
  ) {
    final soal =
        tantangan['soal'] as List<Map<String, dynamic>>;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            tantangan['judul'] ?? 'Kelola Soal',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Jumlah soal saat ini: ${soal.length}',
                  style: TextStyle(
                    color: mutedBlue,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _showTambahSoal(tantangan);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Tambah Soal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTambahSoal(
    Map<String, dynamic> tantangan,
  ) {
    final pertanyaanController = TextEditingController();
    final pilihan1Controller = TextEditingController();
    final pilihan2Controller = TextEditingController();
    final pilihan3Controller = TextEditingController();
    final pilihan4Controller = TextEditingController();

    int jawabanBenar = 0;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: const Text(
                'Tambah Soal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: pertanyaanController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Pertanyaan',
                        hintText: 'Tulis pertanyaan...',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildPilihanField(
                      pilihan1Controller,
                      'Pilihan A',
                    ),
                    const SizedBox(height: 10),

                    _buildPilihanField(
                      pilihan2Controller,
                      'Pilihan B',
                    ),
                    const SizedBox(height: 10),

                    _buildPilihanField(
                      pilihan3Controller,
                      'Pilihan C',
                    ),
                    const SizedBox(height: 10),

                    _buildPilihanField(
                      pilihan4Controller,
                      'Pilihan D',
                    ),

                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Jawaban yang benar',
                        style: TextStyle(
                          color: textBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    RadioListTile<int>(
                      value: 0,
                      groupValue: jawabanBenar,
                      title: const Text('Pilihan A'),
                      onChanged: (value) {
                        setDialogState(() {
                          jawabanBenar = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      value: 1,
                      groupValue: jawabanBenar,
                      title: const Text('Pilihan B'),
                      onChanged: (value) {
                        setDialogState(() {
                          jawabanBenar = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      value: 2,
                      groupValue: jawabanBenar,
                      title: const Text('Pilihan C'),
                      onChanged: (value) {
                        setDialogState(() {
                          jawabanBenar = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      value: 3,
                      groupValue: jawabanBenar,
                      title: const Text('Pilihan D'),
                      onChanged: (value) {
                        setDialogState(() {
                          jawabanBenar = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final pertanyaan =
                        pertanyaanController.text.trim();

                    final pilihan = [
                      pilihan1Controller.text.trim(),
                      pilihan2Controller.text.trim(),
                      pilihan3Controller.text.trim(),
                      pilihan4Controller.text.trim(),
                    ];

                    if (pertanyaan.isEmpty ||
                        pilihan.any(
                          (item) => item.isEmpty,
                        )) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Pertanyaan dan semua pilihan harus diisi.',
                          ),
                        ),
                      );
                      return;
                    }

                    TantanganData.tambahSoal(
                      tantangan: tantangan,
                      pertanyaan: pertanyaan,
                      pilihan: pilihan,
                      jawabanBenar: jawabanBenar,
                    );

                    Navigator.pop(dialogContext);

                    setState(() {});

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Soal berhasil ditambahkan.',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Simpan Soal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPilihanField(
    TextEditingController controller,
    String label,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
