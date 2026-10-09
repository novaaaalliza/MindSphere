
import 'package:flutter/material.dart';
import '../data/tantangan_data.dart';

class JawabanSingkatPage extends StatefulWidget {
  final Map<String, dynamic> tantangan;

  const JawabanSingkatPage({
    super.key,
    required this.tantangan,
  });

  @override
  State<JawabanSingkatPage> createState() =>
      _JawabanSingkatPageState();
}

class _JawabanSingkatPageState
    extends State<JawabanSingkatPage> {
  final Color royalBlue = const Color(0xFF2166D5);
  final Color deepBlue = const Color(0xFF123B70);
  final Color textBlue = const Color(0xFF18365D);
  final Color mutedBlue = const Color(0xFF7288A8);

  final TextEditingController pertanyaanController =
      TextEditingController();

  final TextEditingController jawabanController =
      TextEditingController();

  final TextEditingController petunjukController =
      TextEditingController();

  @override
  void dispose() {
    pertanyaanController.dispose();
    jawabanController.dispose();
    petunjukController.dispose();
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
          'Jawaban Singkat',
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
              hint: 'Contoh: Apa kepanjangan dari CPU?',
              maxLines: 4,
            ),

            const SizedBox(height: 22),
            _buildSectionLabel('Petunjuk (Opsional)'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: petunjukController,
              label: 'Petunjuk',
              hint: 'Berikan petunjuk jika diperlukan',
              maxLines: 2,
            ),

            const SizedBox(height: 22),
            _buildSectionLabel('Kunci Jawaban'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: jawabanController,
              label: 'Jawaban Benar',
              hint: 'Masukkan jawaban yang diharapkan',
              maxLines: 2,
            ),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFDCEBFF),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: royalBlue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tuliskan kunci jawaban dengan jelas. '
                      'Pemeriksaan otomatis untuk variasi penulisan '
                      'jawaban siswa akan kita buat pada tahap berikutnya.',
                      style: TextStyle(
                        color: textBlue,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
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
      padding: const EdgeInsets.all(20),
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
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.short_text_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buat Soal Jawaban Singkat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Ajak siswa menjawab dengan pemahaman mereka sendiri.',
                  style: TextStyle(
                    color: Colors.white,
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
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE1EAF6),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE1EAF6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
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
    final jawabanBenar = jawabanController.text.trim();

    if (pertanyaan.isEmpty) {
      _showError('Pertanyaan belum diisi.');
      return;
    }

    if (jawabanBenar.isEmpty) {
      _showError('Kunci jawaban belum diisi.');
      return;
    }

    TantanganData.tambahSoalJawabanSingkat(
      tantangan: widget.tantangan,
      pertanyaan: pertanyaan,
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
