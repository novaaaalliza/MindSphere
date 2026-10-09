import 'package:flutter/material.dart';
import '../data/tantangan_data.dart';

class PilihanGandaPage extends StatefulWidget {
  final Map<String, dynamic> tantangan;

  const PilihanGandaPage({
    super.key,
    required this.tantangan,
  });

  @override
  State<PilihanGandaPage> createState() =>
      _PilihanGandaPageState();
}

class _PilihanGandaPageState
    extends State<PilihanGandaPage> {
  final Color royalBlue =
      const Color(0xFF2166D5);

  final Color deepBlue =
      const Color(0xFF123B70);

  final Color paleBlue =
      const Color(0xFFDCEBFF);

  final Color textBlue =
      const Color(0xFF18365D);

  final Color mutedBlue =
      const Color(0xFF7288A8);

  final TextEditingController pertanyaanController =
      TextEditingController();

  final List<TextEditingController>
      pilihanControllers =
      List.generate(
    4,
    (index) => TextEditingController(),
  );

  int jawabanBenar = 0;

  @override
  void dispose() {
    pertanyaanController.dispose();

    for (final controller
        in pilihanControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textBlue,
          ),
        ),
        title: Text(
          'Pilihan Ganda',
          style: TextStyle(
            color: deepBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const SizedBox(height: 22),

            _buildSectionLabel(
              'Pertanyaan',
            ),

            const SizedBox(height: 8),

            _buildTextField(
              controller:
                  pertanyaanController,
              label: 'Pertanyaan',
              hint:
                  'Masukkan pertanyaan untuk siswa',
              maxLines: 4,
            ),

            const SizedBox(height: 22),

            _buildSectionLabel(
              'Pilihan Jawaban',
            ),

            const SizedBox(height: 8),

            ...List.generate(
              4,
              (index) =>
                  _buildPilihanField(index),
            ),

            const SizedBox(height: 22),

            _buildSectionLabel(
              'Jawaban Benar',
            ),

            const SizedBox(height: 8),

            _buildJawabanBenar(),

            const SizedBox(height: 28),

            _buildSimpanButton(),
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
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white
                  .withOpacity(0.18),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons
                  .check_circle_outline_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buat Soal Pilihan Ganda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Tambahkan pertanyaan dan empat pilihan jawaban.',
                  style: TextStyle(
                    color: Colors.white
                        .withOpacity(0.9),
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

  Widget _buildPilihanField(
    int index,
  ) {
    final huruf =
        String.fromCharCode(
      65 + index,
    );

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: paleBlue,
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: Text(
              huruf,
              style: TextStyle(
                color: royalBlue,
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _buildTextField(
              controller:
                  pilihanControllers[index],
              label: 'Pilihan $huruf',
              hint:
                  'Masukkan pilihan jawaban',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJawabanBenar() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              const Color(0xFFE1EAF6),
        ),
      ),
      child:
          DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: jawabanBenar,
          isExpanded: true,
          icon: Icon(
            Icons
                .keyboard_arrow_down_rounded,
            color: royalBlue,
          ),
          items: List.generate(
            4,
            (index) {
              final huruf =
                  String.fromCharCode(
                65 + index,
              );

              return DropdownMenuItem<int>(
                value: index,
                child: Text(
                  'Pilihan $huruf',
                  style: TextStyle(
                    color: textBlue,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              );
            },
          ),
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              jawabanBenar = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController
        controller,
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
        labelStyle: TextStyle(
          color: mutedBlue,
        ),
        hintStyle: TextStyle(
          color: mutedBlue
              .withOpacity(0.7),
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(13),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFE1EAF6),
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(13),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFE1EAF6),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(13),
          borderSide: BorderSide(
            color: royalBlue,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(
    String text,
  ) {
    return Text(
      text,
      style: TextStyle(
        color: textBlue,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSimpanButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _simpanSoal,
        style:
            ElevatedButton.styleFrom(
          backgroundColor: royalBlue,
          foregroundColor:
              Colors.white,
          elevation: 0,
          padding:
              const EdgeInsets.symmetric(
            vertical: 15,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(
          Icons.save_outlined,
        ),
        label: const Text(
          'Simpan Soal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _simpanSoal() {
    final pertanyaan =
        pertanyaanController.text.trim();

    if (pertanyaan.isEmpty) {
      _showError(
        'Pertanyaan belum diisi.',
      );
      return;
    }

    final pilihan =
        pilihanControllers
            .map(
              (controller) =>
                  controller.text.trim(),
            )
            .toList();

    if (pilihan.any(
      (item) => item.isEmpty,
    )) {
      _showError(
        'Semua pilihan jawaban harus diisi.',
      );
      return;
    }

    TantanganData
        .tambahSoalPilihanGanda(
      tantangan: widget.tantangan,
      pertanyaan: pertanyaan,
      pilihan: pilihan,
      jawabanBenar: jawabanBenar,
    );

    Navigator.pop(
      context,
      true,
    );
  }

  void _showError(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        backgroundColor:
            Colors.red.shade600,
        content: Text(message),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }
}