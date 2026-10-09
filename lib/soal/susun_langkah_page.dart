
import 'package:flutter/material.dart';
import '../data/tantangan_data.dart';

class SusunLangkahPage extends StatefulWidget {
  final Map<String, dynamic> tantangan;

  const SusunLangkahPage({
    super.key,
    required this.tantangan,
  });

  @override
  State<SusunLangkahPage> createState() =>
      _SusunLangkahPageState();
}

class _SusunLangkahPageState extends State<SusunLangkahPage> {
  final Color royalBlue = const Color(0xFF2166D5);
  final Color deepBlue = const Color(0xFF123B70);
  final Color paleBlue = const Color(0xFFDCEBFF);
  final Color textBlue = const Color(0xFF18365D);
  final Color mutedBlue = const Color(0xFF7288A8);

  final TextEditingController pertanyaanController =
      TextEditingController();

  final List<TextEditingController> langkahControllers =
      List.generate(4, (_) => TextEditingController());

  // Menyimpan pilihan langkah untuk urutan ke-1 sampai ke-4.
  final List<int?> urutanTerpilih = List<int?>.filled(4, null);

  @override
  void dispose() {
    pertanyaanController.dispose();

    for (final controller in langkahControllers) {
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
          'Susun Langkah',
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

            const SizedBox(height: 24),
            _buildSectionLabel('Pertanyaan'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: pertanyaanController,
              label: 'Pertanyaan',
              hint: 'Contoh: Susun langkah menyalakan komputer!',
              maxLines: 3,
            ),

            const SizedBox(height: 24),
            _buildSectionLabel('Daftar Langkah'),
            const SizedBox(height: 5),
            _buildDescription(
              'Masukkan empat langkah yang nantinya perlu diurutkan.',
            ),
            const SizedBox(height: 12),

            ...List.generate(
              4,
              (index) => _buildLangkahField(index),
            ),

            const SizedBox(height: 24),
            _buildSectionLabel('Urutan yang Benar'),
            const SizedBox(height: 5),
            _buildDescription(
              'Tentukan langkah yang harus dilakukan pada setiap urutan.',
            ),
            const SizedBox(height: 12),

            ...List.generate(
              4,
              (index) => _buildUrutanDropdown(index),
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
              Icons.format_list_numbered_rounded,
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
                  'Buat Soal Susun Langkah',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Latih siswa memahami urutan suatu proses.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    height: 1.5,
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
        height: 1.5,
      ),
    );
  }

  Widget _buildLangkahField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: paleBlue,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: royalBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildTextField(
              controller: langkahControllers[index],
              label: 'Langkah ${index + 1}',
              hint: 'Masukkan isi langkah',
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrutanDropdown(int index) {
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
          value: urutanTerpilih[index],
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Urutan ke-${index + 1}',
            border: InputBorder.none,
          ),
          hint: const Text('Pilih langkah'),
          items: List.generate(
            4,
            (langkahIndex) => DropdownMenuItem<int>(
              value: langkahIndex,
              child: Text('Langkah ${langkahIndex + 1}'),
            ),
          ),
          onChanged: (value) {
            setState(() {
              urutanTerpilih[index] = value;
            });
          },
        ),
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
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.all(15),
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

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _simpanSoal,
        style: ElevatedButton.styleFrom(
          backgroundColor: royalBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
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

    final langkah = langkahControllers
        .map((controller) => controller.text.trim())
        .toList();

    if (langkah.any((item) => item.isEmpty)) {
      _showError('Semua langkah harus diisi.');
      return;
    }

    if (urutanTerpilih.any((item) => item == null)) {
      _showError('Tentukan urutan untuk semua langkah.');
      return;
    }

    final indeksUrutan = urutanTerpilih
        .map((item) => item!)
        .toList();

    if (indeksUrutan.toSet().length != 4) {
      _showError(
        'Setiap langkah harus digunakan satu kali.',
      );
      return;
    }

    final urutanBenar = indeksUrutan
        .map((index) => langkah[index])
        .toList();

    TantanganData.tambahSoalSusunLangkah(
      tantangan: widget.tantangan,
      pertanyaan: pertanyaan,
      langkah: langkah,
      urutanBenar: urutanBenar,
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
