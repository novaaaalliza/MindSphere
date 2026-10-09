class TantanganData {
  // Menyimpan semua tantangan/kuis yang dibuat oleh guru
  static final List<Map<String, dynamic>> daftarTantangan = [];

  // Mengambil tantangan berdasarkan kode kelas
  static List<Map<String, dynamic>> getTantanganByKelas(
    String kodeKelas,
  ) {
    return daftarTantangan
        .where(
          (tantangan) => tantangan['kodeKelas'] == kodeKelas,
        )
        .toList();
  }

  // Menambahkan tantangan baru
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

  // Menghapus tantangan
  static void hapusTantangan(
    Map<String, dynamic> tantangan,
  ) {
    daftarTantangan.remove(tantangan);
  }

  // Menambahkan soal ke dalam tantangan
  static void tambahSoal({
    required Map<String, dynamic> tantangan,
    required String pertanyaan,
    required List<String> pilihan,
    required int jawabanBenar,
  }) {
    final soal =
        tantangan['soal'] as List<Map<String, dynamic>>;

    soal.add({
      'pertanyaan': pertanyaan,
      'pilihan': pilihan,
      'jawabanBenar': jawabanBenar,
    });
  }

  // Menghapus soal dari tantangan
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
}