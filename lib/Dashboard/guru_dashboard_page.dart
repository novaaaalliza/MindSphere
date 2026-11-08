
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'detail_kelas_guru_page.dart';
import 'kelola_materi_page.dart';
import 'kelola_tantangan_page.dart';
import 'hasil_siswa_page.dart';
import 'profil_guru_page.dart';

class GuruDashboardPage extends StatefulWidget {
  const GuruDashboardPage({super.key});

  @override
  State<GuruDashboardPage> createState() =>
      _GuruDashboardPageState();
}

class _GuruDashboardPageState extends State<GuruDashboardPage> {
  int selectedIndex = 0;

  static const Color royalBlue = Color(0xFF2166D5);
  static const Color deepBlue = Color(0xFF123B70);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  User? get user => FirebaseAuth.instance.currentUser;

  late Future<Map<String, int>> ringkasanFuture;
  late Future<List<Map<String, dynamic>>> aktivitasFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // ============================================================
  // REFRESH DATA FIRESTORE
  // ============================================================

  void _refreshData() {
    ringkasanFuture = _muatRingkasan();
    aktivitasFuture = _muatAktivitas();
  }

  Future<void> _refreshDashboard() async {
    if (!mounted) return;

    setState(() {
      _refreshData();
    });

    await Future.wait([
      ringkasanFuture,
      aktivitasFuture,
    ]);
  }

  // ============================================================
  // KODE KELAS OTOMATIS
  // ============================================================

  String generateKodeKelas(String namaKelas, int nomor) {
    final words = namaKelas
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    String kode;

    if (words.length >= 2) {
      kode = words
          .take(3)
          .map((word) => word[0].toUpperCase())
          .join();
    } else if (words.isNotEmpty) {
      kode = words.first.length >= 3
          ? words.first.substring(0, 3).toUpperCase()
          : words.first.toUpperCase();
    } else {
      kode = 'KLS';
    }

    return '$kode-${nomor.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // MEMBUAT KODE KELAS UNIK
  // ============================================================

  Future<String> generateKodeKelasUnik(
    String namaKelas,
  ) async {
    int nomor = 1;

    while (true) {
      final kode = generateKodeKelas(
        namaKelas,
        nomor,
      );

      final hasil = await firestore
          .collection('kelas')
          .where('kode', isEqualTo: kode)
          .limit(1)
          .get();

      if (hasil.docs.isEmpty) {
        return kode;
      }

      nomor++;
    }
  }

  // ============================================================
  // MEMUAT RINGKASAN DARI FIRESTORE
  // ============================================================

  Future<Map<String, int>> _muatRingkasan() async {
    final currentUser = user;

    if (currentUser == null) {
      return {
        'siswa': 0,
        'materi': 0,
        'tantangan': 0,
      };
    }

    try {
      final kelasSnapshot = await firestore
          .collection('kelas')
          .where('uidGuru', isEqualTo: currentUser.uid)
          .get();

      int totalSiswa = 0;
      int totalMateri = 0;
      int totalTantangan = 0;

      final pekerjaan = kelasSnapshot.docs.map((kelas) async {
        final kode = kelas.data()['kode']?.toString() ?? '';

        if (kode.isEmpty) return;

        final hasil = await Future.wait([
          firestore
              .collection('kelas')
              .doc(kelas.id)
              .collection('anggota')
              .get(),

          firestore
              .collection('materi')
              .where('kodeKelas', isEqualTo: kode)
              .get(),

          firestore
              .collection('tantangan')
              .where('kodeKelas', isEqualTo: kode)
              .get(),
        ]);

        totalSiswa += hasil[0].docs.length;
        totalMateri += hasil[1].docs.length;
        totalTantangan += hasil[2].docs.length;
      });

      await Future.wait(pekerjaan);

      return {
        'siswa': totalSiswa,
        'materi': totalMateri,
        'tantangan': totalTantangan,
      };
    } catch (e) {
      debugPrint('Gagal memuat ringkasan: $e');

      return {
        'siswa': 0,
        'materi': 0,
        'tantangan': 0,
      };
    }
  }

  // ============================================================
  // MEMUAT AKTIVITAS TERBARU DARI FIRESTORE
  // ============================================================

  Future<List<Map<String, dynamic>>> _muatAktivitas() async {
    final currentUser = user;

    if (currentUser == null) return [];

    try {
      final kelasSnapshot = await firestore
          .collection('kelas')
          .where('uidGuru', isEqualTo: currentUser.uid)
          .get();

      final List<Map<String, dynamic>> semuaAktivitas = [];

      final pekerjaan = kelasSnapshot.docs.map((kelas) async {
        final dataKelas = kelas.data();

        final kodeKelas =
            dataKelas['kode']?.toString() ?? '';

        final namaKelas =
            dataKelas['nama']?.toString() ?? '';

        if (kodeKelas.isEmpty) return;

        final hasilSnapshot = await firestore
            .collection('hasil_tantangan')
            .where('kodeKelas', isEqualTo: kodeKelas)
            .get();

        for (final doc in hasilSnapshot.docs) {
          final data = doc.data();

          semuaAktivitas.add({
            'tipe': 'tantangan',
            'judul':
                '${data['namaSiswa'] ?? 'Siswa'} mengerjakan tantangan',
            'deskripsi':
                '${data['judulTantangan'] ?? 'Tantangan'} • $namaKelas',
            'waktu': data['createdAt'] ?? data['tanggal'],
            'nilai': data['nilai'],
          });
        }
      });

      await Future.wait(pekerjaan);

      semuaAktivitas.sort((a, b) {
        DateTime waktuA = _ambilWaktu(a['waktu']);
        DateTime waktuB = _ambilWaktu(b['waktu']);

        return waktuB.compareTo(waktuA);
      });

      return semuaAktivitas.take(5).toList();
    } catch (e) {
      debugPrint('Gagal memuat aktivitas: $e');
      return [];
    }
  }

  DateTime _ambilWaktu(dynamic waktu) {
    if (waktu is Timestamp) {
      return waktu.toDate();
    }

    if (waktu is DateTime) {
      return waktu;
    }

    return DateTime(2000);
  }

  // ============================================================
  // BUAT KELAS
  // ============================================================

  void showBuatKelasDialog() {
    final namaKelasController = TextEditingController();
    bool sedangMenyimpan = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (contextDialog, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                'Buat Kelas Baru',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textBlue,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Masukkan nama kelas yang ingin dibuat.',
                    style: TextStyle(
                      color: mutedBlue,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: namaKelasController,
                    enabled: !sedangMenyimpan,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Nama Kelas',
                      hintText: 'Contoh: Pemrograman Dasar X',
                      prefixIcon: const Icon(
                        Icons.class_rounded,
                        color: royalBlue,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F8FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: royalBlue,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(
                20, 0, 20, 18,
              ),
              actions: [
                TextButton(
                  onPressed: sedangMenyimpan
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: mutedBlue),
                  ),
                ),
                ElevatedButton(
                  onPressed: sedangMenyimpan
                      ? null
                      : () async {
                          final namaKelas =
                              namaKelasController.text.trim();

                          if (namaKelas.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Nama kelas harus diisi.',
                                ),
                              ),
                            );
                            return;
                          }

                          final currentUser = user;

                          if (currentUser == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Silakan login terlebih dahulu.',
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() {
                            sedangMenyimpan = true;
                          });

                          try {
                            final kodeKelas =
                                await generateKodeKelasUnik(
                              namaKelas,
                            );

                            await firestore
                                .collection('kelas')
                                .add({
                              'nama': namaKelas,
                              'kode': kodeKelas,
                              'jumlahSiswa': 0,
                              'uidGuru': currentUser.uid,
                              'createdAt':
                                  FieldValue.serverTimestamp(),
                            });

                            if (!mounted) return;

                            Navigator.pop(dialogContext);

                            await _refreshDashboard();

                            if (!mounted) return;

                            showKodeKelasDialog(
                              namaKelas,
                              kodeKelas,
                            );
                          } catch (e) {
                            setDialogState(() {
                              sedangMenyimpan = false;
                            });

                            if (!mounted) return;

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Gagal membuat kelas: $e',
                                ),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: sedangMenyimpan
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Buat Kelas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      namaKelasController.dispose();
    });
  }

  // ============================================================
  // DIALOG KODE KELAS
  // ============================================================

  void showKodeKelasDialog(
    String namaKelas,
    String kodeKelas,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: paleBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: royalBlue,
                  size: 42,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Kelas Berhasil Dibuat!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                namaKelas,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: mutedBlue,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Kode Kelas',
                style: TextStyle(
                  fontSize: 13,
                  color: mutedBlue,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: paleBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kodeKelas,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: royalBlue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: 'Salin kode',
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: kodeKelas),
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Kode kelas berhasil disalin.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.copy_rounded,
                        color: royalBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bagikan kode ini kepada siswa agar mereka dapat bergabung ke kelas.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: mutedBlue,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: royalBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SALIN KODE
  // ============================================================

  void salinKode(String kode) {
    Clipboard.setData(
      ClipboardData(text: kode),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kode kelas berhasil disalin.'),
      ),
    );
  }

  // ============================================================
  // NAVIGASI MATERI
  // ============================================================

  Future<void> bukaMateri() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const KelolaMateriPage(),
      ),
    );

    if (mounted) {
      await _refreshDashboard();
    }
  }

  // ============================================================
  // NAVIGASI TANTANGAN
  // ============================================================

  Future<void> bukaTantangan() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const KelolaTantanganPage(),
      ),
    );

    if (mounted) {
      await _refreshDashboard();
    }
  }

  // ============================================================
  // NAVIGASI HASIL
  // ============================================================

  Future<void> bukaHasil() async {
    final currentUser = user;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu.'),
        ),
      );
      return;
    }

    try {
      final hasil = await firestore
          .collection('kelas')
          .where('uidGuru', isEqualTo: currentUser.uid)
          .limit(1)
          .get();

      if (!mounted) return;

      if (hasil.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Buat kelas terlebih dahulu untuk melihat hasil siswa.',
            ),
          ),
        );
        return;
      }

      final kelas = hasil.docs.first.data();

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HasilSiswaPage(
            namaKelas: kelas['nama']?.toString() ?? '',
            kodeKelas: kelas['kode']?.toString() ?? '',
          ),
        ),
      );

      if (mounted) {
        await _refreshDashboard();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka hasil siswa: $e'),
        ),
      );
    }
  }

  // ============================================================
  // NAVIGASI PROFIL
  // ============================================================

  Future<void> bukaProfil() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilGuruPage(),
      ),
    );
  }

  // ============================================================
  // NOTIFIKASI
  // ============================================================

  void bukaNotifikasi() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.notifications_rounded,
                color: royalBlue,
              ),
              SizedBox(width: 10),
              Text(
                'Notifikasi',
                style: TextStyle(
                  color: textBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: mutedBlue,
                size: 45,
              ),
              SizedBox(height: 10),
              Text(
                'Belum ada notifikasi baru.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: mutedBlue,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Tutup',
                style: TextStyle(color: royalBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [royalBlue, skyBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.public_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MindSphere',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: textBlue,
                ),
              ),
              Text(
                'Dashboard Guru',
                style: TextStyle(
                  fontSize: 12,
                  color: mutedBlue,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: bukaNotifikasi,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: textBlue,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // WELCOME CARD
  // ============================================================

  Widget buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [royalBlue, Color(0xFF4C9BF5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: royalBlue.withOpacity(0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang, Guru! 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bangun perjalanan belajar siswa bersama MindSphere.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: showBuatKelasDialog,
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 19,
                  ),
                  label: const Text('Buat Kelas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: royalBlue,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KELAS SAYA - FIRESTORE
  // ============================================================

  Widget buildKelasSaya() {
    final currentUser = user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Kelas Saya',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textBlue,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: showBuatKelasDialog,
              icon: const Icon(
                Icons.add_rounded,
                size: 18,
              ),
              label: const Text('Buat Kelas'),
              style: TextButton.styleFrom(
                foregroundColor: royalBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (currentUser == null)
          buildEmptyClass()
        else
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: firestore
                .collection('kelas')
                .where('uidGuru', isEqualTo: currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Gagal memuat kelas dari Firebase.',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      color: royalBlue,
                    ),
                  ),
                );
              }

              final daftarKelas = snapshot.data?.docs ?? [];

              if (daftarKelas.isEmpty) {
                return buildEmptyClass();
              }

              return Column(
                children: daftarKelas.map((doc) {
                  final data = doc.data();

                  final nama =
                      data['nama']?.toString() ?? '';

                  final kode =
                      data['kode']?.toString() ?? '';

                  return StreamBuilder<
                      QuerySnapshot<Map<String, dynamic>>>(
                    stream: firestore
                        .collection('kelas')
                        .doc(doc.id)
                        .collection('anggota')
                        .snapshots(),
                    builder: (context, anggotaSnapshot) {
                      final jumlahSiswa =
                          anggotaSnapshot.data?.docs.length ?? 0;

                      return buildClassCard(
                        nama,
                        kode,
                        jumlahSiswa,
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }

  // ============================================================
  // EMPTY CLASS
  // ============================================================

  Widget buildEmptyClass() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE4EBF5),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              color: paleBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.class_outlined,
              color: royalBlue,
              size: 32,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Belum Ada Kelas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textBlue,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Buat kelas terlebih dahulu untuk mulai mengelola pembelajaran siswa.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: mutedBlue,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: showBuatKelasDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Buat Kelas'),
            style: ElevatedButton.styleFrom(
              backgroundColor: royalBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CARD KELAS
  // ============================================================

  Widget buildClassCard(
    String nama,
    String kode,
    int jumlahSiswa,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE1E9F5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: paleBlue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: royalBlue,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$jumlahSiswa Siswa',
                      style: const TextStyle(
                        fontSize: 12,
                        color: mutedBlue,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => salinKode(kode),
                tooltip: 'Salin kode',
                icon: const Icon(
                  Icons.copy_rounded,
                  color: royalBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F7FD),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.key_rounded,
                  color: royalBlue,
                  size: 20,
                ),
                const SizedBox(width: 9),
                const Text(
                  'Kode Kelas:',
                  style: TextStyle(
                    fontSize: 12,
                    color: mutedBlue,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  kode,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: textBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => salinKode(kode),
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 17,
                  ),
                  label: const Text('Salin Kode'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: royalBlue,
                    side: const BorderSide(color: royalBlue),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailKelasGuruPage(
                          namaKelas: nama,
                          kodeKelas: kode,
                          jumlahSiswa: jumlahSiswa,
                        ),
                      ),
                    );

                    if (mounted) {
                      await _refreshDashboard();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Lihat Kelas'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KELOLA PEMBELAJARAN
  // ============================================================

  Widget buildKelolaPembelajaran() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kelola Pembelajaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textBlue,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildMenuCard(
                icon: Icons.menu_book_rounded,
                title: 'Kelola Materi',
                subtitle: 'Tambah dan atur materi',
                onTap: bukaMateri,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildMenuCard(
                icon: Icons.quiz_rounded,
                title: 'Kelola Tantangan',
                subtitle: 'Buat kuis dan soal',
                onTap: bukaTantangan,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildMenuCard(
                icon: Icons.bar_chart_rounded,
                title: 'Hasil Siswa',
                subtitle: 'Lihat perkembangan siswa',
                onTap: bukaHasil,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildMenuCard(
                icon: Icons.person_rounded,
                title: 'Profil',
                subtitle: 'Kelola profil guru',
                onTap: bukaProfil,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // MENU CARD
  // ============================================================

  Widget buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE3EAF4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: paleBlue,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Icon(
                icon,
                color: royalBlue,
                size: 22,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: mutedBlue,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RINGKASAN PEMBELAJARAN - FIRESTORE
  // ============================================================

  Widget buildRingkasan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Pembelajaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textBlue,
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<Map<String, int>>(
          future: ringkasanFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: CircularProgressIndicator(
                    color: royalBlue,
                  ),
                ),
              );
            }

            final data = snapshot.data ?? {};

            return Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    icon: Icons.people_alt_rounded,
                    title: 'Siswa',
                    value: '${data['siswa'] ?? 0}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildStatCard(
                    icon: Icons.menu_book_rounded,
                    title: 'Materi',
                    value: '${data['materi'] ?? 0}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildStatCard(
                    icon: Icons.quiz_rounded,
                    title: 'Tantangan',
                    value: '${data['tantangan'] ?? 0}',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE3EAF4),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: royalBlue,
            size: 25,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textBlue,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: mutedBlue,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WAKTU AKTIVITAS
  // ============================================================

  String waktuRelatif(DateTime waktu) {
    final sekarang = DateTime.now();
    final selisih = sekarang.difference(waktu);

    if (selisih.isNegative || selisih.inSeconds < 10) {
      return 'Baru saja';
    }

    if (selisih.inMinutes < 1) {
      return '${selisih.inSeconds} detik lalu';
    }

    if (selisih.inMinutes < 60) {
      return '${selisih.inMinutes} menit lalu';
    }

    if (selisih.inHours < 24) {
      return '${selisih.inHours} jam lalu';
    }

    if (selisih.inDays < 7) {
      return '${selisih.inDays} hari lalu';
    }

    return '${waktu.day}/${waktu.month}/${waktu.year}';
  }

  // ============================================================
  // ICON AKTIVITAS
  // ============================================================

  IconData iconAktivitas(String tipe) {
    switch (tipe) {
      case 'gabung_kelas':
        return Icons.person_add_alt_1_rounded;
      case 'materi_selesai':
        return Icons.menu_book_rounded;
      case 'tantangan':
        return Icons.quiz_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  // ============================================================
  // WARNA ICON AKTIVITAS
  // ============================================================

  Color warnaAktivitas(String tipe) {
    switch (tipe) {
      case 'gabung_kelas':
        return skyBlue;
      case 'materi_selesai':
        return royalBlue;
      case 'tantangan':
        return const Color(0xFF7B61FF);
      default:
        return royalBlue;
    }
  }

  // ============================================================
  // CARD SATU AKTIVITAS
  // ============================================================

  Widget buildActivityItem(
    Map<String, dynamic> aktivitas,
  ) {
    final tipe = aktivitas['tipe']?.toString() ?? '';
    final judul = aktivitas['judul']?.toString() ?? '';
    final deskripsi =
        aktivitas['deskripsi']?.toString() ?? '';

    final waktuAktivitas =
        _ambilWaktu(aktivitas['waktu']);

    final nilai = aktivitas['nilai'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE7EDF6),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: warnaAktivitas(tipe).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconAktivitas(tipe),
              color: warnaAktivitas(tipe),
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  deskripsi,
                  style: const TextStyle(
                    fontSize: 12,
                    color: mutedBlue,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: mutedBlue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      waktuRelatif(waktuAktivitas),
                      style: const TextStyle(
                        fontSize: 10,
                        color: mutedBlue,
                      ),
                    ),
                    if (nilai != null) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: paleBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Nilai $nilai',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: royalBlue,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AKTIVITAS TERBARU - FIRESTORE
  // ============================================================

  Widget buildAktivitas() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: aktivitasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                color: royalBlue,
              ),
            ),
          );
        }

        final aktivitasTerbaru = snapshot.data ?? [];

        if (aktivitasTerbaru.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFE3EAF4),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: paleBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: royalBlue,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Belum Ada Aktivitas',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textBlue,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Aktivitas pengerjaan tantangan siswa akan muncul di sini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: mutedBlue,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFE3EAF4),
            ),
          ),
          child: Column(
            children: aktivitasTerbaru.map((aktivitas) {
              return buildActivityItem(aktivitas);
            }).toList(),
          ),
        );
      },
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget buildBottomNavigation() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            index: 0,
          ),
          buildNavItem(
            icon: Icons.menu_book_rounded,
            label: 'Materi',
            index: 1,
          ),
          buildNavItem(
            icon: Icons.quiz_rounded,
            label: 'Soal',
            index: 2,
          ),
          buildNavItem(
            icon: Icons.bar_chart_rounded,
            label: 'Hasil',
            index: 3,
          ),
          buildNavItem(
            icon: Icons.person_rounded,
            label: 'Profil',
            index: 4,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NAVIGATION ITEM
  // ============================================================

  Widget buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        switch (index) {
          case 0:
            break;
          case 1:
            bukaMateri();
            break;
          case 2:
            bukaTantangan();
            break;
          case 3:
            bukaHasil();
            break;
          case 4:
            bukaProfil();
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? paleBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 21,
              color: isSelected ? royalBlue : mutedBlue,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isSelected ? royalBlue : mutedBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FE),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: royalBlue,
                onRefresh: _refreshDashboard,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    20, 18, 20, 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(),
                      const SizedBox(height: 22),
                      buildWelcomeCard(),
                      const SizedBox(height: 26),
                      buildKelasSaya(),
                      const SizedBox(height: 26),
                      buildKelolaPembelajaran(),
                      const SizedBox(height: 26),
                      buildRingkasan(),
                      const SizedBox(height: 26),
                      const Text(
                        'Aktivitas Terbaru',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textBlue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      buildAktivitas(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            buildBottomNavigation(),
          ],
        ),
      ),
    );
  }
}
