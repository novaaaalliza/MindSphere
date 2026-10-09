import 'package:flutter/material.dart';
import '../data/tantangan_data.dart';
import '../soal/pilihan_ganda_page.dart';

class TantanganGuruPage extends StatefulWidget {
  final String namaKelas;
  final String kodeKelas;

  const TantanganGuruPage({
    super.key,
    required this.namaKelas,
    required this.kodeKelas,
  });

  @override
  State<TantanganGuruPage> createState() =>
      _TantanganGuruPageState();
}

class _TantanganGuruPageState
    extends State<TantanganGuruPage> {
  final Color royalBlue = const Color(0xFF2166D5);
  final Color deepBlue = const Color(0xFF123B70);
  final Color skyBlue = const Color(0xFF56B4F8);
  final Color paleBlue = const Color(0xFFDCEBFF);
  final Color textBlue = const Color(0xFF18365D);
  final Color mutedBlue = const Color(0xFF7288A8);

  List<Map<String, dynamic>> get daftarTantangan {
    return TantanganData.getTantanganByKelas(
      widget.kodeKelas,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FE),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tantangan',
              style: TextStyle(
                color: deepBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.namaKelas,
              style: TextStyle(
                color: mutedBlue,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTambahTantangan,
        backgroundColor: royalBlue,
        icon: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
        label: const Text(
          'Tambah Tantangan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: daftarTantangan.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                100,
              ),
              itemCount: daftarTantangan.length,
              itemBuilder: (context, index) {
                final tantangan =
                    daftarTantangan[index];

                return _buildTantanganCard(
                  tantangan,
                  index,
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: paleBlue,
                borderRadius:
                    BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.emoji_events_outlined,
                color: royalBlue,
                size: 45,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum Ada Tantangan',
              style: TextStyle(
                color: deepBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Buat tantangan untuk memberikan aktivitas belajar kepada siswa.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedBlue,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: _showTambahTantangan,
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(
                Icons.add_rounded,
              ),
              label: const Text(
                'Buat Tantangan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTantanganCard(
    Map<String, dynamic> tantangan,
    int index,
  ) {
    final soal =
        tantangan['soal']
            as List<Map<String, dynamic>>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(
                      colors: [
                        royalBlue,
                        skyBlue,
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: const Icon(
                    Icons
                        .emoji_events_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        tantangan['judul'] ??
                            'Tantangan',
                        style: TextStyle(
                          color: deepBlue,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${soal.length} soal',
                        style: TextStyle(
                          color: mutedBlue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: mutedBlue,
                  ),
                  onSelected: (value) {
                    if (value == 'kelola') {
                      _showKelolaSoal(
                        tantangan,
                      );
                    } else if (value ==
                        'hapus') {
                      _hapusTantangan(
                        tantangan,
                      );
                    }
                  },
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem(
                        value: 'kelola',
                        child: Text(
                          'Kelola Soal',
                        ),
                      ),
                      PopupMenuItem(
                        value: 'hapus',
                        child: Text(
                          'Hapus Tantangan',
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              tantangan['deskripsi'] ?? '',
              style: TextStyle(
                color: mutedBlue,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showKelolaSoal(
                    tantangan,
                  );
                },
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      royalBlue,
                  side: BorderSide(
                    color: royalBlue,
                  ),
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 12,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      13,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons
                      .playlist_add_rounded,
                ),
                label: const Text(
                  'Kelola Soal',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTambahTantangan() {
    final judulController =
        TextEditingController();
    final deskripsiController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: Text(
            'Tambah Tantangan',
            style: TextStyle(
              color: deepBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: judulController,
                decoration:
                    _inputDecoration(
                  'Judul Tantangan',
                  'Contoh: Tantangan Dasar Komputer',
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller:
                    deskripsiController,
                maxLines: 3,
                decoration:
                    _inputDecoration(
                  'Deskripsi',
                  'Masukkan deskripsi tantangan',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: mutedBlue,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final judul =
                    judulController.text
                        .trim();
                final deskripsi =
                    deskripsiController
                        .text
                        .trim();

                if (judul.isEmpty ||
                    deskripsi.isEmpty) {
                  return;
                }

                TantanganData
                    .tambahTantangan(
                  kodeKelas:
                      widget.kodeKelas,
                  judul: judul,
                  deskripsi: deskripsi,
                );

                Navigator.pop(
                  dialogContext,
                );

                setState(() {});
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    royalBlue,
                foregroundColor:
                    Colors.white,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
              child: const Text(
                'Simpan',
              ),
            ),
          ],
        );
      },
    );
  }

  void _showKelolaSoal(
    Map<String, dynamic> tantangan,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder:
              (context, setSheetState) {
            final soal =
                tantangan['soal']
                    as List<
                        Map<String, dynamic>>;

            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  25,
                ),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Kelola Soal',
                            style: TextStyle(
                              color: deepBlue,
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(
                              sheetContext,
                            );
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: mutedBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      tantangan['judul'] ??
                          'Tantangan',
                      style: TextStyle(
                        color: mutedBlue,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (soal.isEmpty)
                      Container(
                        width:
                            double.infinity,
                        padding:
                            const EdgeInsets
                                .all(18),
                        decoration:
                            BoxDecoration(
                          color: const Color(
                            0xFFF6F9FE,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            15,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons
                                  .quiz_outlined,
                              color:
                                  mutedBlue,
                              size: 35,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Belum ada soal',
                              style: TextStyle(
                                color:
                                    textBlue,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...List.generate(
                        soal.length,
                        (index) {
                          final item =
                              soal[index];

                          final tipe =
                              item['tipe'] ??
                                  'soal';

                          return Container(
                            margin:
                                const EdgeInsets
                                    .only(
                              bottom: 10,
                            ),
                            padding:
                                const EdgeInsets
                                    .all(14),
                            decoration:
                                BoxDecoration(
                              color:
                                  const Color(
                                0xFFF8FAFE,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                15,
                              ),
                              border:
                                  Border.all(
                                color:
                                    const Color(
                                  0xFFE5ECF6,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  alignment:
                                      Alignment
                                          .center,
                                  decoration:
                                      BoxDecoration(
                                    color:
                                        paleBlue,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      11,
                                    ),
                                  ),
                                  child:
                                      Text(
                                    '${index + 1}',
                                    style:
                                        TextStyle(
                                      color:
                                          royalBlue,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child:
                                      Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        tipe ==
                                                'pilihan_ganda'
                                            ? 'Pilihan Ganda'
                                            : tipe ==
                                                    'menjodohkan'
                                                ? 'Menjodohkan'
                                                : tipe ==
                                                        'identifikasi_gambar'
                                                    ? 'Identifikasi Gambar'
                                                    : tipe ==
                                                            'jawaban_singkat'
                                                        ? 'Jawaban Singkat'
                                                        : tipe ==
                                                                'susun_langkah'
                                                            ? 'Susun Langkah'
                                                            : 'Soal',
                                        style:
                                            TextStyle(
                                          color:
                                              mutedBlue,
                                          fontSize:
                                              12,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        item['pertanyaan'] ??
                                            '',
                                        maxLines:
                                            2,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        style:
                                            TextStyle(
                                          color:
                                              textBlue,
                                          fontSize:
                                              13,
                                          fontWeight:
                                              FontWeight
                                                  .w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed:
                                      () {
                                    TantanganData
                                        .hapusSoal(
                                      tantangan:
                                          tantangan,
                                      index:
                                          index,
                                    );

                                    setSheetState(
                                      () {},
                                    );

                                    setState(
                                      () {},
                                    );
                                  },
                                  icon: Icon(
                                    Icons
                                        .delete_outline_rounded,
                                    color: Colors
                                        .red
                                        .shade400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child:
                          ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(
                            sheetContext,
                          );

                          Future.delayed(
                            const Duration(
                              milliseconds: 150,
                            ),
                            () {
                              _showTambahSoal(
                                tantangan,
                              );
                            },
                          );
                        },
                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor:
                              royalBlue,
                          foregroundColor:
                              Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 14,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.add_rounded,
                        ),
                        label: const Text(
                          'Tambah Soal',
                          style: TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTambahSoal(
    Map<String, dynamic> tantangan,
  ) {
    String tipeSoal = 'pilihan_ganda';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              backgroundColor:
                  Colors.white,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
              title: Text(
                'Pilih Jenis Soal',
                style: TextStyle(
                  color: deepBlue,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              content: DropdownButtonFormField<
                  String>(
                value: tipeSoal,
                decoration:
                    _inputDecoration(
                  'Jenis Soal',
                  'Pilih jenis soal',
                ),
                items: const [
                  DropdownMenuItem(
                    value:
                        'pilihan_ganda',
                    child: Text(
                      'Pilihan Ganda',
                    ),
                  ),
                  DropdownMenuItem(
                    value:
                        'menjodohkan',
                    child: Text(
                      'Menjodohkan',
                    ),
                  ),
                  DropdownMenuItem(
                    value:
                        'identifikasi_gambar',
                    child: Text(
                      'Identifikasi Gambar',
                    ),
                  ),
                  DropdownMenuItem(
                    value:
                        'jawaban_singkat',
                    child: Text(
                      'Jawaban Singkat',
                    ),
                  ),
                  DropdownMenuItem(
                    value:
                        'susun_langkah',
                    child: Text(
                      'Susun Langkah',
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setDialogState(() {
                    tipeSoal = value;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      color: mutedBlue,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (tipeSoal ==
                        'pilihan_ganda') {
                      Navigator.pop(
                        dialogContext,
                      );

                      Future.delayed(
                        const Duration(
                          milliseconds: 150,
                        ),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PilihanGandaPage(
                                tantangan:
                                    tantangan,
                              ),
                            ),
                          ).then((_) {
                            if (mounted) {
                              setState(
                                () {},
                              );
                            }
                          });
                        },
                      );
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        royalBlue,
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Lanjut',
                  ),
                ),
              ],
            );
          },
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
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: Text(
            'Hapus Tantangan?',
            style: TextStyle(
              color: deepBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Tantangan ini beserta soal di dalamnya akan dihapus.',
            style: TextStyle(
              color: mutedBlue,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: mutedBlue,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                TantanganData
                    .hapusTantangan(
                  tantangan,
                );

                Navigator.pop(
                  dialogContext,
                );

                setState(() {});
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red.shade600,
                foregroundColor:
                    Colors.white,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
              child: const Text(
                'Hapus',
              ),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration(
    String label,
    String hint,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(
        color: mutedBlue,
      ),
      hintStyle: TextStyle(
        color:
            mutedBlue.withOpacity(0.7),
        fontSize: 13,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Color(0xFFE1EAF6),
        ),
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Color(0xFFE1EAF6),
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
    );
  }
}