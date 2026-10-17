import 'package:flutter/material.dart';

import 'data_global.dart';
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

class _KerjakanTantanganPageState extends State<KerjakanTantanganPage> {
  int nomorSoal = 0;

  final Map<int, dynamic> jawabanSiswa = {};

  bool sudahSubmit = false;

  List<Map<String, dynamic>> get daftarSoal {
    final soal = widget.tantangan['soal'];

    if (soal is List) {
      return soal
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }

    return [];
  }

  Map<String, dynamic>? get soalSekarang {
    if (daftarSoal.isEmpty) {
      return null;
    }

    if (nomorSoal >= daftarSoal.length) {
      return daftarSoal.last;
    }

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
        title: Text(
          widget.tantangan['judul']?.toString() ?? 'Tantangan',
        ),
        backgroundColor: const Color(0xFF2166D5),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressAtas(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
                  color: Color(0xFF18365D),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2166D5),
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
              backgroundColor: const Color(0xFFDCEBFF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF2166D5),
              ),
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
        color: const Color(0xFFDCEBFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Pertanyaan ${nomorSoal + 1}',
        style: const TextStyle(
          color: Color(0xFF2166D5),
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
        soal['pertanyaan']?.toString() ?? 'Pertanyaan belum tersedia.',
        style: const TextStyle(
          fontSize: 18,
          height: 1.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF18365D),
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
        return _buildBenarSalah(soal);

      case 'Pilihan Ganda Kompleks':
        return _buildPilihanGandaKompleks(soal);

      case 'Isian Singkat':
        return _buildIsianSingkat(soal);

      case 'Menjodohkan':
        return _buildMenjodohkan(soal);

      default:
        return const Text(
          'Tipe soal belum dikenali.',
        );
    }
  }

  Widget _buildPilihanGanda(Map<String, dynamic> soal) {
    final pilihan = [
      'A',
      'B',
      'C',
      'D',
    ];

    return Column(
      children: pilihan.map((huruf) {
        final teks = soal['pilihan$huruf']?.toString() ?? '';
        final selected = jawabanSiswa[nomorSoal] == huruf;

        if (teks.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildOptionCard(
          selected: selected,
          child: Row(
            children: [
              _buildLingkaranHuruf(huruf),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  teks,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF18365D),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              jawabanSiswa[nomorSoal] = huruf;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildBenarSalah(Map<String, dynamic> soal) {
    final pilihan = ['Benar', 'Salah'];

    return Column(
      children: pilihan.map((jawaban) {
        final selected = jawabanSiswa[nomorSoal] == jawaban;

        return _buildOptionCard(
          selected: selected,
          child: Row(
            children: [
              Icon(
                jawaban == 'Benar'
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                color: const Color(0xFF2166D5),
              ),
              const SizedBox(width: 14),
              Text(
                jawaban,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF18365D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              jawabanSiswa[nomorSoal] = jawaban;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPilihanGandaKompleks(Map<String, dynamic> soal) {
    final pilihan = [
      'A',
      'B',
      'C',
      'D',
    ];

    final jawabanSekarang =
        (jawabanSiswa[nomorSoal] as List?)?.cast<String>() ?? [];

    return Column(
      children: pilihan.map((huruf) {
        final teks = soal['pilihan$huruf']?.toString() ?? '';

        if (teks.isEmpty) {
          return const SizedBox.shrink();
        }

        final selected = jawabanSekarang.contains(huruf);

        return _buildOptionCard(
          selected: selected,
          child: Row(
            children: [
              Checkbox(
                value: selected,
                activeColor: const Color(0xFF2166D5),
                onChanged: (_) {
                  _ubahJawabanKompleks(huruf);
                },
              ),
              const SizedBox(width: 6),
              _buildLingkaranHuruf(huruf),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  teks,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF18365D),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            _ubahJawabanKompleks(huruf);
          },
        );
      }).toList(),
    );
  }

  void _ubahJawabanKompleks(String huruf) {
    final List<String> jawaban =
        (jawabanSiswa[nomorSoal] as List?)?.cast<String>() ?? [];

    if (jawaban.contains(huruf)) {
      jawaban.remove(huruf);
    } else {
      jawaban.add(huruf);
    }

    setState(() {
      jawabanSiswa[nomorSoal] = jawaban;
    });
  }

  Widget _buildIsianSingkat(Map<String, dynamic> soal) {
    final controller = TextEditingController(
      text: jawabanSiswa[nomorSoal]?.toString() ?? '',
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
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

  Widget _buildMenjodohkan(Map<String, dynamic> soal) {
    final jawaban = jawabanSiswa[nomorSoal];

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
            style: TextStyle(
              color: Color(0xFF7288A8),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(
              text: jawaban?.toString() ?? '',
            ),
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
          color: selected
              ? const Color(0xFFDCEBFF)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFF2166D5)
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
        color: const Color(0xFF2166D5),
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
    final soalTerakhir = nomorSoal == daftarSoal.length - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      color: Colors.white,
      child: Row(
        children: [
          if (nomorSoal > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    nomorSoal--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 52),
                  side: const BorderSide(
                    color: Color(0xFF2166D5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Sebelumnya'),
              ),
            ),
          if (nomorSoal > 0)
            const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: soalTerakhir
                  ? _konfirmasiSelesai
                  : () {
                      setState(() {
                        nomorSoal++;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2166D5),
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                soalTerakhir ? 'Selesai' : 'Berikutnya',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _konfirmasiSelesai() async {
    final belumDijawab = daftarSoal.asMap().entries.where((entry) {
      return !jawabanSiswa.containsKey(entry.key) ||
          jawabanSiswa[entry.key] == null ||
          jawabanSiswa[entry.key].toString().trim().isEmpty;
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
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Kembali'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Selesaikan'),
              ),
            ],
          );
        },
      );

      if (lanjut != true) {
        return;
      }
    }

    _simpanHasil();
  }

  void _simpanHasil() {
    if (sudahSubmit) {
      return;
    }

    sudahSubmit = true;

    int benar = 0;

    for (int i = 0; i < daftarSoal.length; i++) {
      final soal = daftarSoal[i];
      final jawabanBenar = soal['jawaban'];
      final jawabanUser = jawabanSiswa[i];

      if (_jawabanBenar(
        jawabanUser,
        jawabanBenar,
        soal['tipe']?.toString() ?? '',
      )) {
        benar++;
      }
    }

    final totalSoal = daftarSoal.length;
    final salah = totalSoal - benar;

    final nilai = totalSoal == 0
        ? 0
        : ((benar / totalSoal) * 100).round();

    final hasilBaru = <String, dynamic>{
      'namaKelas': widget.namaKelas,
      'kodeKelas': widget.kodeKelas,
      'namaSiswa': namaSiswaAktif,
      'judulTantangan':
          widget.tantangan['judul']?.toString() ?? 'Tantangan',
      'nilai': nilai,
      'benar': benar,
      'salah': salah,
      'totalSoal': totalSoal,
      'tanggal': _tanggalSekarang(),
    };

    daftarHasilGlobal.add(hasilBaru);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HasilTantanganPage(
          namaKelas: widget.namaKelas,
          kodeKelas: widget.kodeKelas,
          judulTantangan:
              widget.tantangan['judul']?.toString() ?? 'Tantangan',
          nilai: nilai,
          benar: benar,
          salah: salah,
          totalSoal: totalSoal,
        ),
      ),
    );
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
          (jawabanUser as List?)?.map((e) => e.toString()).toList() ?? [];

      final benarList = jawabanBenar is List
          ? jawabanBenar.map((e) => e.toString()).toList()
          : [jawabanBenar.toString()];

      userList.sort();
      benarList.sort();

      return userList.join(',') == benarList.join(',');
    }

    return jawabanUser
            .toString()
            .trim()
            .toLowerCase() ==
        jawabanBenar
            .toString()
            .trim()
            .toLowerCase();
  }

  String _tanggalSekarang() {
    final now = DateTime.now();

    final hari = now.day.toString().padLeft(2, '0');
    final bulan = now.month.toString().padLeft(2, '0');
    final tahun = now.year.toString();

    return '$hari/$bulan/$tahun';
  }
}