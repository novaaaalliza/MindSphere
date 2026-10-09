
import 'package:flutter/material.dart';
import '../data/tantangan_data.dart';

class IdentifikasiGambarPage extends StatefulWidget {
  final Map<String, dynamic> tantangan;

  const IdentifikasiGambarPage({
    super.key,
    required this.tantangan,
  });

  @override
  State<IdentifikasiGambarPage> createState() =>
      _IdentifikasiGambarPageState();
}

class _IdentifikasiGambarPageState
    extends State<IdentifikasiGambarPage> {
  final Color royalBlue = const Color(0xFF2166D5);
  final Color deepBlue = const Color(0xFF123B70);
  final Color paleBlue = const Color(0xFFDCEBFF);
  final Color textBlue = const Color(0xFF18365D);
  final Color mutedBlue = const Color(0xFF7288A8);

  final TextEditingController pertanyaanController =
      TextEditingController();

  final TextEditingController gambarController =
      TextEditingController();

  final List<TextEditingController> pilihanControllers =
      List.generate(4, (_) => TextEditingController());

  int jawabanBenar = 0;

  bool get urlGambarValid {
    final uri = Uri.tryParse(gambarController.text.trim());

    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }

  @override
  void dispose() {
    pertanyaanController.dispose();
    gambarController.dispose();

    for (final controller in pilihanControllers) {
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
          'Identifikasi Gambar',
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
              hint: 'Contoh: Perangkat apakah yang terlihat?',
              maxLines: 3,
            ),

            const SizedBox(height: 22),
            _buildSectionLabel('Gambar Soal'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: gambarController,
              label: 'URL Gambar',
              hint: 'Tempelkan alamat gambar (https://...)',
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            _buildPreview(),

            const SizedBox(height: 22),
            _buildSectionLabel('Pilihan Jawaban'),
            const SizedBox(height: 8),

            ...List.generate(
              4,
              (index) => _buildPilihanField(index),
            ),

            const SizedBox(height: 22),
            _buildSectionLabel('Jawaban Benar'),
            const SizedBox(height: 8),
            _buildJawabanBenar(),

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
          colors: [royalBlue, const Color(0xFF56B4F8)],
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
              Icons.image_search_rounded,
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
                  'Buat Soal Identifikasi Gambar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Gunakan gambar sebagai petunjuk untuk menjawab soal.',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
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

  Widget _buildPreview() {
    if (gambarController.text.trim().isEmpty) {
      return Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: paleBlue.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: paleBlue),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 42,
              color: royalBlue,
            ),
            const SizedBox(height: 8),
            Text(
              'Pratinjau gambar akan tampil di sini',
              style: TextStyle(
                color: mutedBlue,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (!urlGambarValid) {
      return _previewMessage(
        Icons.link_off_rounded,
        'Masukkan URL gambar yang valid.',
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 220,
        color: paleBlue,
        child: Image.network(
          gambarController.text.trim(),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _previewMessage(
              Icons.broken_image_outlined,
              'Gambar tidak dapat dimuat. Periksa kembali URL-nya.',
            );
          },
        ),
      ),
    );
  }

  Widget _previewMessage(IconData icon, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: paleBlue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: royalBlue, size: 32),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: textBlue, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPilihanField(int index) {
    final huruf = String.fromCharCode(65 + index);

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
              huruf,
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
              controller: pilihanControllers[index],
              label: 'Pilihan $huruf',
              hint: 'Masukkan pilihan jawaban',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJawabanBenar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE1EAF6),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: jawabanBenar,
          isExpanded: true,
          items: List.generate(4, (index) {
            final huruf = String.fromCharCode(65 + index);

            return DropdownMenuItem<int>(
              value: index,
              child: Text('Pilihan $huruf'),
            );
          }),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                jawabanBenar = value;
              });
            }
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
    final gambar = gambarController.text.trim();

    if (pertanyaan.isEmpty) {
      _showError('Pertanyaan belum diisi.');
      return;
    }

    if (!urlGambarValid) {
      _showError('Masukkan URL gambar yang valid.');
      return;
    }

    final pilihan = pilihanControllers
        .map((controller) => controller.text.trim())
        .toList();

    if (pilihan.any((item) => item.isEmpty)) {
      _showError('Semua pilihan jawaban harus diisi.');
      return;
    }

    TantanganData.tambahSoalIdentifikasiGambar(
      tantangan: widget.tantangan,
      pertanyaan: pertanyaan,
      gambar: gambar,
      pilihan: pilihan,
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
