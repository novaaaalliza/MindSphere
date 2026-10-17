import 'package:flutter/material.dart';

class ProfilGuruPage extends StatefulWidget {
  const ProfilGuruPage({super.key});

  @override
  State<ProfilGuruPage> createState() => _ProfilGuruPageState();
}

class _ProfilGuruPageState extends State<ProfilGuruPage> {
  static const Color royalBlue = Color(0xFF2166D5);
  static const Color skyBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFDCEBFF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  // ============================================================
  // DATA SEMENTARA
  // ============================================================
  //
  // Besok data ini bisa langsung diambil dari database.
  //
  String namaGuru = 'Nama Guru';
  String emailGuru = 'guru@mindsphere.com';
  String nomorTelepon = '-';
  String mataPelajaran = 'Pendidikan Teknologi Informasi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: textBlue,
          ),
        ),
        title: const Text(
          'Profil Guru',
          style: TextStyle(
            color: textBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ======================================================
            // HEADER PROFIL
            // ======================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    royalBlue,
                    skyBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: royalBlue.withOpacity(0.18),
                    blurRadius: 15,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Foto profil
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.8),
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
                    namaGuru,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Guru',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    emailGuru,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ======================================================
            // INFORMASI PROFIL
            // ======================================================

            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
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
              value: namaGuru,
            ),

            _buildInfoItem(
              icon: Icons.email_outlined,
              title: 'Email',
              value: emailGuru,
            ),

            _buildInfoItem(
              icon: Icons.phone_outlined,
              title: 'Nomor Telepon',
              value: nomorTelepon,
            ),

            _buildInfoItem(
              icon: Icons.school_outlined,
              title: 'Mata Pelajaran',
              value: mataPelajaran,
            ),

            const SizedBox(height: 14),

            // ======================================================
            // TOMBOL EDIT PROFIL
            // ======================================================

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showEditProfileDialog,
                icon: const Icon(
                  Icons.edit_rounded,
                  size: 19,
                ),
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

            // ======================================================
            // KEAMANAN AKUN
            // ======================================================

            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
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
              subtitle: 'Perbarui password akun secara berkala',
              onTap: _showChangePasswordDialog,
            ),

            const SizedBox(height: 24),

            // ======================================================
            // LOGOUT
            // ======================================================

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

  // ============================================================
  // EDIT PROFIL
  // ============================================================

  void _showEditProfileDialog() {
    final namaController = TextEditingController(text: namaGuru);
    final emailController = TextEditingController(text: emailGuru);
    final teleponController = TextEditingController(text: nomorTelepon);
    final mapelController = TextEditingController(text: mataPelajaran);

    showDialog(
      context: context,
      builder: (dialogContext) {
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
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
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
                const SizedBox(height: 12),
                TextField(
                  controller: mapelController,
                  decoration: const InputDecoration(
                    labelText: 'Mata Pelajaran',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  namaGuru = namaController.text.trim();
                  emailGuru = emailController.text.trim();
                  nomorTelepon = teleponController.text.trim();
                  mataPelajaran = mapelController.text.trim();
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Profil berhasil diperbarui.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // UBAH PASSWORD
  // ============================================================

  void _showChangePasswordDialog() {
    final passwordLamaController = TextEditingController();
    final passwordBaruController = TextEditingController();
    final konfirmasiController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
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
                  controller: passwordLamaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password Lama',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordBaruController,
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
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (passwordBaruController.text.isEmpty ||
                    konfirmasiController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Password baru belum lengkap.',
                      ),
                    ),
                  );
                  return;
                }

                if (passwordBaruController.text !=
                    konfirmasiController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Konfirmasi password tidak sesuai.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Password berhasil diperbarui.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // LOGOUT
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
            'Apakah kamu yakin ingin keluar dari akun Guru?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // Kembali ke halaman login.
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
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