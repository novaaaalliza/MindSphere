
import 'package:flutter/material.dart';
import 'dashboard_page.dart';

const Color registerRoyalBlue = Color(0xFF2166D5);
const Color registerDeepBlue = Color(0xFF123B70);
const Color registerMutedBlue = Color(0xFF7288A8);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void register() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data harus diisi.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi password tidak sesuai.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Sementara langsung masuk Dashboard.
    // Firebase bisa ditambahkan nanti.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final cardPadding = isMobile ? 24.0 : 38.0;

    return Scaffold(
      body: Stack(
        children: [
          // LATAR GRADASI BIRU PREMIUM
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0B1F4D),
                    Color(0xFF174A9C),
                    Color(0xFF398DFF),
                    Color(0xFFEAF4FF),
                  ],
                  stops: [0.0, 0.32, 0.68, 1.0],
                ),
              ),
            ),
          ),

          // CAHAYA LATAR
          Positioned(
            top: -70,
            right: -55,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          Positioned(
            bottom: -85,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8EDFFF)
                    .withOpacity(0.16),
              ),
            ),
          ),

          // KONTEN REGISTER
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 18 : 30,
                  vertical: 24,
                ),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 470,
                  ),
                  padding: EdgeInsets.all(cardPadding),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFF5F9FF),
                        Color(0xFFE5F0FF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.95),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF071B49)
                            .withOpacity(0.25),
                        blurRadius: 42,
                        spreadRadius: 2,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // LOGO REGISTER
                      Container(
                        width: 92,
                        height: 92,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFB6F0FF),
                              Color(0xFF398DFF),
                              Color(0xFF123B85),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: registerRoyalBlue
                                  .withOpacity(0.30),
                              blurRadius: 25,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF174A9C),
                                Color(0xFF1683F7),
                                Color(0xFF36C4F5),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.8),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_add_alt_1_rounded,
                            color: Colors.white,
                            size: 43,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // NAMA APLIKASI
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 31,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                          children: [
                            TextSpan(
                              text: 'Mind',
                              style: TextStyle(
                                color: registerDeepBlue,
                              ),
                            ),
                            TextSpan(
                              text: 'Sphere',
                              style: TextStyle(
                                color: Color(0xFF1683F7),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 7),

                      const Text(
                        'Learn smarter. Grow better.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: registerMutedBlue,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Buat Akun',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: registerDeepBlue,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        width: 75,
                        height: 5,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF2166D5),
                              Color(0xFF56D5FF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Daftar akun baru dan mulai perjalanan '
                        'belajarmu bersama MindSphere.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: registerMutedBlue,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // NAMA LENGKAP
                      buildField(
                        controller: nameController,
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama lengkap',
                        icon: Icons.person_outline_rounded,
                      ),

                      const SizedBox(height: 19),

                      // EMAIL
                      buildField(
                        controller: emailController,
                        label: 'Email',
                        hint: 'Masukkan email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 19),

                      // PASSWORD
                      buildField(
                        controller: passwordController,
                        label: 'Password',
                        hint: 'Masukkan password',
                        icon: Icons.lock_outline_rounded,
                        obscureText: !passwordVisible,
                        suffixIcon: IconButton(
                          tooltip: passwordVisible
                              ? 'Sembunyikan password'
                              : 'Lihat password',
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),

                      const SizedBox(height: 19),

                      // KONFIRMASI PASSWORD
                      buildField(
                        controller: confirmPasswordController,
                        label: 'Konfirmasi Password',
                        hint: 'Masukkan ulang password',
                        icon: Icons.lock_reset_rounded,
                        obscureText: !confirmPasswordVisible,
                        suffixIcon: IconButton(
                          tooltip: confirmPasswordVisible
                              ? 'Sembunyikan password'
                              : 'Lihat password',
                          onPressed: () {
                            setState(() {
                              confirmPasswordVisible =
                                  !confirmPasswordVisible;
                            });
                          },
                          icon: Icon(
                            confirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // TOMBOL DAFTAR
                      SizedBox(
                        width: double.infinity,
                        height: 59,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF123B85),
                                Color(0xFF2166D5),
                                Color(0xFF49B5F5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: registerRoyalBlue
                                    .withOpacity(0.28),
                                blurRadius: 18,
                                offset: const Offset(0, 7),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Daftar Sekarang',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // KEMBALI KE LOGIN
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Sudah punya akun? ',
                            style: TextStyle(
                              color: registerMutedBlue,
                              fontSize: 13,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                            ),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                color: Color(0xFF1477E8),
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // FOOTER
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: Color(0xFF399BEE),
                            size: 16,
                          ),
                          SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              'Mulai belajar, raih potensimu.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: registerMutedBlue,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: registerDeepBlue,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 9),

        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: registerMutedBlue,
              fontSize: 13,
            ),
            prefixIcon: Icon(
              icon,
              color: registerRoyalBlue,
              size: 22,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF1F6FF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 19,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: Color(0xFFD0E3FC),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: Color(0xFFD0E3FC),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: registerRoyalBlue,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}