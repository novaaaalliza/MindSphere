
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

  bool isLoading = true;
  bool isSaving = false;

  String namaSiswa = 'Memuat...';
  String emailSiswa = '-';
  String nomorTelepon = '-';
  String kelasSiswa = 'Belum Bergabung';
  String kodeKelas = '-';

  @override
  void initState() {
    super.initState();
    _muatProfil();
  }

  // ============================================================
  // MEMUAT PROFIL DARI FIRESTORE
  // ============================================================

  Future<void> _muatProfil() async {
    final user = _auth.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
          namaSiswa = 'Pengguna belum login';
        });
      }
      return;
    }

    try {
      final userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      final userData = userDoc.data() ?? {};

      String nama = userData['name']?.toString() ??
          user.displayName ??
          'Nama Siswa';

      String email = userData['email']?.toString() ??
          user.email ??
          '-';

      String telepon = userData['phone']?.toString() ?? '-';

      String kelas = 'Belum Bergabung';
      String kode = '-';

      final kelasDiikuti = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('kelas_diikuti')
          .limit(1)
          .get();

      if (kelasDiikuti.docs.isNotEmpty) {
        final dataKelas = kelasDiikuti.docs.first.data();

        kelas = dataKelas['namaKelas']?.toString() ??
            'Belum Bergabung';

        kode = dataKelas['kodeKelas']?.toString() ?? '-';
      }

      if (!mounted) return;

      setState(() {
        namaSiswa = nama;
        emailSiswa = email;
        nomorTelepon = telepon;
        kelasSiswa = kelas;
        kodeKelas = kode;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat profil: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ============================================================
  // MENYIMPAN PROFIL KE FIRESTORE
  // ============================================================

  Future<void> _simpanProfil({
    required String nama,
    required String telepon,
  }) async {
    final user = _auth.currentUser;

    if (user == null) return;

    if (nama.isEmpty) {
      _pesan('Nama lengkap tidak boleh kosong.');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'name': nama,
        'phone': telepon,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await user.updateDisplayName(nama);

      if (!mounted) return;

      setState(() {
        namaSiswa = nama;
        nomorTelepon = telepon.isEmpty ? '-' : telepon;
        isSaving = false;
      });

      Navigator.pop(context);

      _pesan('Profil berhasil diperbarui.');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      _pesan('Gagal menyimpan profil: $e');
    }
  }

  // ============================================================
  // EDIT PROFIL
  // ============================================================

  void _showEditProfileDialog() {
    final namaController = TextEditingController(text: namaSiswa);
    final teleponController = TextEditingController(
      text: nomorTelepon == '-' ? '' : nomorTelepon,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (contextDialog, setDialogState) {
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
                    const SizedBox(height: 10),
                    const Text(
                      'Email akun tidak diubah melalui menu ini.',
                      style: TextStyle(
                        fontSize: 12,
                        color: mutedBlue,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final nama = namaController.text.trim();
                          final telepon =
                              teleponController.text.trim();

                          if (nama.isEmpty) {
                            _pesan('Nama tidak boleh kosong.');
                            return;
                          }

                          await _simpanProfil(
                            nama: nama,
                            telepon: telepon,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
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
    ).then((_) {
      namaController.dispose();
      teleponController.dispose();
    });
  }

  // ============================================================
  // UBAH PASSWORD FIREBASE AUTHENTICATION
  // ============================================================

  void _showChangePasswordDialog() {
    final lamaController = TextEditingController();
    final baruController = TextEditingController();
    final konfirmasiController = TextEditingController();

    bool sedangMengubah = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (contextDialog, setDialogState) {
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
                          final konfirmasi =
                              konfirmasiController.text;

                          if (lama.isEmpty ||
                              baru.isEmpty ||
                              konfirmasi.isEmpty) {
                            _pesan('Semua password harus diisi.');
                            return;
                          }

                          if (baru.length < 6) {
                            _pesan(
                              'Password baru minimal 6 karakter.',
                            );
                            return;
                          }

                          if (baru != konfirmasi) {
                            _pesan(
                              'Konfirmasi password tidak sesuai.',
                            );
                            return;
                          }

                          if (lama == baru) {
                            _pesan(
                              'Password baru harus berbeda.',
                            );
                            return;
                          }

                          setDialogState(() {
                            sedangMengubah = true;
                          });

                          try {
                            final user = _auth.currentUser;

                            if (user == null ||
                                user.email == null) {
                              throw Exception(
                                'Akun tidak ditemukan.',
                              );
                            }

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

                            Navigator.pop(dialogContext);
                            _pesan('Password berhasil diubah.');
                          } on FirebaseAuthException catch (e) {
                            String pesan;

                            if (e.code == 'wrong-password' ||
                                e.code == 'invalid-credential') {
                              pesan = 'Password lama tidak sesuai.';
                            } else if (e.code ==
                                'weak-password') {
                              pesan = 'Password baru terlalu lemah.';
                            } else {
                              pesan = e.message ??
                                  'Gagal mengubah password.';
                            }

                            setDialogState(() {
                              sedangMengubah = false;
                            });

                            _pesan(pesan);
                          } catch (e) {
                            setDialogState(() {
                              sedangMengubah = false;
                            });

                            _pesan('Gagal mengubah password: $e');
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: sedangMengubah
                      ? const SizedBox(
                          height: 18,
                          width: 18,
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
    ).then((_) {
      lamaController.dispose();
      baruController.dispose();
      konfirmasiController.dispose();
    });
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
                  if (!mounted) return;
                  _pesan('Gagal keluar: $e');
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

  // ============================================================
  // PESAN
  // ============================================================

  void _pesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  // ============================================================
  // TAMPILAN
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: royalBlue,
              ),
            )
          : RefreshIndicator(
              color: royalBlue,
              onRefresh: _muatProfil,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
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
                                color: Colors.white.withValues(
                                  alpha: 0.8,
                                ),
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
                      icon: Icons.person_outline_rounded,
                      title: 'Nama Lengkap',
                      value: namaSiswa,
                    ),
                    _buildInfoItem(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: emailSiswa,
                    ),
                    _buildInfoItem(
                      icon: Icons.phone_outlined,
                      title: 'Nomor Telepon',
                      value: nomorTelepon,
                    ),
                    _buildInfoItem(
                      icon: Icons.school_outlined,
                      title: 'Kelas',
                      value: kelasSiswa,
                    ),
                    _buildInfoItem(
                      icon: Icons.key_rounded,
                      title: 'Kode Kelas',
                      value: kodeKelas,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showEditProfileDialog,
                        icon: const Icon(Icons.edit_rounded, size: 19),
                        label: const Text(
                          'Edit Profil',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: royalBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
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
                      icon: Icons.lock_outline_rounded,
                      title: 'Ubah Password',
                      subtitle:
                          'Perbarui password akun secara berkala',
                      onTap: _showChangePasswordDialog,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showLogoutDialog,
                        icon: const Icon(
                          Icons.logout_rounded,
                          size: 19,
                        ),
                        label: const Text(
                          'Keluar dari Akun',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(
                            color: Colors.redAccent,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
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

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE1E9F5),
        ),
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
            child: Icon(
              icon,
              color: royalBlue,
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

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE1E9F5),
        ),
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
                  child: Icon(
                    icon,
                    color: royalBlue,
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
}
