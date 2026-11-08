
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'detail_kelas_siswa_page.dart';
import 'profil_siswa_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Color royalBlue = const Color(0xFF2166D5);
  final Color deepBlue = const Color(0xFF123B70);
  final Color skyBlue = const Color(0xFF56B4F8);
  final Color paleBlue = const Color(0xFFDCEBFF);
  final Color textBlue = const Color(0xFF18365D);
  final Color mutedBlue = const Color(0xFF7288A8);

  // KELAS YANG SEDANG DIPILIH
  String? namaKelas;
  String? kodeKelas;
  String? idKelas;

  // SEMUA KELAS YANG DIIKUTI SISWA
  List<Map<String, String>> daftarKelasDiikuti = [];

  String namaSiswaAktif = 'Siswa';

  bool sedangMemuatKelas = true;
  bool sedangMemuatData = false;
  bool sedangGabung = false;

  List<Map<String, String>> daftarMateriFirebase = [];
  List<Map<String, dynamic>> daftarTantanganFirebase = [];
  List<Map<String, dynamic>> daftarHasilFirebase = [];
  Set<String> materiSelesaiFirebase = {};

  User? get _user => FirebaseAuth.instance.currentUser;

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _kelasCollection =>
      _firestore.collection('kelas');

  @override
  void initState() {
    super.initState();
    _muatKelasDiikuti();
  }

  // ============================================================
  // MEMUAT SEMUA KELAS YANG DIIKUTI SISWA
  // ============================================================

  Future<void> _muatKelasDiikuti({String? pilihId}) async {
    final user = _user;

    if (user == null) {
      if (mounted) {
        setState(() {
          sedangMemuatKelas = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        sedangMemuatKelas = true;
      });
    }

    try {
      final profil = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      final dataProfil = profil.data() ?? {};

      final nama = (dataProfil['name'] ??
              dataProfil['nama'] ??
              dataProfil['namaLengkap'] ??
              'Siswa')
          .toString();

      final daftarDiikuti = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('kelas_diikuti')
          .get();

      final List<Map<String, String>> kelasBaru = [];

      // MEMERIKSA SETIAP KELAS, BUKAN HANYA DOKUMEN PERTAMA
      for (final keanggotaan in daftarDiikuti.docs) {
        final id = keanggotaan.id;

        final kelasDoc = await _kelasCollection.doc(id).get();

        // Hapus keanggotaan yang kelasnya sudah tidak ada.
        if (!kelasDoc.exists) {
          await keanggotaan.reference.delete();
          continue;
        }

        final dataKelas = kelasDoc.data() ?? {};
        final dataKeanggotaan = keanggotaan.data();

        final namaBaru = (dataKelas['nama'] ??
                dataKelas['namaKelas'] ??
                dataKeanggotaan['namaKelas'] ??
                '')
            .toString();

        final kodeBaru = (dataKelas['kode'] ??
                dataKelas['kodeKelas'] ??
                dataKeanggotaan['kodeKelas'] ??
                '')
            .toString();

        if (namaBaru.isEmpty || kodeBaru.isEmpty) {
          continue;
        }

        kelasBaru.add({
          'id': id,
          'namaKelas': namaBaru,
          'kodeKelas': kodeBaru,
        });
      }

      if (!mounted) return;

      setState(() {
        namaSiswaAktif = nama;
        daftarKelasDiikuti = kelasBaru;
        sedangMemuatKelas = false;
      });

      if (kelasBaru.isEmpty) {
        _kosongkanDataKelas();
        return;
      }

      // Pertahankan kelas aktif jika masih diikuti.
      Map<String, String>? kelasDipilih;

      if (pilihId != null) {
        for (final kelas in kelasBaru) {
          if (kelas['id'] == pilihId) {
            kelasDipilih = kelas;
            break;
          }
        }
      }

      if (kelasDipilih == null && idKelas != null) {
        for (final kelas in kelasBaru) {
          if (kelas['id'] == idKelas) {
            kelasDipilih = kelas;
            break;
          }
        }
      }

      kelasDipilih ??= kelasBaru.first;

      await _pilihKelas(kelasDipilih, tampilkanLoading: false);
    } catch (e) {
      debugPrint('Gagal memuat kelas siswa: $e');

      if (mounted) {
        setState(() {
          sedangMemuatKelas = false;
        });

        _tampilkanPesan(
          'Gagal memuat kelas. Periksa koneksi dan aturan Firebase.',
        );
      }
    }
  }

  // ============================================================
  // MEMILIH KELAS AKTIF
  // ============================================================

  Future<void> _pilihKelas(
    Map<String, String> kelas, {
    bool tampilkanLoading = true,
  }) async {
    if (!mounted) return;

    setState(() {
      idKelas = kelas['id'];
      namaKelas = kelas['namaKelas'];
      kodeKelas = kelas['kodeKelas'];

      daftarMateriFirebase = [];
      daftarTantanganFirebase = [];
      daftarHasilFirebase = [];
      materiSelesaiFirebase = {};
    });

    await _muatDataKelas(
      tampilkanLoading: tampilkanLoading,
    );
  }

  void _kosongkanDataKelas() {
    if (!mounted) return;

    setState(() {
      idKelas = null;
      namaKelas = null;
      kodeKelas = null;

      daftarMateriFirebase = [];
      daftarTantanganFirebase = [];
      daftarHasilFirebase = [];
      materiSelesaiFirebase = {};

      sedangMemuatData = false;
    });
  }

  // ============================================================
  // MEMUAT MATERI, TANTANGAN, HASIL, DAN PROGRESS
  // SESUAI KELAS YANG SEDANG DIPILIH
  // ============================================================

  Future<void> _muatDataKelas({
    bool tampilkanLoading = true,
  }) async {
    final user = _user;
    final kodeAktif = kodeKelas;
    final namaAktif = namaKelas;

    if (user == null || kodeAktif == null) {
      _kosongkanDataKelas();
      return;
    }

    if (tampilkanLoading && mounted) {
      setState(() {
        sedangMemuatData = true;
      });
    }

    try {
      final hasilMateri = await _firestore
          .collection('materi')
          .where('kodeKelas', isEqualTo: kodeAktif)
          .get();

      final hasilTantangan = await _firestore
          .collection('tantangan')
          .where('kodeKelas', isEqualTo: kodeAktif)
          .get();

      final hasilSiswa = await _firestore
          .collection('hasil_tantangan')
          .where('uid', isEqualTo: user.uid)
          .get();

      final hasilProgress = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('progress_materi')
          .where('kodeKelas', isEqualTo: kodeAktif)
          .get();

      final materiBaru = hasilMateri.docs.map((doc) {
        final data = doc.data();

        return <String, String>{
          'id': doc.id,
          'namaKelas': (data['namaKelas'] ?? '').toString(),
          'kodeKelas': (data['kodeKelas'] ?? '').toString(),
          'judul': (data['judul'] ?? '').toString(),
          'isi': (data['isi'] ?? '').toString(),
          'deskripsi': (data['deskripsi'] ?? '').toString(),
          'sumber': (data['sumber'] ?? '').toString(),
          'link': (data['link'] ?? '').toString(),
        };
      }).where((item) {
        return item['namaKelas'] == namaAktif;
      }).toList();

      final tantanganBaru = hasilTantangan.docs
          .map((doc) => <String, dynamic>{
                ...doc.data(),
                'id': doc.id,
              })
          .where((item) {
        return item['namaKelas'] == namaAktif;
      }).toList();

      final hasilBaru = hasilSiswa.docs
          .map((doc) => <String, dynamic>{
                ...doc.data(),
                'id': doc.id,
              })
          .where((item) {
        return item['kodeKelas'] == kodeAktif;
      }).toList();

      final materiSelesai = hasilProgress.docs
          .where((doc) => doc.data()['selesai'] == true)
          .map((doc) => (doc.data()['idMateri'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toSet();

      if (!mounted) return;

      // Mencegah data kelas lama menimpa kelas yang baru dipilih.
      if (kodeKelas != kodeAktif || idKelas == null) return;

      setState(() {
        daftarMateriFirebase = materiBaru;
        daftarTantanganFirebase = tantanganBaru;
        daftarHasilFirebase = hasilBaru;
        materiSelesaiFirebase = materiSelesai;
        sedangMemuatData = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat data kelas: $e');

      if (mounted) {
        setState(() {
          sedangMemuatData = false;
        });

        _tampilkanPesan(
          'Gagal memuat materi, tantangan, atau progress.',
        );
      }
    }
  }

  List<Map<String, String>> get materiKelas => daftarMateriFirebase;

  List<Map<String, dynamic>> get tantanganKelas =>
      daftarTantanganFirebase;

  List<Map<String, dynamic>> get hasilKelas => daftarHasilFirebase;

  // ============================================================
  // PERHITUNGAN PROGRESS
  // ============================================================

  bool _tantanganSudahDikerjakan(
    Map<String, dynamic> tantangan,
  ) {
    final idTantangan = (tantangan['id'] ?? '').toString();
    final judul = (tantangan['judul'] ?? '').toString();

    return hasilKelas.any((hasil) {
      final idHasil = (hasil['idTantangan'] ?? '').toString();
      final judulHasil = (hasil['judulTantangan'] ?? '').toString();

      return (idTantangan.isNotEmpty && idHasil == idTantangan) ||
          (judul.isNotEmpty && judulHasil == judul);
    });
  }

  int get jumlahMateriSelesai {
    return daftarMateriFirebase.where((materi) {
      return materiSelesaiFirebase.contains(materi['id']);
    }).length;
  }

  int get jumlahTantanganSelesai {
    return daftarTantanganFirebase.where(_tantanganSudahDikerjakan).length;
  }

  double get progressBelajar {
    final total = materiKelas.length + tantanganKelas.length;

    if (total == 0) return 0;

    final selesai = jumlahMateriSelesai + jumlahTantanganSelesai;

    return (selesai / total).clamp(0.0, 1.0);
  }

  void _tampilkanPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  // ============================================================
  // BUILD UTAMA
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: sedangMemuatKelas
            ? Center(
                child: CircularProgressIndicator(color: royalBlue),
              )
            : _buildHomeContent(),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      color: royalBlue,
      onRefresh: _muatKelasDiikuti,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            _buildClassCard(),
            const SizedBox(height: 24),
            _buildSectionTitle(
              'Perjalanan Belajar',
              'Mulai perjalanan belajarmu',
            ),
            const SizedBox(height: 14),
            _buildLearningJourney(),
            const SizedBox(height: 24),
            _buildSectionTitle(
              'Lanjutkan Belajar',
              namaKelas == null
                  ? 'Materi akan muncul setelah kamu bergabung'
                  : 'Materi dari $namaKelas',
            ),
            const SizedBox(height: 14),
            _buildLearningCard(),
            const SizedBox(height: 24),
            _buildSectionTitle(
              'Tantangan',
              'Selesaikan tantangan dari kelasmu',
            ),
            const SizedBox(height: 14),
            _buildChallengeCard(),
            const SizedBox(height: 24),
            _buildProgressCard(),
            const SizedBox(height: 24),
            _buildAchievementCard(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [royalBlue, skyBlue],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.public_rounded,
            color: Colors.white,
            size: 27,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MindSphere',
                style: TextStyle(
                  color: deepBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Dashboard Siswa',
                style: TextStyle(color: mutedBlue, fontSize: 12),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: _showNotificationDialog,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: paleBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: royalBlue,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // WELCOME CARD
  // ============================================================

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [deepBlue, royalBlue],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $namaSiswaAktif! 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Siap memulai perjalanan belajar hari ini?',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KELAS SAYA - MENAMPILKAN SEMUA KELAS
  // ============================================================

  Widget _buildClassCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: paleBlue),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBox(
                Icons.class_rounded,
                paleBlue,
                royalBlue,
                45,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelas Saya',
                      style: TextStyle(
                        color: textBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${daftarKelasDiikuti.length} kelas diikuti',
                      style: TextStyle(
                        color: mutedBlue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (daftarKelasDiikuti.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F9FF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: royalBlue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Kamu belum bergabung dengan kelas. Masukkan kode kelas dari guru untuk mulai belajar.',
                      style: TextStyle(
                        color: textBlue,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...daftarKelasDiikuti.map((kelas) {
              final aktif = kelas['id'] == idKelas;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: aktif
                      ? const Color(0xFFEAF2FF)
                      : const Color(0xFFF8FAFE),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: aktif ? royalBlue : paleBlue,
                    width: aktif ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.school_rounded,
                          color: royalBlue,
                          size: 22,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            kelas['namaKelas'] ?? 'Kelas',
                            style: TextStyle(
                              color: textBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (aktif)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: royalBlue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Dipilih',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.key_rounded,
                          color: mutedBlue,
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          kelas['kodeKelas'] ?? '',
                          style: TextStyle(
                            color: mutedBlue,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 11),
                    SizedBox(
                      width: double.infinity,
                      height: 39,
                      child: ElevatedButton(
                        onPressed: aktif
                            ? _openClass
                            : () => _pilihKelas(kelas),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: aktif
                              ? deepBlue
                              : royalBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: Text(
                          aktif ? 'Masuk Kelas' : 'Pilih Kelas',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: sedangGabung ? null : _showJoinClassDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Gabung Kelas Lain',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: royalBlue,
                side: BorderSide(color: royalBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBox(
    IconData icon,
    Color background,
    Color foreground,
    double size,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        icon,
        color: foreground,
        size: size * 0.56,
      ),
    );
  }

  // ============================================================
  // GABUNG KELAS LAIN
  // ============================================================

  void _showJoinClassDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (contextDialog, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: Text(
                'Gabung Kelas',
                style: TextStyle(
                  color: deepBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masukkan kode kelas lain yang diberikan oleh guru.',
                    style: TextStyle(
                      color: mutedBlue,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.characters,
                    enabled: !sedangGabung,
                    decoration: InputDecoration(
                      hintText: 'Contoh: PDX-01',
                      prefixIcon: Icon(
                        Icons.key_rounded,
                        color: royalBlue,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: sedangGabung
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(
                    'Batal',
                    style: TextStyle(color: mutedBlue),
                  ),
                ),
                ElevatedButton(
                  onPressed: sedangGabung
                      ? null
                      : () async {
                          final kode =
                              controller.text.trim().toUpperCase();

                          if (kode.isEmpty) {
                            _tampilkanPesan('Kode kelas harus diisi.');
                            return;
                          }

                          final user = _user;

                          if (user == null) {
                            _tampilkanPesan(
                              'Silakan login kembali.',
                            );
                            return;
                          }

                          setState(() => sedangGabung = true);
                          setDialogState(() {});

                          try {
                            // Cari kelas berdasarkan kode.
                            final hasilCari = await _kelasCollection
                                .where('kode', isEqualTo: kode)
                                .limit(1)
                                .get();

                            if (hasilCari.docs.isEmpty) {
                              // Mendukung data kelas yang menggunakan kodeKelas.
                              final hasilAlternatif =
                                  await _kelasCollection
                                      .where(
                                        'kodeKelas',
                                        isEqualTo: kode,
                                      )
                                      .limit(1)
                                      .get();

                              if (hasilAlternatif.docs.isEmpty) {
                                throw Exception(
                                  'Kode kelas tidak ditemukan. Periksa kembali kode dari guru.',
                                );
                              }

                              await _prosesGabungKelas(
                                user,
                                hasilAlternatif.docs.first,
                                dialogContext,
                              );
                            } else {
                              await _prosesGabungKelas(
                                user,
                                hasilCari.docs.first,
                                dialogContext,
                              );
                            }
                          } catch (e) {
                            debugPrint('Gagal gabung kelas: $e');

                            if (mounted) {
                              setState(() => sedangGabung = false);
                            }

                            setDialogState(() {});

                            final pesan = e
                                .toString()
                                .replaceFirst('Exception: ', '');

                            _tampilkanPesan('Gagal bergabung: $pesan');
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: sedangGabung
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Gabung'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) => controller.dispose());
  }

  Future<void> _prosesGabungKelas(
    User user,
    QueryDocumentSnapshot<Map<String, dynamic>> kelasDoc,
    BuildContext dialogContext,
  ) async {
    final dataKelas = kelasDoc.data();

    final namaBaru = (dataKelas['nama'] ??
            dataKelas['namaKelas'] ??
            '')
        .toString();

    final kodeBaru = (dataKelas['kode'] ??
            dataKelas['kodeKelas'] ??
            '')
        .toString();

    if (namaBaru.isEmpty || kodeBaru.isEmpty) {
      throw Exception('Data kelas di Firestore belum lengkap.');
    }

    final profil = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    final dataProfil = profil.data() ?? {};
    final role = (dataProfil['role'] ?? '').toString();

    if (role.isNotEmpty && role.toLowerCase() != 'siswa') {
      throw Exception('Akun ini bukan akun siswa.');
    }

    final namaSiswa = (dataProfil['name'] ??
            dataProfil['nama'] ??
            dataProfil['namaLengkap'] ??
            user.displayName ??
            'Siswa')
        .toString();

    final anggotaRef = _kelasCollection
        .doc(kelasDoc.id)
        .collection('anggota')
        .doc(user.uid);

    final kelasDiikutiRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('kelas_diikuti')
        .doc(kelasDoc.id);

    // Periksa apakah siswa sudah menjadi anggota kelas ini.
    final anggotaLama = await anggotaRef.get();
    final keanggotaanLama = await kelasDiikutiRef.get();

    if (anggotaLama.exists && keanggotaanLama.exists) {
      await _muatKelasDiikuti(pilihId: kelasDoc.id);

      if (!mounted) return;

      Navigator.pop(dialogContext);
      setState(() => sedangGabung = false);

      _tampilkanPesan(
        'Kamu sudah bergabung dengan kelas $namaBaru.',
      );
      return;
    }

    // Hanya menambahkan dokumen yang belum ada.
    // Keanggotaan kelas lain tidak dihapus atau ditimpa.
    final batch = _firestore.batch();

    if (!anggotaLama.exists) {
      batch.set(anggotaRef, {
        'uidSiswa': user.uid,
        'namaSiswa': namaSiswa,
        'namaKelas': namaBaru,
        'kodeKelas': kodeBaru,
        'joinedAt': FieldValue.serverTimestamp(),
      });
    }

    if (!keanggotaanLama.exists) {
      batch.set(kelasDiikutiRef, {
        'idKelas': kelasDoc.id,
        'namaKelas': namaBaru,
        'kodeKelas': kodeBaru,
        'joinedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();

    if (!mounted) return;

    setState(() {
      namaSiswaAktif = namaSiswa;
      sedangGabung = false;
    });

    // Muat semua kelas dan pilih kelas yang baru saja diikuti.
    await _muatKelasDiikuti(pilihId: kelasDoc.id);

    if (!mounted) return;

    Navigator.pop(dialogContext);

    _tampilkanPesan(
      'Berhasil bergabung ke kelas $namaBaru.',
    );
  }

  // ============================================================
  // MEMBUKA DETAIL KELAS
  // ============================================================

  void _openClass() {
    if (namaKelas == null || kodeKelas == null) {
      _tampilkanPesan(
        'Gabung kelas terlebih dahulu untuk mengakses pembelajaran.',
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailKelasSiswaPage(
          namaKelas: namaKelas!,
          kodeKelas: kodeKelas!,
        ),
      ),
    ).then((_) {
      if (mounted) {
        _muatDataKelas();
      }
    });
  }

  // ============================================================
  // JUDUL BAGIAN
  // ============================================================

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: mutedBlue,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PERJALANAN BELAJAR
  // ============================================================

  Widget _buildLearningJourney() {
    final sudahBergabung = kodeKelas != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: paleBlue),
      ),
      child: Column(
        children: [
          _journeyItem(
            icon: Icons.menu_book_rounded,
            title: 'Materi',
            subtitle: sudahBergabung
                ? '${materiKelas.length} materi tersedia'
                : 'Belum dimulai',
            active: materiKelas.isNotEmpty,
          ),
          _journeyLine(),
          _journeyItem(
            icon: Icons.explore_rounded,
            title: 'Eksplorasi',
            subtitle: sudahBergabung
                ? 'Jelajahi materi kelas'
                : 'Belum dimulai',
            active: sudahBergabung,
          ),
          _journeyLine(),
          _journeyItem(
            icon: Icons.flag_rounded,
            title: 'Tantangan',
            subtitle: sudahBergabung
                ? '${tantanganKelas.length} tantangan tersedia'
                : 'Belum dimulai',
            active: tantanganKelas.isNotEmpty,
          ),
        ],
      ),
    );
  }

  Widget _journeyItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool active,
  }) {
    return InkWell(
      onTap: _openClass,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: active ? royalBlue : const Color(0xFFEAF1FC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: active ? Colors.white : mutedBlue,
                size: 22,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: mutedBlue,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: mutedBlue,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _journeyLine() {
    return Container(
      margin: const EdgeInsets.only(left: 21, top: 4, bottom: 4),
      width: 2,
      height: 25,
      color: paleBlue,
    );
  }

  // ============================================================
  // KARTU MATERI
  // ============================================================

  Widget _buildLearningCard() {
    if (kodeKelas == null || materiKelas.isEmpty) {
      return _emptyCard(
        icon: Icons.menu_book_outlined,
        title: 'Belum ada materi',
        description: kodeKelas == null
            ? 'Bergabung dengan kelas terlebih dahulu untuk melihat materi.'
            : 'Guru belum menambahkan materi untuk kelas ini.',
      );
    }

    final materi = materiKelas.first;

    return InkWell(
      onTap: _openClass,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: paleBlue),
        ),
        child: Row(
          children: [
            _iconBox(Icons.menu_book_rounded, paleBlue, royalBlue, 55),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Materi Terbaru',
                    style: TextStyle(color: mutedBlue, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    materi['judul'] ?? 'Materi',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${materiKelas.length} materi tersedia',
                    style: TextStyle(color: mutedBlue, fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: mutedBlue,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return InkWell(
      onTap: _openClass,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: paleBlue),
        ),
        child: Column(
          children: [
            _iconBox(icon, paleBlue, royalBlue, 58),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: textBlue,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedBlue,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // KARTU TANTANGAN
  // ============================================================

  Widget _buildChallengeCard() {
    if (kodeKelas == null || tantanganKelas.isEmpty) {
      return _emptyCard(
        icon: Icons.flag_outlined,
        title: 'Belum ada tantangan',
        description: kodeKelas == null
            ? 'Tantangan akan tersedia setelah kamu bergabung dengan kelas.'
            : 'Guru belum menambahkan tantangan untuk kelas ini.',
      );
    }

    final tantangan = tantanganKelas.first;

    return InkWell(
      onTap: _openClass,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: paleBlue),
        ),
        child: Row(
          children: [
            _iconBox(
              Icons.flag_rounded,
              const Color(0xFFEAF1FC),
              royalBlue,
              52,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tantangan Terbaru',
                    style: TextStyle(color: mutedBlue, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tantangan['judul'] ??
                        tantangan['nama'] ??
                        'Tantangan',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${tantanganKelas.length} tantangan tersedia',
                    style: TextStyle(color: mutedBlue, fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: mutedBlue,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROGRESS BELAJAR
  // ============================================================

  Widget _buildProgressCard() {
    final jumlahMateri = materiKelas.length;
    final jumlahTantangan = tantanganKelas.length;
    final jumlahSelesai =
        jumlahMateriSelesai + jumlahTantanganSelesai;

    final persentase = (progressBelajar * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2166D5),
            Color(0xFF398CEB),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: royalBlue.withOpacity(0.18),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Progress Belajar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            kodeKelas == null
                ? 'Bergabung dengan kelas untuk mulai belajar.'
                : 'Progress kelas $namaKelas',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$persentase%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '$jumlahSelesai aktivitas selesai',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progressBelajar,
              minHeight: 9,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              _progressInfo(
                Icons.menu_book_rounded,
                '$jumlahMateriSelesai/$jumlahMateri',
                'Materi selesai',
              ),
              const SizedBox(width: 12),
              _progressInfo(
                Icons.flag_rounded,
                '$jumlahTantanganSelesai/$jumlahTantangan',
                'Tantangan selesai',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressInfo(
    IconData icon,
    String value,
    String label,
  ) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PENCAPAIAN
  // ============================================================

  Widget _buildAchievementCard() {
    final jumlahHasil = hasilKelas.length;
    final punyaPencapaian = jumlahHasil > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: paleBlue),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: punyaPencapaian
                  ? const Color(0xFFFFF2D9)
                  : const Color(0xFFEAF1FC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.emoji_events_rounded,
              color: punyaPencapaian ? Colors.orange : mutedBlue,
              size: 29,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  punyaPencapaian
                      ? 'Terus pertahankan!'
                      : 'Mulai kumpulkan pencapaian',
                  style: TextStyle(
                    color: textBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  punyaPencapaian
                      ? 'Kamu sudah memiliki $jumlahHasil hasil aktivitas belajar di kelas ini.'
                      : 'Kerjakan tantangan untuk mulai mendapatkan hasil belajar.',
                  style: TextStyle(
                    color: mutedBlue,
                    fontSize: 11.5,
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

  // ============================================================
  // NOTIFIKASI
  // ============================================================

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.notifications_active_rounded,
                color: royalBlue,
              ),
              const SizedBox(width: 10),
              Text(
                'Notifikasi',
                style: TextStyle(
                  color: textBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            daftarKelasDiikuti.isEmpty
                ? 'Kamu belum bergabung dengan kelas. Masukkan kode kelas dari guru untuk mulai belajar.'
                : 'Kamu sudah bergabung dengan ${daftarKelasDiikuti.length} kelas. Pilih kelas yang ingin kamu pelajari.',
            style: TextStyle(
              color: mutedBlue,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Tutup',
                style: TextStyle(
                  color: royalBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 9,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomNavItem(
                Icons.home_rounded,
                'Beranda',
                true,
                () {},
              ),
              _bottomNavItem(
                Icons.menu_book_rounded,
                'Belajar',
                false,
                _openClass,
              ),
              _bottomNavItem(
                Icons.person_rounded,
                'Profil',
                false,
                _handleBottomNavigation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavItem(
    IconData icon,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active ? royalBlue : mutedBlue,
              size: 23,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? royalBlue : mutedBlue,
                fontSize: 10,
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBottomNavigation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfilSiswaPage(),
      ),
    );
  }
}
