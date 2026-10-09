class TantanganData {
  // Menyimpan semua tantangan/kuis yang dibuat oleh guru
  static final List<Map<String, dynamic>> daftarTantangan = [];

  // =========================================================
  // MENGAMBIL TANTANGAN BERDASARKAN KODE KELAS
  // =========================================================

  static List<Map<String, dynamic>> getTantanganByKelas(
    String kodeKelas,
  ) {
    return daftarTantangan
        .where(
          (tantangan) => tantangan['kodeKelas'] == kodeKelas,
        )
        .toList();
  }

  // =========================================================
  // MENAMBAHKAN TANTANGAN BARU
  // =========================================================

  static void tambahTantangan({
    required String kodeKelas,
    required String judul,
    required String deskripsi,
  }) {
    daftarTantangan.add({
      'kodeKelas': kodeKelas,
      'judul': judul,
      'deskripsi': deskripsi,

      // Semua soal dalam satu tantangan disimpan di sini
      'soal': <Map<String, dynamic>>[],
    });
  }

  // =========================================================
  // MENGHAPUS TANTANGAN
  // =========================================================

  static void hapusTantangan(
    Map<String, dynamic> tantangan,
  ) {
    daftarTantangan.remove(tantangan);
  }

  // =========================================================
  // MENAMBAHKAN SOAL PILIHAN GANDA
  // =========================================================

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

  // =========================================================
  // MENAMBAHKAN SOAL MENJODOHKAN
  // =========================================================

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

  // =========================================================
  // MENAMBAHKAN SOAL IDENTIFIKASI GAMBAR
  // =========================================================

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

  // =========================================================
  // MENAMBAHKAN SOAL JAWABAN SINGKAT
  // =========================================================

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

  // =========================================================
  // MENAMBAHKAN SOAL SUSUN LANGKAH
  // =========================================================

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

  // =========================================================
  // MENGHAPUS SOAL
  // =========================================================

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

  // =========================================================
  // MENGAMBIL JUMLAH SOAL
  // =========================================================

  static int jumlahSoal(
    Map<String, dynamic> tantangan,
  ) {
    final soal =
        tantangan['soal'] as List<Map<String, dynamic>>;

    return soal.length;
  }

  // =========================================================
  // MENGAMBIL JENIS SOAL
  // =========================================================

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