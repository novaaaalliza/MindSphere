class MateriData {
  // Menyimpan semua materi yang dibuat oleh guru
  static final List<Map<String, String>> daftarMateri = [];

  // Mengambil materi berdasarkan kode kelas
  static List<Map<String, String>> getMateriByKelas(
    String kodeKelas,
  ) {
    return daftarMateri
        .where(
          (materi) => materi['kodeKelas'] == kodeKelas,
        )
        .toList();
  }
}