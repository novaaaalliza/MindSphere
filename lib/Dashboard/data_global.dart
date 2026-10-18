// ============================================================
// DATA GLOBAL MINDSHPERE
// ============================================================

// ============================================================
// DATA KELAS
// ============================================================

final List<Map<String, dynamic>> daftarKelasGlobal = [];


// ============================================================
// DATA SISWA
// ============================================================

final List<Map<String, String>> daftarSiswaGlobal = [];


// ============================================================
// DATA MATERI
// ============================================================

final List<Map<String, String>> daftarMateriGlobal = [];


// ============================================================
// DATA TANTANGAN
// ============================================================

final List<Map<String, dynamic>> daftarTantanganGlobal = [];


// ============================================================
// DATA HASIL SISWA
// ============================================================

final List<Map<String, dynamic>> daftarHasilGlobal = [];


// ============================================================
// DATA AKTIVITAS MATERI
// ============================================================

final List<Map<String, String>> daftarAktivitasMateriGlobal = [];


// ============================================================
// DATA AKTIVITAS TERBARU
// ============================================================

final List<Map<String, dynamic>> daftarAktivitasGlobal = [];


// ============================================================
// DATA SISWA YANG SEDANG LOGIN
// ============================================================

String namaSiswaAktif = 'Siswa';


// ============================================================
// MENAMBAHKAN AKTIVITAS TERBARU
// ============================================================

void tambahAktivitas({
  required String tipe,
  required String judul,
  required String deskripsi,
  required String namaSiswa,
  required String namaKelas,
  String? kodeKelas,
  int? nilai,
}) {
  daftarAktivitasGlobal.insert(0, {
    'tipe': tipe,
    'judul': judul,
    'deskripsi': deskripsi,
    'namaSiswa': namaSiswa,
    'namaKelas': namaKelas,
    'kodeKelas': kodeKelas,
    'nilai': nilai,
    'waktu': DateTime.now(),
  });
}


// ============================================================
// MENCARI KELAS BERDASARKAN KODE
// ============================================================

Map<String, dynamic>? cariKelasDenganKode(String kode) {
  try {
    return daftarKelasGlobal.firstWhere(
      (kelas) =>
          kelas['kode'].toString().toLowerCase() ==
          kode.toLowerCase(),
    );
  } catch (e) {
    return null;
  }
}


// ============================================================
// CEK APAKAH SISWA SUDAH GABUNG KELAS
// ============================================================

bool siswaSudahGabung(String kodeKelas) {
  return daftarSiswaGlobal.any(
    (siswa) =>
        siswa['namaSiswa'] == namaSiswaAktif &&
        siswa['kodeKelas'] == kodeKelas,
  );
}


// ============================================================
// MENAMBAHKAN SISWA KE KELAS
// ============================================================

void tambahSiswaKeKelas({
  required String namaKelas,
  required String kodeKelas,
}) {
  if (siswaSudahGabung(kodeKelas)) {
    return;
  }

  daftarSiswaGlobal.add({
    'namaSiswa': namaSiswaAktif,
    'namaKelas': namaKelas,
    'kodeKelas': kodeKelas,
  });

  // Catat aktivitas siswa bergabung ke kelas
  tambahAktivitas(
    tipe: 'gabung_kelas',
    judul: 'Siswa bergabung ke kelas',
    deskripsi:
        '$namaSiswaAktif bergabung ke kelas $namaKelas',
    namaSiswa: namaSiswaAktif,
    namaKelas: namaKelas,
    kodeKelas: kodeKelas,
  );
}


// ============================================================
// MENGAMBIL MATERI SESUAI KELAS
// ============================================================

List<Map<String, String>> ambilMateriKelas(
  String kodeKelas,
  String namaKelas,
) {
  return daftarMateriGlobal
      .where(
        (materi) =>
            materi['kodeKelas'] == kodeKelas &&
            materi['namaKelas'] == namaKelas,
      )
      .toList();
}


// ============================================================
// MENGAMBIL TANTANGAN SESUAI KELAS
// ============================================================

List<Map<String, dynamic>> ambilTantanganKelas(
  String kodeKelas,
  String namaKelas,
) {
  return daftarTantanganGlobal
      .where(
        (tantangan) =>
            tantangan['kodeKelas'] == kodeKelas &&
            tantangan['namaKelas'] == namaKelas,
      )
      .toList();
}


// ============================================================
// MENANDAI MATERI SUDAH SELESAI
// ============================================================

void tandaiMateriSelesai({
  required String idMateri,
  required String kodeKelas,
}) {
  final sudahAda = daftarAktivitasMateriGlobal.any(
    (aktivitas) =>
        aktivitas['idMateri'] == idMateri &&
        aktivitas['kodeKelas'] == kodeKelas &&
        aktivitas['namaSiswa'] == namaSiswaAktif,
  );

  if (sudahAda) {
    return;
  }

  daftarAktivitasMateriGlobal.add({
    'idMateri': idMateri,
    'kodeKelas': kodeKelas,
    'namaSiswa': namaSiswaAktif,
  });

  // Cari data materi untuk mendapatkan judul dan nama kelas
  Map<String, String>? materiDitemukan;

  for (final materi in daftarMateriGlobal) {
    final idMateriGlobal = materi['id'];

    final idFallback =
        '${materi['kodeKelas']}_${materi['judul']}';

    if (idMateriGlobal == idMateri ||
        idFallback == idMateri) {
      materiDitemukan = materi;
      break;
    }
  }

  final judulMateri =
      materiDitemukan?['judul'] ?? 'Materi';

  final namaKelas =
      materiDitemukan?['namaKelas'] ?? 'Kelas';

  // Catat aktivitas materi selesai
  tambahAktivitas(
    tipe: 'materi_selesai',
    judul: 'Materi selesai dipelajari',
    deskripsi:
        '$namaSiswaAktif menyelesaikan materi "$judulMateri"',
    namaSiswa: namaSiswaAktif,
    namaKelas: namaKelas,
    kodeKelas: kodeKelas,
  );
}


// ============================================================
// CEK MATERI SUDAH SELESAI
// ============================================================

bool materiSudahSelesai({
  required String idMateri,
  required String kodeKelas,
}) {
  return daftarAktivitasMateriGlobal.any(
    (aktivitas) =>
        aktivitas['idMateri'] == idMateri &&
        aktivitas['kodeKelas'] == kodeKelas &&
        aktivitas['namaSiswa'] == namaSiswaAktif,
  );
}


// ============================================================
// JUMLAH MATERI YANG SUDAH SELESAI
// ============================================================

int jumlahMateriSelesai({
  required String kodeKelas,
}) {
  return daftarAktivitasMateriGlobal
      .where(
        (aktivitas) =>
            aktivitas['kodeKelas'] == kodeKelas &&
            aktivitas['namaSiswa'] == namaSiswaAktif,
      )
      .length;
}


// ============================================================
// MENGAMBIL HASIL SISWA SESUAI KELAS
// ============================================================

List<Map<String, dynamic>> hasilSiswaDiKelas(
  String kodeKelas,
) {
  return daftarHasilGlobal
      .where(
        (hasil) =>
            hasil['kodeKelas'] == kodeKelas,
      )
      .toList();
}


// ============================================================
// CEK TANTANGAN SUDAH DIKERJAKAN
// ============================================================

bool tantanganSudahDikerjakan({
  required String kodeKelas,
  required String judulTantangan,
}) {
  return daftarHasilGlobal.any(
    (hasil) =>
        hasil['kodeKelas'] == kodeKelas &&
        hasil['judulTantangan'] == judulTantangan &&
        hasil['namaSiswa'] == namaSiswaAktif,
  );
}


// ============================================================
// MENGHITUNG PROGRESS SISWA
// ============================================================

double hitungProgressKelas({
  required String kodeKelas,
  required String namaKelas,
}) {
  final materi = ambilMateriKelas(
    kodeKelas,
    namaKelas,
  );

  final tantangan = ambilTantanganKelas(
    kodeKelas,
    namaKelas,
  );

  final totalMateri = materi.length;
  final totalTantangan = tantangan.length;

  final totalAktivitas =
      totalMateri + totalTantangan;

  if (totalAktivitas == 0) {
    return 0;
  }

  final materiSelesai = jumlahMateriSelesai(
    kodeKelas: kodeKelas,
  );

  final tantanganSelesai = tantangan
      .where(
        (item) => tantanganSudahDikerjakan(
          kodeKelas: kodeKelas,
          judulTantangan: item['judul'] ?? '',
        ),
      )
      .length;

  final aktivitasSelesai =
      materiSelesai + tantanganSelesai;

  return aktivitasSelesai / totalAktivitas;
}