import 'package:flutter/material.dart';
import 'register_page.dart';
import 'Dashboard/dashboard_page.dart';
import 'Dashboard/guru_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordVisible = false;
  String selectedRole = 'Siswa';

  static const Color primaryBlue = Color(0xFF2166D5);
  static const Color lightBlue = Color(0xFF56B4F8);
  static const Color paleBlue = Color(0xFFEAF6FF);
  static const Color textBlue = Color(0xFF18365D);
  static const Color mutedBlue = Color(0xFF7288A8);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  void login() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan password harus diisi.'),
        ),
      );
      return;
    }

    // Jika memilih SISWA
    if (selectedRole == 'Siswa') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardPage(),
        ),
      );
    }

    // Jika memilih GURU
    else if (selectedRole == 'Guru') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const GuruDashboardPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // =====================================================
              // BAGIAN ATAS
              // =====================================================

              SizedBox(
                height: 315,
                child: Stack(
                  children: [
                    // Background
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFE1F3FF),
                              Color(0xFFF7FBFF),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Dekorasi kiri
                    Positioned(
                      left: -48,
                      top: 45,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: lightBlue.withOpacity(0.20),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Dekorasi kanan
                    Positioned(
                      right: -42,
                      top: 65,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.09),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Titik dekorasi
                    Positioned(
                      left: 43,
                      top: 75,
                      child: _dot(
                        8,
                        primaryBlue,
                      ),
                    ),

                    Positioned(
                      right: 65,
                      top: 48,
                      child: _dot(
                        7,
                        lightBlue,
                      ),
                    ),

                    Positioned(
                      right: 42,
                      top: 155,
                      child: _dot(
                        5,
                        primaryBlue,
                      ),
                    ),

                    // =================================================
                    // ILUSTRASI MINDSPHERE
                    // =================================================

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 285,
                              height: 190,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Orbit besar
                                  Container(
                                    width: 178,
                                    height: 178,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: lightBlue.withOpacity(0.28),
                                        width: 2,
                                      ),
                                    ),
                                  ),

                                  // Orbit melintang
                                  Transform.rotate(
                                    angle: -0.35,
                                    child: Container(
                                      width: 220,
                                      height: 98,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              primaryBlue.withOpacity(0.17),
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),

                                  // Orbit kecil
                                  Transform.rotate(
                                    angle: 0.55,
                                    child: Container(
                                      width: 205,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: lightBlue.withOpacity(0.18),
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),

                                  // Sphere utama
                                  Container(
                                    width: 108,
                                    height: 108,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF56B4F8),
                                          Color(0xFF2166D5),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              primaryBlue.withOpacity(0.25),
                                          blurRadius: 25,
                                          spreadRadius: 3,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 77,
                                          height: 77,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  Colors.white.withOpacity(0.32),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.public_rounded,
                                          color: Colors.white,
                                          size: 62,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Buku
                                  Positioned(
                                    left: 20,
                                    top: 54,
                                    child: _mindSphereFloatingIcon(
                                      icon: Icons.menu_book_rounded,
                                      color: primaryBlue,
                                    ),
                                  ),

                                  // Explore
                                  Positioned(
                                    right: 18,
                                    top: 40,
                                    child: _mindSphereFloatingIcon(
                                      icon: Icons.explore_rounded,
                                      color: lightBlue,
                                    ),
                                  ),

                                  // Progress
                                  Positioned(
                                    right: 32,
                                    bottom: 15,
                                    child: _mindSphereFloatingIcon(
                                      icon: Icons.auto_graph_rounded,
                                      color: primaryBlue,
                                    ),
                                  ),

                                  // Ide
                                  Positioned(
                                    left: 32,
                                    bottom: 12,
                                    child: _mindSphereFloatingIcon(
                                      icon: Icons.lightbulb_rounded,
                                      color: const Color(0xFFFFB83D),
                                    ),
                                  ),

                                  // Bintang
                                  const Positioned(
                                    top: 12,
                                    left: 110,
                                    child: Icon(
                                      Icons.auto_awesome_rounded,
                                      color: Color(0xFF56B4F8),
                                      size: 21,
                                    ),
                                  ),

                                  const Positioned(
                                    bottom: 8,
                                    right: 92,
                                    child: Icon(
                                      Icons.star_rounded,
                                      color: Color(0xFF8ACFFF),
                                      size: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Nama aplikasi
                            const Text(
                              'MindSphere',
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.6,
                                color: textBlue,
                              ),
                            ),

                            const SizedBox(height: 2),

                            const Text(
                              'Learn smarter. Grow better.',
                              style: TextStyle(
                                fontSize: 12,
                                color: mutedBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================================
              // LOGIN CARD
              // =====================================================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    22,
                    24,
                    22,
                    25,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      const Center(
                        child: Text(
                          'Selamat Datang!',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            color: textBlue,
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Center(
                        child: Text(
                          'Masuk untuk melanjutkan pembelajaranmu',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: mutedBlue,
                          ),
                        ),
                      ),

                      const SizedBox(height: 23),

                      // =================================================
                      // PILIH ROLE
                      // =================================================

                      const Text(
                        'Masuk sebagai',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textBlue,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: roleButton(
                              title: 'Siswa',
                              icon: Icons.school_rounded,
                              role: 'Siswa',
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: roleButton(
                              title: 'Guru',
                              icon: Icons.person_rounded,
                              role: 'Guru',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 19),

                      // =================================================
                      // EMAIL
                      // =================================================

                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textBlue,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                          hint: 'Masukkan email',
                          icon: Icons.email_outlined,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // =================================================
                      // PASSWORD
                      // =================================================

                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textBlue,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: passwordController,
                        obscureText: !passwordVisible,
                        decoration: inputDecoration(
                          hint: 'Masukkan password',
                          icon: Icons.lock_outline_rounded,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: mutedBlue,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 9),

                      // Lupa password
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Lupa password?',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: primaryBlue.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =================================================
                      // BUTTON LOGIN
                      // =================================================

                      SizedBox(
                        width: double.infinity,
                        height: 53,
                        child: ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Masuk sebagai $selectedRole',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 19,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 19),

                      // =================================================
                      // REGISTER
                      // =================================================

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: 'Belum punya akun? ',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: mutedBlue,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Daftar',
                                  style: TextStyle(
                                    color: primaryBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // =====================================================
              // DEKORASI BAWAH
              // =====================================================

              const SizedBox(height: 20),

              SizedBox(
                height: 60,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -45,
                      left: -30,
                      child: Container(
                        width: 190,
                        height: 85,
                        decoration: BoxDecoration(
                          color: lightBlue.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: -45,
                      right: -35,
                      child: Container(
                        width: 200,
                        height: 85,
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ROLE BUTTON
  // ============================================================

  Widget roleButton({
    required String title,
    required IconData icon,
    required String role,
  }) {
    final bool selected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 58,
        decoration: BoxDecoration(
          color: selected ? paleBlue : const Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected
                ? primaryBlue
                : const Color(0xFFE1EAF3),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21,
              color: selected ? primaryBlue : mutedBlue,
            ),

            const SizedBox(width: 7),

            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? primaryBlue : mutedBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12.5,
        color: Color(0xFF9BAEC5),
      ),

      prefixIcon: Icon(
        icon,
        color: const Color(0xFF5C9FE8),
        size: 20,
      ),

      suffixIcon: suffix,

      filled: true,
      fillColor: const Color(0xFFF5F9FD),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: primaryBlue,
          width: 1.2,
        ),
      ),
    );
  }

  // ============================================================
  // ICON MELAYANG MINDSPHERE
  // ============================================================

  Widget _mindSphereFloatingIcon({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  // ============================================================
  // DOT DEKORASI
  // ============================================================

  Widget _dot(
    double size,
    Color color,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}