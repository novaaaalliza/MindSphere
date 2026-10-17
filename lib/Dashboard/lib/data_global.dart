import 'kelola_materi_page.dart';
import 'kelola_tantangan_page.dart';
import 'hasil_siswa_page.dart';

/// ============================================================
/// DATA KELAS
/// ============================================================
/// Semua kelas yang dibuat Guru disimpan di sini.
/// Siswa akan mencari kelas berdasarkan kode dari daftar ini.

final List<Map<String, dynamic>> daftarKelasGlobal = [];

/// ============================================================
/// DATA SISWA YANG BERGABUNG
/// ============================================================
/// Setiap siswa yang berhasil memasukkan kode kelas
/// akan dicatat di sini.

final List<Map<String, String>> daftarSiswaGlobal = [];

/// ============================================================
/// DATA AKTIVITAS SISWA
/// ============================================================
/// Menyimpan materi yang sudah dibaca/dibuka oleh siswa.

final List<Map<String, String>> daftarAktivitasMateriGlobal = [];

/// ============================================================
/// DATA HASIL TANTANGAN
/// ============================================================
/// Data ini dipakai bersama oleh Siswa dan Guru.

/// `daftarHasilGlobal` sebenarnya sudah dibuat di
/// hasil_siswa_page.dart.
/// File ini hanya menggunakan list tersebut.

/// ============================================================
/// DATA SISWA AKTIF
/// ============================================================
/// Untuk sementara identitas siswa dibuat sederhana.
/// Nanti ketika Firebase Authentication sudah dipasang,
/// bagian ini bisa diganti dengan nama akun siswa.

String namaSiswaAktif = 'Siswa';

/// ============================================================
/// CARI KELAS
/// ============================================================

Map<String, dynamic>? cariKelasDenganKode(String kode) {
  final kodeBersih = kode.trim().toUpperCase();

  try {
    return daftarKelasGlobal.firstWhere(
      (kelas) =>
          (kelas['kode'] ?? '').toString().toUpperCase() ==
          kodeBersih,
    );
  } catch (_) {
    return null;
  }
}

/// ============================================================
/// CEK SISWA SUDAH BERGABUNG ATAU BELUM
/// ============================================================

bool siswaSudahGabung(
  String kodeKelas,
) {
  return daftarSiswaGlobal.any(
    (siswa) =>
        siswa['namaSiswa'] == namaSiswaAktif &&
        siswa['kodeKelas'] == kodeKelas,
  );
}

/// ============================================================
/// TAMBAH SISWA KE KELAS
/// ============================================================

void tambahSiswaKeKelas({
  required String namaKelas,
  required String kodeKelas,
}) {
  final sudahAda = siswaSudahGabung(kodeKelas);

  if (sudahAda) {
    return;
  }

  daftarSiswaGlobal.add({
    'namaSiswa': namaSiswaAktif,
    'namaKelas': namaKelas,
    'kodeKelas': kodeKelas,
  });
}

/// ============================================================
/// MATERI MILIK KELAS
/// ============================================================

List<Map<String, String>> ambilMateriKelas(
  String kodeKelas,
  String namaKelas,
) {
  return daftarMateriGlobal.where(
    (materi) {
      return materi['kodeKelas'] == kodeKelas &&
          materi['namaKelas'] == namaKelas;
    },
  ).toList();
}

/// ============================================================
/// TANTANGAN MILIK KELAS
/// ============================================================

List<Map<String, dynamic>> ambilTantanganKelas(
  String kodeKelas,
  String namaKelas,
) {
  return daftarTantanganGlobal.where(
    (tantangan) {
      return tantangan['kodeKelas'] == kodeKelas &&
          tantangan['namaKelas'] == namaKelas;
    },
  ).toList();
}

/// ============================================================
/// TANDAI MATERI SUDAH DIBACA
/// ============================================================

void tandaiMateriSelesai({
  required String idMateri,
  required String kodeKelas,
}) {
  final sudahAda = daftarAktivitasMateriGlobal.any(
    (aktivitas) =>
        aktivitas['namaSiswa'] == namaSiswaAktif &&
        aktivitas['idMateri'] == idMateri &&
        aktivitas['kodeKelas'] == kodeKelas,
  );

  if (sudahAda) {
    return;
  }

  daftarAktivitasMateriGlobal.add({
    'namaSiswa': namaSiswaAktif,
    'idMateri': idMateri,
    'kodeKelas': kodeKelas,
  });
}

/// ============================================================
/// CEK MATERI SUDAH SELESAI
/// ============================================================

bool materiSudahSelesai({
  required String idMateri,
  required String kodeKelas,
}) {
  return daftarAktivitasMateriGlobal.any(
    (aktivitas) =>
        aktivitas['namaSiswa'] == namaSiswaAktif &&
        aktivitas['idMateri'] == idMateri &&
        aktivitas['kodeKelas'] == kodeKelas,
  );
}

/// ============================================================
/// HITUNG MATERI SELESAI
/// ============================================================

int jumlahMateriSelesai({
  required String kodeKelas,
}) {
  return daftarAktivitasMateriGlobal.where(
    (aktivitas) =>
        aktivitas['namaSiswa'] == namaSiswaAktif &&
        aktivitas['kodeKelas'] == kodeKelas,
  ).length;
}

/// ============================================================
/// HASIL TANTANGAN SISWA
/// ============================================================

List<Map<String, dynamic>> hasilSiswaDiKelas(
  String kodeKelas,
) {
  return daftarHasilGlobal.where(
    (hasil) =>
        hasil['namaSiswa'] == namaSiswaAktif &&
        hasil['kodeKelas'] == kodeKelas,
  ).toList();
}

/// ============================================================
/// CEK TANTANGAN SUDAH DIKERJAKAN
/// ============================================================

bool tantanganSudahDikerjakan({
  required String kodeKelas,
  required String judulTantangan,
}) {
  return daftarHasilGlobal.any(
    (hasil) =>
        hasil['namaSiswa'] == namaSiswaAktif &&
        hasil['kodeKelas'] == kodeKelas &&
        hasil['judulTantangan'] == judulTantangan,
  );
}

/// ============================================================
/// HITUNG PROGRESS
/// ============================================================
/// Progress dihitung dari:
///
/// Materi selesai + tantangan selesai
/// ----------------------------------
/// Total materi + total tantangan
///
/// Jadi bukan angka 0% tetap lagi.

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

  final totalAktivitas =
      materi.length + tantangan.length;

  if (totalAktivitas == 0) {
    return 0;
  }

  final materiSelesai = jumlahMateriSelesai(
    kodeKelas: kodeKelas,
  );

  final tantanganSelesai =
      hasilSiswaDiKelas(kodeKelas).length;

  final selesai =
      materiSelesai + tantanganSelesai;

  return (selesai / totalAktivitas)
      .clamp(0.0, 1.0);
}