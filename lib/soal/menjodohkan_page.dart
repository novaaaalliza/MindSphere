
import 'package:flutter/material.dart';
import '../data/tantangan_data.dart';

class MenjodohkanPage extends StatefulWidget {
  final Map<String, dynamic> tantangan;

  const MenjodohkanPage({
    super.key,
    required this.tantangan,
  });

  @override
  State<MenjodohkanPage> createState() =>
      _MenjodohkanPageState();
}

class _MenjodohkanPageState
    extends State<MenjodohkanPage> {
  final Color royalBlue = const Color(0xFF2166D5);
  final Color deepBlue = const Color(0xFF123B70);
  final Color paleBlue = const Color(0xFFDCEBFF);
  final Color textBlue = const Color(0xFF18365D);
  final Color mutedBlue = const Color(0xFF7288A8);

  final TextEditingController pertanyaanController =
      TextEditingController();

  final List<TextEditingController> kiriControllers =
      List.generate(4, (_) => TextEditingController());

  final List<TextEditingController> kananControllers =
      List.generate(4, (_) => TextEditingController());

  // Setiap angka menunjukkan pasangan di bagian kanan.
  // Contoh: [2, 0, 3, 1] berarti kiri 1 dipasangkan
  // dengan kanan 3, kiri 2 dengan kanan 1, dan seterusnya.
  final List<int?> pasanganTerpilih = List<int?>.filled(4, null);

  @override
  void dispose() {
    pertanyaanController.dispose();

    for (final controller in kiriControllers) {
      controller.dispose();
    }

    for (final controller in kananControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: textBlue),
        title: Text(
          'Soal Menjodohkan',
          style: TextStyle(
            color: deepBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 22),

            _buildSectionLabel('Pertanyaan'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: pertanyaanController,
              label: 'Pertanyaan',
              hint: 'Masukkan instruksi menjodohkan',
              maxLines: 3,
            ),

            const SizedBox(height: 22),
            _buildSectionLabel('Bagian Kiri'),
            const SizedBox(height: 5),
            _buildDescription(
              'Masukkan empat istilah atau pernyataan.',
            ),
            const SizedBox(height: 10),

            ...List.generate(
              4,
              (index) => _buildItemField(
                controller: kiriControllers[index],
                index: index,
                label: 'Bagian Kiri',
              ),
            ),

            const SizedBox(height: 14),
            _buildSectionLabel('Bagian Kanan'),
            const SizedBox(height: 5),
            _buildDescription(
              'Masukkan empat pasangan jawabannya.',
            ),
            const SizedBox(height: 10),

            ...List.generate(
              4,
              (index) => _buildItemField(
                controller: kananControllers[index],
                index: index,
                label: 'Bagian Kanan',
              ),
            ),

            const SizedBox(height: 22),
            _buildSectionLabel('Pasangan Jawaban Benar'),
            const SizedBox(height: 5),
            _buildDescription(
              'Pilih pasangan yang tepat untuk setiap bagian kiri.',
            ),
            const SizedBox(height: 10),

            ...List.generate(
              4,
              (index) => _buildPairDropdown(index),
            ),

            const SizedBox(height: 28),
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            royalBlue,
            const Color(0xFF56B4F8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.compare_arrows_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buat Soal Menjodohkan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Hubungkan istilah dengan pasangan jawaban yang sesuai.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: textBlue,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Text(
      text,
      style: TextStyle(
        color: mutedBlue,
        fontSize: 12,
      ),
    );
  }

  Widget _buildItemField({
    required TextEditingController controller,
    required int index,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _buildTextField(
        controller: controller,
        label: '$label ${index + 1}',
        hint: 'Masukkan isi bagian ${index + 1}',
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: mutedBlue),
        hintStyle: TextStyle(
          color: mutedBlue.withOpacity(0.7),
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFE1EAF6),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFE1EAF6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: royalBlue,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPairDropdown(int index) {
    final huruf = String.fromCharCode(65 + index);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE1EAF6),
          ),
        ),
        child: DropdownButtonFormField<int>(
          value: pasanganTerpilih[index],
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Pasangan untuk bagian kiri $huruf',
            border: InputBorder.none,
          ),
          hint: const Text('Pilih bagian kanan'),
          items: List.generate(
            4,
            (rightIndex) => DropdownMenuItem<int>(
              value: rightIndex,
              child: Text(
                'Bagian Kanan ${rightIndex + 1}',
                style: TextStyle(color: textBlue),
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              pasanganTerpilih[index] = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _simpanSoal,
        style: ElevatedButton.styleFrom(
          backgroundColor: royalBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.save_outlined),
        label: const Text(
          'Simpan Soal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _simpanSoal() {
    final pertanyaan = pertanyaanController.text.trim();

    if (pertanyaan.isEmpty) {
      _showError('Pertanyaan belum diisi.');
      return;
    }

    final bagianKiri = kiriControllers
        .map((controller) => controller.text.trim())
        .toList();

    final bagianKanan = kananControllers
        .map((controller) => controller.text.trim())
        .toList();

    if (bagianKiri.any((item) => item.isEmpty)) {
      _showError('Semua bagian kiri harus diisi.');
      return;
    }

    if (bagianKanan.any((item) => item.isEmpty)) {
      _showError('Semua bagian kanan harus diisi.');
      return;
    }

    if (pasanganTerpilih.any((item) => item == null)) {
      _showError('Tentukan pasangan untuk setiap bagian kiri.');
      return;
    }

    final jawabanBenar = pasanganTerpilih
        .map((item) => item!)
        .toList();

    if (jawabanBenar.toSet().length != 4) {
      _showError(
        'Setiap bagian kanan harus memiliki satu pasangan.',
      );
      return;
    }

    TantanganData.tambahSoalMenjodohkan(
      tantangan: widget.tantangan,
      pertanyaan: pertanyaan,
      bagianKiri: bagianKiri,
      bagianKanan: bagianKanan,
      jawabanBenar: jawabanBenar,
    );

    Navigator.pop(context, true);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade600,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
