import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'data_global.dart';
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

  String? namaKelas;
  String? kodeKelas;
  String? idKelas;

  bool sedangMemuatKelas = true;
  bool sedangGabung = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  CollectionReference<Map<String, dynamic>> get _kelasCollection =>
      FirebaseFirestore.instance.collection('kelas');

  @override
  void initState() {
    super.initState();
    _muatKelasDiikuti();
  }

  // ============================================================
  // MEMUAT KELAS DARI FIRESTORE
  // ============================================================

  Future<void> _muatKelasDiikuti() async {
    final user = _user;

    if (user == null) {
      if (mounted) {
        setState(() => sedangMemuatKelas = false);
      }
      return;
    }

    try {
      final daftarDiikuti = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('kelas_diikuti')
          .limit(1)
          .get();

      if (daftarDiikuti.docs.isEmpty) {
        if (mounted) {
          setState(() {
            namaKelas = null;
            kodeKelas = null;
            idKelas = null;
            sedangMemuatKelas = false;
          });
        }
        return;
      }

      final id = daftarDiikuti.docs.first.id;
      final dataKeanggotaan = daftarDiikuti.docs.first.data();

      final kelasDoc = await _kelasCollection.doc(id).get();

      if (!kelasDoc.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('kelas_diikuti')
            .doc(id)
            .delete();

        if (mounted) {
          setState(() {
            namaKelas = null;
            kodeKelas = null;
            idKelas = null;
            sedangMemuatKelas = false;
          });
        }
        return;
      }

      final dataKelas = kelasDoc.data() ?? {};

      final nama = (dataKelas['nama'] ??
              dataKelas['namaKelas'] ??
              dataKeanggotaan['namaKelas'] ??
              '')
          .toString();

      final kode = (dataKelas['kode'] ??
              dataKelas['kodeKelas'] ??
              dataKeanggotaan['kodeKelas'] ??
              '')
          .toString();

      if (mounted) {
        setState(() {
          namaKelas = nama;
          kodeKelas = kode;
          idKelas = id;
          sedangMemuatKelas = false;
        });
      }
    } catch (e) {
      debugPrint('Gagal memuat kelas siswa: $e');

      if (mounted) {
        setState(() => sedangMemuatKelas = false);

        _tampilkanPesan(
          'Gagal memuat kelas. Periksa koneksi dan aturan Firebase.',
        );
      }
    }
  }

  // ============================================================
  // DATA MATERI, TANTANGAN, DAN HASIL
  // ============================================================

  List<Map<String, String>> get materiKelas {
    if (kodeKelas == null || namaKelas == null) {
      return [];
    }

    return ambilMateriKelas(
      kodeKelas!,
      namaKelas!,
    );
  }

  List<Map<String, dynamic>> get tantanganKelas {
    if (kodeKelas == null || namaKelas == null) {
      return [];
    }

    return ambilTantanganKelas(
      kodeKelas!,
      namaKelas!,
    );
  }

  List<Map<String, dynamic>> get hasilKelas {
    if (kodeKelas == null) {
      return [];
    }

    return hasilSiswaDiKelas(kodeKelas!);
  }

  void _tampilkanPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  // ============================================================
  // HOME CONTENT
  // ============================================================

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),

          _buildWelcomeCard(),
          const SizedBox(height: 20),

          _buildClassCard(context),
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
                : 'Materi dari kelasmu',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: sedangMemuatKelas
            ? Center(
                child: CircularProgressIndicator(
                  color: royalBlue,
                ),
              )
            : _buildHomeContent(),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
                style: TextStyle(
                  color: mutedBlue,
                  fontSize: 12,
                ),
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
  // WELCOME
  // ============================================================

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [deepBlue, royalBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo, Siswa! 👋',
                  style: TextStyle(
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
  // KELAS SAYA
  // ============================================================

  Widget _buildClassCard(BuildContext context) {
    if (kodeKelas == null || namaKelas == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: paleBlue,
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 6),
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
                      const SizedBox(height: 3),
                      Text(
                        'Belum bergabung dengan kelas',
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
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F9FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: royalBlue,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Masukkan kode kelas dari guru untuk mulai belajar.',
                      style: TextStyle(
                        color: textBlue,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: sedangGabung
                    ? null
                    : () => _showJoinClassDialog(context),
                icon: const Icon(
                  Icons.add_rounded,
                  size: 21,
                ),
                label: const Text(
                  'Gabung Kelas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: royalBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [deepBlue, royalBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
              _iconBox(
                Icons.class_rounded,
                Colors.white.withOpacity(0.15),
                Colors.white,
                48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kelas Saya',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      namaKelas!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.key_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 9),
                const Text(
                  'Kode Kelas',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  kodeKelas!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: _openClass,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text(
                'Masuk Kelas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: royalBlue,
                elevation: 0,
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
  // OPEN CLASS
  // ============================================================

  void _openClass() {
    if (namaKelas == null || kodeKelas == null) {
      _showJoinClassMessage();
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
    );
  }

  void _showJoinClassMessage() {
    _tampilkanPesan(
      'Gabung kelas terlebih dahulu untuk mengakses pembelajaran.',
    );
  }

  // ============================================================
  // GABUNG KELAS - FIRESTORE
  // ============================================================

  void _showJoinClassDialog(BuildContext context) {
    final TextEditingController codeController =
        TextEditingController();

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
                    'Masukkan kode kelas yang diberikan oleh guru.',
                    style: TextStyle(
                      color: mutedBlue,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: codeController,
                    textCapitalization:
                        TextCapitalization.characters,
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
                      : () {
                          Navigator.pop(dialogContext);
                        },
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
                              codeController.text.trim().toUpperCase();

                          if (kode.isEmpty) {
                            _tampilkanPesan(
                              'Kode kelas harus diisi.',
                            );
                            return;
                          }

                          final user = _user;

                          if (user == null) {
                            _tampilkanPesan(
                              'Sesi login tidak ditemukan. Silakan login kembali.',
                            );
                            return;
                          }

                          setState(() {
                            sedangGabung = true;
                          });

                          setDialogState(() {});

                          try {
                            // MENCARI KELAS DI FIRESTORE
                            final hasilCari =
                                await _kelasCollection
                                    .where(
                                      'kode',
                                      isEqualTo: kode,
                                    )
                                    .limit(1)
                                    .get();

                            if (hasilCari.docs.isEmpty) {
                              if (mounted) {
                                setState(() {
                                  sedangGabung = false;
                                });
                              }

                              setDialogState(() {});

                              _tampilkanPesan(
                                'Kode kelas tidak ditemukan. Periksa kembali kode dari guru.',
                              );
                              return;
                            }

                            final kelasDoc =
                                hasilCari.docs.first;

                            final dataKelas =
                                kelasDoc.data();

                            final namaBaru =
                                (dataKelas['nama'] ??
                                        dataKelas['namaKelas'] ??
                                        '')
                                    .toString();

                            final kodeBaru =
                                (dataKelas['kode'] ?? '')
                                    .toString();

                            if (namaBaru.isEmpty ||
                                kodeBaru.isEmpty) {
                              throw Exception(
                                'Data kelas di Firestore belum lengkap.',
                              );
                            }

                            // MENGAMBIL NAMA SISWA
                            String namaSiswa =
                                namaSiswaAktif;

                            final profil =
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .get();

                            if (profil.exists) {
                              final dataProfil =
                                  profil.data() ?? {};

                              namaSiswa =
                                  (dataProfil['nama'] ??
                                          dataProfil['name'] ??
                                          dataProfil['namaLengkap'] ??
                                          namaSiswaAktif)
                                      .toString();
                            }

                            // MEMASTIKAN ROLE SISWA
                            final role =
                                (profil.data()?['role'] ?? '')
                                    .toString();

                            if (role.isNotEmpty &&
                                role.toLowerCase() != 'siswa') {
                              throw Exception(
                                'Akun ini bukan akun siswa.',
                              );
                            }

                            // MEMBUAT FIRESTORE BATCH
                            final batch =
                                FirebaseFirestore.instance.batch();

                            // REFERENSI ANGGOTA KELAS
                            final anggotaRef =
                                _kelasCollection
                                    .doc(kelasDoc.id)
                                    .collection('anggota')
                                    .doc(user.uid);

                            // REFERENSI KELAS YANG DIIKUTI SISWA
                            final kelasDiikutiRef =
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('kelas_diikuti')
                                    .doc(kelasDoc.id);

                            // SIMPAN ANGGOTA KE KELAS
                            batch.set(
                              anggotaRef,
                              {
                                'uidSiswa': user.uid,
                                'namaSiswa': namaSiswa,
                                'namaKelas': namaBaru,
                                'kodeKelas': kodeBaru,
                                'joinedAt':
                                    FieldValue.serverTimestamp(),
                              },
                            );

                            // SIMPAN KELAS KE PROFIL SISWA
                            batch.set(
                              kelasDiikutiRef,
                              {
                                'idKelas': kelasDoc.id,
                                'namaKelas': namaBaru,
                                'kodeKelas': kodeBaru,
                                'joinedAt':
                                    FieldValue.serverTimestamp(),
                              },
                            );

                            // SIMPAN KEDUA DOKUMEN
                            await batch.commit();

                            if (!mounted) return;

                            // PERBARUI DASHBOARD
                            setState(() {
                              namaKelas = namaBaru;
                              kodeKelas = kodeBaru;
                              idKelas = kelasDoc.id;
                              namaSiswaAktif = namaSiswa;
                              sedangGabung = false;
                            });

                            Navigator.pop(dialogContext);

                            _tampilkanPesan(
                              'Berhasil bergabung ke kelas $namaBaru.',
                            );

                            Future.delayed(
                              const Duration(milliseconds: 250),
                              () {
                                if (mounted) {
                                  _openClass();
                                }
                              },
                            );
                          } catch (e) {
                            debugPrint(
                              'Gagal gabung kelas: $e',
                            );

                            if (mounted) {
                              setState(() {
                                sedangGabung = false;
                              });
                            }

                            setDialogState(() {});

                            final pesan = e
                                .toString()
                                .replaceFirst(
                                  'Exception: ',
                                  '',
                                );

                            _tampilkanPesan(
                              'Gagal bergabung: $pesan',
                            );
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
    ).then((_) {
      codeController.dispose();
    });
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
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
  // LEARNING JOURNEY
  // ============================================================

  Widget _buildLearningJourney() {
    final bool sudahBergabung = kodeKelas != null;

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
            onTap: _openClass,
          ),
          _journeyLine(),
          _journeyItem(
            icon: Icons.explore_rounded,
            title: 'Eksplorasi',
            subtitle: sudahBergabung
                ? 'Jelajahi materi kelas'
                : 'Belum dimulai',
            active: sudahBergabung,
            onTap: _openClass,
          ),
          _journeyLine(),
          _journeyItem(
            icon: Icons.flag_rounded,
            title: 'Tantangan',
            subtitle: sudahBergabung
                ? '${tantanganKelas.length} tantangan tersedia'
                : 'Belum dimulai',
            active: tantanganKelas.isNotEmpty,
            onTap: _openClass,
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: active
                    ? royalBlue
                    : const Color(0xFFEAF1FC),
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
      margin: const EdgeInsets.only(
        left: 21,
        top: 4,
        bottom: 4,
      ),
      width: 2,
      height: 25,
      color: paleBlue,
    );
  }

  // ============================================================
  // LEARNING CARD
  // ============================================================

  Widget _buildLearningCard() {
    if (kodeKelas == null) {
      return _buildEmptyLearningCard();
    }

    if (materiKelas.isEmpty) {
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
              _iconBox(
                Icons.menu_book_outlined,
                paleBlue,
                royalBlue,
                58,
              ),
              const SizedBox(height: 12),
              Text(
                'Belum ada materi',
                style: TextStyle(
                  color: textBlue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Guru belum menambahkan materi untuk kelas ini.',
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
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [royalBlue, skyBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Materi Terbaru',
                    style: TextStyle(
                      color: mutedBlue,
                      fontSize: 11,
                    ),
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

  Widget _buildEmptyLearningCard() {
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
            _iconBox(
              Icons.menu_book_outlined,
              paleBlue,
              royalBlue,
              58,
            ),
            const SizedBox(height: 12),
            Text(
              'Belum ada materi',
              style: TextStyle(
                color: textBlue,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Bergabung dengan kelas terlebih dahulu untuk melihat materi.',
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
  // CHALLENGE CARD
  // ============================================================

  Widget _buildChallengeCard() {
    if (kodeKelas == null || tantanganKelas.isEmpty) {
      return InkWell(
        onTap: _openClass,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F9FF),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: paleBlue),
          ),
          child: Row(
            children: [
              _iconBox(
                Icons.flag_outlined,
                Colors.white,
                royalBlue,
                52,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Belum ada tantangan',
                      style: TextStyle(
                        color: textBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kodeKelas == null
                          ? 'Tantangan akan tersedia setelah kamu bergabung dengan kelas.'
                          : 'Guru belum menambahkan tantangan untuk kelas ini.',
                      style: TextStyle(
                        color: mutedBlue,
                        fontSize: 11.5,
                        height: 1.4,
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
                    style: TextStyle(
                      color: mutedBlue,
                      fontSize: 11,
                    ),
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
  }  // ============================================================
  // PROGRESS CARD
  // ============================================================

  Widget _buildProgressCard() {
    final int jumlahMateri = materiKelas.length;
    final int jumlahTantangan = tantanganKelas.length;
    final int jumlahHasil = hasilKelas.length;

    final int totalAktivitas =
        jumlahMateri + jumlahTantangan;

    final double progress = totalAktivitas == 0
        ? 0
        : (jumlahHasil / totalAktivitas).clamp(0.0, 1.0);

    final int persentase = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2166D5),
            Color(0xFF398CEB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
                : 'Terus tingkatkan hasil belajarmu!',
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
                '$jumlahHasil aktivitas',
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
              value: progress,
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
                '$jumlahMateri',
                'Materi',
              ),
              const SizedBox(width: 20),
              _progressInfo(
                Icons.flag_rounded,
                '$jumlahTantangan',
                'Tantangan',
              ),
              const SizedBox(width: 20),
              _progressInfo(
                Icons.assignment_turned_in_rounded,
                '$jumlahHasil',
                'Hasil',
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
          Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
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
  // ACHIEVEMENT CARD
  // ============================================================

  Widget _buildAchievementCard() {
    final int jumlahHasil = hasilKelas.length;

    final bool punyaPencapaian = jumlahHasil > 0;

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
              color: punyaPencapaian
                  ? Colors.orange
                  : mutedBlue,
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
                      ? 'Kamu sudah memiliki $jumlahHasil hasil aktivitas belajar.'
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
  // NOTIFICATION DIALOG
  // ============================================================

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
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
            kodeKelas == null
                ? 'Kamu belum bergabung dengan kelas. Masukkan kode kelas dari guru untuk mulai belajar.'
                : 'Kamu sudah bergabung dengan kelas $namaKelas. Silakan cek materi dan tantangan yang tersedia.',
            style: TextStyle(
              color: mutedBlue,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
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
                fontWeight: active
                    ? FontWeight.bold
                    : FontWeight.normal,
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
        builder: (context) => const ProfilSiswaPage(),
      ),
    );
  }
}