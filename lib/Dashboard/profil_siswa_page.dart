
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilSiswaPage extends StatefulWidget {
  const ProfilSiswaPage({super.key});

  @override
  State<ProfilSiswaPage> createState() => _ProfilSiswaPageState();
}

class _ProfilSiswaPageState extends State<ProfilSiswaPage> {
  static const Color royalBlue = Color(0xFF2166D5);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String namaSiswa = 'Memuat...';
  String emailSiswa = '-';
  String nomorTelepon = '-';
  String kelasSiswa = 'Belum Bergabung';
  String kodeKelas = '-';

  bool sedangMemuat = true;

  @override
  void initState() {
    super.initState();
    _muatProfil();
  }

  // ============================================================
  // MEMUAT DATA PROFIL DARI FIREBASE
  // ============================================================

  Future<void> _muatProfil() async {
    final user = _auth.currentUser;

    if (user == null) {
      if (!mounted) return;
      setState(() {
        sedangMemuat = false;
        namaSiswa = 'Pengguna';
      });
      return;
    }

    try {
      final userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      final data = userDoc.data() ?? {};

      String nama = (data['nama'] ??
              data['namaLengkap'] ??
              data['name'] ??
              user.displayName ??
              'Siswa')
          .toString();

      String telepon = (data['nomorTelepon'] ??
              data['noTelepon'] ??
              data['telepon'] ??
              '-')
          .toString();

      String kelas = 'Belum Bergabung';
      String kode = '-';

      final kelasDiikuti = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('kelas_diikuti')
          .limit(1)
          .get();

      if (kelasDiikuti.docs.isNotEmpty) {
        final kelasData = kelasDiikuti.docs.first.data();

        kelas = (kelasData['namaKelas'] ?? 'Kelas Siswa').toString();
        kode = (kelasData['kodeKelas'] ?? '-').toString();
      }

      if (!mounted) return;

      setState(() {
        namaSiswa = nama;
        emailSiswa = user.email ?? '-';
        nomorTelepon = telepon;
        kelasSiswa = kelas;
        kodeKelas = kode;
        sedangMemuat = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        sedangMemuat = false;
      });

      _tampilkanPesan('Gagal memuat profil: $e');
    }
  }

  // ============================================================
  // PESAN
  // ============================================================

  void _tampilkanPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: textBlue,
          ),
        ),
        title: const Text(
          'Profil Siswa',
          style: TextStyle(
            color: textBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: sedangMemuat
          ? const Center(
              child: CircularProgressIndicator(color: royalBlue),
            )
          : RefreshIndicator(
              color: royalBlue,
              onRefresh: _muatProfil,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // HEADER PROFIL
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [royalBlue, skyBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: royalBlue.withValues(alpha: 0.18),
                            blurRadius: 15,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 92,
                            height: 92,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: royalBlue,
                              size: 50,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            namaSiswa,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Siswa',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            emailSiswa,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Informasi Profil',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildInfoItem(
                      Icons.person_outline_rounded,
                      'Nama Lengkap',
                      namaSiswa,
                    ),
                    _buildInfoItem(
                      Icons.email_outlined,
                      'Email',
                      emailSiswa,
                    ),
                    _buildInfoItem(
                      Icons.phone_outlined,
                      'Nomor Telepon',
                      nomorTelepon,
                    ),
                    _buildInfoItem(
                      Icons.school_outlined,
                      'Kelas',
                      kelasSiswa,
                    ),
                    _buildInfoItem(
                      Icons.key_rounded,
                      'Kode Kelas',
                      kodeKelas,
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showEditProfileDialog,
                        icon: const Icon(Icons.edit_rounded, size: 19),
                        label: const Text(
                          'Edit Profil',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: royalBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Keamanan Akun',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildActionItem(
                      Icons.lock_outline_rounded,
                      'Ubah Password',
                      'Perbarui password akun',
                      _showChangePasswordDialog,
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showLogoutDialog,
                        icon: const Icon(Icons.logout_rounded, size: 19),
                        label: const Text(
                          'Keluar dari Akun',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  // ============================================================
  // INFO ITEM
  // ============================================================

  Widget _buildInfoItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE1E9F5)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: paleBlue,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: royalBlue, size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: mutedBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textBlue,
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
  // ACTION ITEM
  // ============================================================

  Widget _buildActionItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE1E9F5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: paleBlue,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: royalBlue, size: 22),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          fontSize: 12,
                          color: mutedBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: mutedBlue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EDIT PROFIL
  // ============================================================

  Future<void> _showEditProfileDialog() async {
    final namaController = TextEditingController(text: namaSiswa);
    final teleponController = TextEditingController(
      text: nomorTelepon == '-' ? '' : nomorTelepon,
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        bool sedangMenyimpan = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Edit Profil',
                style: TextStyle(
                  color: textBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: teleponController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Telepon',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Email akun tidak diubah melalui menu ini.',
                      style: TextStyle(fontSize: 12, color: mutedBlue),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: sedangMenyimpan
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: sedangMenyimpan
                      ? null
                      : () async {
                          final nama = namaController.text.trim();
                          final telepon = teleponController.text.trim();
                          final user = _auth.currentUser;

                          if (nama.isEmpty) {
                            _tampilkanPesan('Nama tidak boleh kosong.');
                            return;
                          }

                          if (user == null) {
                            _tampilkanPesan('Akun tidak ditemukan.');
                            return;
                          }

                          setDialogState(() {
                            sedangMenyimpan = true;
                          });

                          try {
                            await _firestore
                                .collection('users')
                                .doc(user.uid)
                                .set({
                              'nama': nama,
                              'nomorTelepon':
                                  telepon.isEmpty ? '-' : telepon,
                            }, SetOptions(merge: true));

                            await user.updateDisplayName(nama);

                            if (!mounted) return;

                            setState(() {
                              namaSiswa = nama;
                              nomorTelepon =
                                  telepon.isEmpty ? '-' : telepon;
                            });

                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                            }

                            _tampilkanPesan(
                              'Profil berhasil diperbarui.',
                            );
                          } catch (e) {
                            setDialogState(() {
                              sedangMenyimpan = false;
                            });
                            _tampilkanPesan(
                              'Gagal memperbarui profil: $e',
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
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
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    namaController.dispose();
    teleponController.dispose();
  }

  // ============================================================
  // UBAH PASSWORD FIREBASE AUTH
  // ============================================================

  Future<void> _showChangePasswordDialog() async {
    final lamaController = TextEditingController();
    final baruController = TextEditingController();
    final konfirmasiController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        bool sedangMengubah = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Ubah Password',
                style: TextStyle(
                  color: textBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: lamaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password Lama',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: baruController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password Baru',
                        prefixIcon: Icon(Icons.lock_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: konfirmasiController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Konfirmasi Password Baru',
                        prefixIcon: Icon(Icons.lock_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: sedangMengubah
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: sedangMengubah
                      ? null
                      : () async {
                          final lama = lamaController.text;
                          final baru = baruController.text;
                          final konfirmasi = konfirmasiController.text;

                          if (lama.isEmpty ||
                              baru.isEmpty ||
                              konfirmasi.isEmpty) {
                            _tampilkanPesan(
                              'Semua kolom password harus diisi.',
                            );
                            return;
                          }

                          if (baru.length < 6) {
                            _tampilkanPesan(
                              'Password baru minimal 6 karakter.',
                            );
                            return;
                          }

                          if (baru != konfirmasi) {
                            _tampilkanPesan(
                              'Konfirmasi password tidak sesuai.',
                            );
                            return;
                          }

                          if (lama == baru) {
                            _tampilkanPesan(
                              'Password baru harus berbeda.',
                            );
                            return;
                          }

                          final user = _auth.currentUser;

                          if (user == null || user.email == null) {
                            _tampilkanPesan(
                              'Akun tidak ditemukan.',
                            );
                            return;
                          }

                          setDialogState(() {
                            sedangMengubah = true;
                          });

                          try {
                            final credential =
                                EmailAuthProvider.credential(
                              email: user.email!,
                              password: lama,
                            );

                            await user.reauthenticateWithCredential(
                              credential,
                            );

                            await user.updatePassword(baru);

                            if (!mounted) return;

                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                            }

                            _tampilkanPesan(
                              'Password berhasil diperbarui.',
                            );
                          } on FirebaseAuthException catch (e) {
                            setDialogState(() {
                              sedangMengubah = false;
                            });

                            String pesan;

                            if (e.code == 'wrong-password' ||
                                e.code == 'invalid-credential') {
                              pesan = 'Password lama tidak sesuai.';
                            } else if (e.code ==
                                'requires-recent-login') {
                              pesan =
                                  'Silakan login ulang sebelum mengubah password.';
                            } else {
                              pesan = e.message ??
                                  'Gagal mengubah password.';
                            }

                            _tampilkanPesan(pesan);
                          } catch (e) {
                            setDialogState(() {
                              sedangMengubah = false;
                            });
                            _tampilkanPesan(
                              'Terjadi kesalahan: $e',
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: sedangMengubah
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    lamaController.dispose();
    baruController.dispose();
    konfirmasiController.dispose();
  }

  // ============================================================
  // LOGOUT FIREBASE
  // ============================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Keluar dari Akun?',
            style: TextStyle(
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari akun Siswa?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  await _auth.signOut();

                  if (!mounted) return;

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                } catch (e) {
                  _tampilkanPesan('Gagal keluar dari akun: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
