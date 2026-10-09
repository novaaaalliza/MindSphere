class TantanganData {
  static final List<Map<String, dynamic>> daftarTantangan = [];

  static List<Map<String, dynamic>> getTantanganByKelas(
    String kodeKelas,
  ) {
    return daftarTantangan
        .where(
          (tantangan) => tantangan['kodeKelas'] == kodeKelas,
        )
        .toList();
  }

  static void tambahTantangan({
    required String kodeKelas,
    required String judul,
    required String deskripsi,
  }) {
    daftarTantangan.add({
      'kodeKelas': kodeKelas,
      'judul': judul,
      'deskripsi': deskripsi,
      'soal': <Map<String, dynamic>>[],
    });
  }

  static void hapusTantangan(
    Map<String, dynamic> tantangan,
  ) {
    daftarTantangan.remove(tantangan);
  }

  static void tambahSoalPilihanGanda({
    required Map<String, dynamic> tantangan,
    required String pertanyaan,
    required List<String> pilihan,
    required int jawabanBenar,
  }) {
    final soal =
        tantangan['soal'] as List<Map<String, dynamic>>;

    soal.add({
      'tipe': 'pilihan_ganda',
      'pertanyaan': pertanyaan,
      'pilihan': pilihan,
      'jawabanBenar': jawabanBenar,
    });
  }

  static void tambahSoalMenjodohkan({
    required Map<String, dynamic> tantangan,
    required String pertanyaan,
    required List<String> bagianKiri,
    required List<String> bagianKanan,
    required List<int> jawabanBenar,
  }) {
    final soal =
        tantangan['soal'] as List<Map<String, dynamic>>;

    soal.add({
      'tipe': 'menjodohkan',
      'pertanyaan': pertanyaan,
      'bagianKiri': bagianKiri,
      'bagianKanan': bagianKanan,
      'jawabanBenar': jawabanBenar,
    });
  }

  static void tambahSoalIdentifikasiGambar({
    required Map<String, dynamic> tantangan,
    required String pertanyaan,
    required String gambar,
    required List<String> pilihan,
    required int jawabanBenar,
  }) {
    final soal =
        tantangan['soal'] as List<Map<String, dynamic>>;

    soal.add({
      'tipe': 'identifikasi_gambar',
      'pertanyaan': pertanyaan,
      'gambar': gambar,
      'pilihan': pilihan,
      'jawabanBenar': jawabanBenar,
    });
  }

  static void tambahSoalJawabanSingkat({
    required Map<String, dynamic> tantangan,
    required String pertanyaan,
    required String jawabanBenar,
  }) {
    final soal =
        tantangan['soal'] as List<Map<String, dynamic>>;

    soal.add({
      'tipe': 'jawaban_singkat',
      'pertanyaan': pertanyaan,
      'jawabanBenar': jawabanBenar,
    });
  }

  static void tambahSoalSusunLangkah({
    required Map<String, dynamic> tantangan,
    required String pertanyaan,
    required List<String> langkah,
    required List<String> urutanBenar,
  }) {
    final soal =
        tantangan['soal'] as List<Map<String, dynamic>>;

    soal.add({
      'tipe': 'susun_langkah',
      'pertanyaan': pertanyaan,
      'langkah': langkah,
      'urutanBenar': urutanBenar,
    });
  }

  static void hapusSoal({
    required Map<String, dynamic> tantangan,
    required int index,
  }) {
    final soal =
        tantangan['soal'] as List<Map<String, dynamic>>;

    if (index >= 0 && index < soal.length) {
      soal.removeAt(index);
    }
  }

  static int jumlahSoal(
    Map<String, dynamic> tantangan,
  ) {
    final soal =
        tantangan['soal'] as List<Map<String, dynamic>>;

    return soal.length;
  }

  static String getNamaTipeSoal(
    String tipe,
  ) {
    switch (tipe) {
      case 'pilihan_ganda':
        return 'Pilihan Ganda';

      case 'menjodohkan':
        return 'Menjodohkan';

      case 'identifikasi_gambar':
        return 'Identifikasi Gambar';

      case 'jawaban_singkat':
        return 'Jawaban Singkat';

      case 'susun_langkah':
        return 'Susun Langkah';

      default:
        return 'Soal';
    }
  }
}