
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'hasil_tantangan_page.dart';

class KerjakanTantanganPage extends StatefulWidget {
  final Map<String, dynamic> tantangan;
  final String namaKelas;
  final String kodeKelas;

  const KerjakanTantanganPage({
    super.key,
    required this.tantangan,
    required this.namaKelas,
    required this.kodeKelas,
  });

  @override
  State<KerjakanTantanganPage> createState() =>
      _KerjakanTantanganPageState();
}

class _KerjakanTantanganPageState
    extends State<KerjakanTantanganPage> {
  int nomorSoal = 0;

  final Map<int, dynamic> jawabanSiswa = {};

  bool sudahSubmit = false;
  bool sedangMenyimpan = false;

  static const Color royalBlue = Color(0xFF2166D5);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  String get idTantangan {
    return widget.tantangan['id']?.toString() ??
        widget.tantangan['idTantangan']?.toString() ??
        '';
  }

  String get judulTantangan {
    return widget.tantangan['judul']?.toString() ??
        'Tantangan';
  }

  List<Map<String, dynamic>> get daftarSoal {
    final soal = widget.tantangan['soal'];

    if (soal is! List) return [];

    return soal
        .where((item) => item is Map)
        .map(
          (item) => Map<String, dynamic>.from(item as Map),
        )
        .toList();
  }

  Map<String, dynamic>? get soalSekarang {
    if (daftarSoal.isEmpty) return null;

    return daftarSoal[nomorSoal];
  }

  @override
  Widget build(BuildContext context) {
    if (daftarSoal.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tantangan'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Tantangan ini belum memiliki soal.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final soal = soalSekarang!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: Text(judulTantangan),
        backgroundColor: royalBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressAtas(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNomorSoal(),
                    const SizedBox(height: 14),
                    _buildPertanyaan(soal),
                    const SizedBox(height: 20),
                    _buildJawaban(soal),
                  ],
                ),
              ),
            ),
            _buildTombolNavigasi(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressAtas() {
    final total = daftarSoal.length;
    final progress = (nomorSoal + 1) / total;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Soal ${nomorSoal + 1} dari $total',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: textBlue,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: royalBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: paleBlue,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(royalBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNomorSoal() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: paleBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Pertanyaan ${nomorSoal + 1}',
        style: const TextStyle(
          color: royalBlue,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildPertanyaan(Map<String, dynamic> soal) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        soal['pertanyaan']?.toString() ??
            'Pertanyaan belum tersedia.',
        style: const TextStyle(
          fontSize: 18,
          height: 1.5,
          fontWeight: FontWeight.w700,
          color: textBlue,
        ),
      ),
    );
  }

  Widget _buildJawaban(Map<String, dynamic> soal) {
    final tipe = soal['tipe']?.toString() ?? '';

    switch (tipe) {
      case 'Pilihan Ganda':
        return _buildPilihanGanda(soal);

      case 'Benar / Salah':
        return _buildBenarSalah();

      case 'Pilihan Ganda Kompleks':
        return _buildPilihanGandaKompleks(soal);

      case 'Isian Singkat':
        return _buildIsianSingkat();

      case 'Menjodohkan':
        return _buildMenjodohkan();

      default:
        return const Text('Tipe soal belum dikenali.');
    }
  }

  Widget _buildPilihanGanda(Map<String, dynamic> soal) {
    final pilihan = ['A', 'B', 'C', 'D'];

    return Column(
      children: pilihan.map((huruf) {
        final teks =
            soal['pilihan$huruf']?.toString() ?? '';

        if (teks.isEmpty) {
          return const SizedBox.shrink();
        }

        final selected = jawabanSiswa[nomorSoal] == huruf;

        return _buildOptionCard(
          selected: selected,
          onTap: () {
            setState(() {
              jawabanSiswa[nomorSoal] = huruf;
            });
          },
          child: Row(
            children: [
              _buildLingkaranHuruf(huruf),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  teks,
                  style: const TextStyle(
                    fontSize: 15,
                    color: textBlue,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBenarSalah() {
    final pilihan = ['Benar', 'Salah'];

    return Column(
      children: pilihan.map((jawaban) {
        final selected = jawabanSiswa[nomorSoal] == jawaban;

        return _buildOptionCard(
          selected: selected,
          onTap: () {
            setState(() {
              jawabanSiswa[nomorSoal] = jawaban;
            });
          },
          child: Row(
            children: [
              Icon(
                jawaban == 'Benar'
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                color: royalBlue,
              ),
              const SizedBox(width: 14),
              Text(
                jawaban,
                style: const TextStyle(
                  fontSize: 15,
                  color: textBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPilihanGandaKompleks(
    Map<String, dynamic> soal,
  ) {
    final pilihan = ['A', 'B', 'C', 'D'];

    final jawabanSekarang =
        (jawabanSiswa[nomorSoal] as List?)?.cast<String>() ??
            [];

    return Column(
      children: pilihan.map((huruf) {
        final teks =
            soal['pilihan$huruf']?.toString() ?? '';

        if (teks.isEmpty) {
          return const SizedBox.shrink();
        }

        final selected = jawabanSekarang.contains(huruf);

        return _buildOptionCard(
          selected: selected,
          onTap: () => _ubahJawabanKompleks(huruf),
          child: Row(
            children: [
              Checkbox(
                value: selected,
                activeColor: royalBlue,
                onChanged: (_) =>
                    _ubahJawabanKompleks(huruf),
              ),
              const SizedBox(width: 6),
              _buildLingkaranHuruf(huruf),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  teks,
                  style: const TextStyle(
                    fontSize: 15,
                    color: textBlue,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _ubahJawabanKompleks(String huruf) {
    final List<String> jawaban =
        List<String>.from(
      (jawabanSiswa[nomorSoal] as List?) ?? [],
    );

    if (jawaban.contains(huruf)) {
      jawaban.remove(huruf);
    } else {
      jawaban.add(huruf);
    }

    setState(() {
      jawabanSiswa[nomorSoal] = jawaban;
    });
  }

  Widget _buildIsianSingkat() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextFormField(
        key: ValueKey('isian_$nomorSoal'),
        initialValue:
            jawabanSiswa[nomorSoal]?.toString() ?? '',
        maxLines: 3,
        onChanged: (value) {
          jawabanSiswa[nomorSoal] = value;
        },
        decoration: InputDecoration(
          hintText: 'Tulis jawaban kamu di sini...',
          filled: true,
          fillColor: const Color(0xFFF5F9FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildMenjodohkan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Masukkan pasangan jawaban yang sesuai.',
            style: TextStyle(color: mutedBlue),
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: ValueKey('jodohkan_$nomorSoal'),
            initialValue:
                jawabanSiswa[nomorSoal]?.toString() ?? '',
            onChanged: (value) {
              jawabanSiswa[nomorSoal] = value;
            },
            decoration: InputDecoration(
              hintText: 'Contoh: A-1, B-2, C-3',
              filled: true,
              fillColor: const Color(0xFFF5F9FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required bool selected,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? paleBlue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? royalBlue
                : const Color(0xFFE2EAF5),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildLingkaranHuruf(String huruf) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: royalBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        huruf,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTombolNavigasi() {
    final soalTerakhir =
        nomorSoal == daftarSoal.length - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      color: Colors.white,
      child: Row(
        children: [
          if (nomorSoal > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: sedangMenyimpan
                    ? null
                    : () {
                        setState(() {
                          nomorSoal--;
                        });
                      },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 52),
                  side: const BorderSide(color: royalBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Sebelumnya'),
              ),
            ),
          if (nomorSoal > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: sedangMenyimpan
                  ? null
                  : soalTerakhir
                      ? _konfirmasiSelesai
                      : () {
                          setState(() {
                            nomorSoal++;
                          });
                        },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: sedangMenyimpan
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      soalTerakhir ? 'Selesai' : 'Berikutnya',
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _jawabanKosong(dynamic jawaban) {
    if (jawaban == null) return true;

    if (jawaban is String) {
      return jawaban.trim().isEmpty;
    }

    if (jawaban is List) {
      return jawaban.isEmpty;
    }

    return jawaban.toString().trim().isEmpty;
  }

  Future<void> _konfirmasiSelesai() async {
    if (sedangMenyimpan || sudahSubmit) return;

    if (idTantangan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ID tantangan tidak ditemukan. Silakan kembali dan buka tantangan dari daftar kelas.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final belumDijawab =
        daftarSoal.asMap().entries.where((entry) {
      return _jawabanKosong(jawabanSiswa[entry.key]);
    }).length;

    if (belumDijawab > 0) {
      final lanjut = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Masih ada soal'),
            content: Text(
              'Masih ada $belumDijawab soal yang belum dijawab. '
              'Apakah kamu tetap ingin menyelesaikan tantangan?',
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, false),
                child: const Text('Kembali'),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pop(context, true),
                child: const Text('Selesaikan'),
              ),
            ],
          );
        },
      );

      if (lanjut != true) return;
    }

    await _simpanHasil();
  }

  Future<String> _ambilNamaSiswa(User user) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = snapshot.data();

      final nama = data?['nama']?.toString() ??
          data?['namaLengkap']?.toString() ??
          data?['name']?.toString() ??
          user.displayName ??
          '';

      if (nama.trim().isNotEmpty) {
        return nama.trim();
      }
    } catch (e) {
      debugPrint('Gagal mengambil nama siswa: $e');
    }

    return user.email ?? 'Siswa';
  }

  Future<void> _simpanHasil() async {
    if (sudahSubmit || sedangMenyimpan) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (idTantangan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID tantangan tidak ditemukan.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      sedangMenyimpan = true;
    });

    try {
      // Pastikan dokumen tantangan masih tersedia.
      final tantanganDoc = await FirebaseFirestore.instance
          .collection('tantangan')
          .doc(idTantangan)
          .get();

      if (!tantanganDoc.exists) {
        throw Exception(
          'Data tantangan tidak ditemukan di Firestore.',
        );
      }

      int benar = 0;

      for (int i = 0; i < daftarSoal.length; i++) {
        final soal = daftarSoal[i];

        final jawabanBenar = soal['jawaban'];
        final jawabanUser = jawabanSiswa[i];
        final tipe = soal['tipe']?.toString() ?? '';

        if (_jawabanBenar(
          jawabanUser,
          jawabanBenar,
          tipe,
        )) {
          benar++;
        }
      }

      final totalSoal = daftarSoal.length;
      final salah = totalSoal - benar;

      final nilai = totalSoal == 0
          ? 0
          : ((benar / totalSoal) * 100).round();

      final namaSiswa = await _ambilNamaSiswa(user);

      final Map<String, dynamic> jawabanUntukFirestore = {};

      jawabanSiswa.forEach((key, value) {
        jawabanUntukFirestore[key.toString()] = value;
      });

      final hasilBaru = <String, dynamic>{
        'uid': user.uid,
        'namaSiswa': namaSiswa,
        'namaKelas': widget.namaKelas,
        'kodeKelas': widget.kodeKelas,
        'idTantangan': idTantangan,
        'judulTantangan': judulTantangan,
        'jawaban': jawabanUntukFirestore,
        'nilai': nilai,
        'benar': benar,
        'salah': salah,
        'totalSoal': totalSoal,
        'tanggal': _tanggalSekarang(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Setiap pengerjaan menjadi satu dokumen hasil.
      final hasilRef = await FirebaseFirestore.instance
          .collection('hasil_tantangan')
          .add(hasilBaru);

      if (!mounted) return;

      setState(() {
        sudahSubmit = true;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HasilTantanganPage(
            namaKelas: widget.namaKelas,
            kodeKelas: widget.kodeKelas,
            judulTantangan: judulTantangan,
            nilai: nilai,
            benar: benar,
            salah: salah,
            totalSoal: totalSoal,
          ),
        ),
      );

      debugPrint('Hasil tersimpan dengan ID: ${hasilRef.id}');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan hasil tantangan: $e',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          sedangMenyimpan = false;
        });
      }
    }
  }

  List<String> _normalisasiJawabanKompleks(dynamic jawaban) {
    if (jawaban is List) {
      return jawaban
          .map((item) => item.toString().trim().toUpperCase())
          .where((item) => item.isNotEmpty)
          .toList()
        ..sort();
    }

    if (jawaban is String) {
      return jawaban
          .split(RegExp(r'[,;]'))
          .map((item) => item.trim().toUpperCase())
          .where((item) => item.isNotEmpty)
          .toList()
        ..sort();
    }

    return [];
  }

  bool _jawabanBenar(
    dynamic jawabanUser,
    dynamic jawabanBenar,
    String tipe,
  ) {
    if (jawabanUser == null || jawabanBenar == null) {
      return false;
    }

    if (tipe == 'Pilihan Ganda Kompleks') {
      final userList =
          _normalisasiJawabanKompleks(jawabanUser);
      final benarList =
          _normalisasiJawabanKompleks(jawabanBenar);

      if (userList.isEmpty || benarList.isEmpty) {
        return false;
      }

      return userList.join(',') == benarList.join(',');
    }

    final user = jawabanUser
        .toString()
        .trim()
        .toLowerCase();

    final benar = jawabanBenar
        .toString()
        .trim()
        .toLowerCase();

    return user == benar;
  }

  String _tanggalSekarang() {
    final now = DateTime.now();

    final hari = now.day.toString().padLeft(2, '0');
    final bulan = now.month.toString().padLeft(2, '0');
    final tahun = now.year.toString();

    return '$hari/$bulan/$tahun';
  }
}
