
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'register_page.dart';

const Color royalBlue = Color(0xFF2166D5);
const Color deepBlue = Color(0xFF123B70);
const Color skyBlue = Color(0xFF56B4F8);
const Color textBlue = Color(0xFF18365D);
const Color mutedBlue = Color(0xFF7288A8);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool passwordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: deepBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage('Email dan password harus diisi.');
      return;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(email)) {
      showMessage('Masukkan alamat email yang valid.');
      return;
    }

    // Demo login: belum terhubung ke database.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
  }

  void openRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  Widget fieldLabel(String text, double fontSize) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: deepBlue,
        ),
      ),
    );
  }

  InputDecoration fieldDecoration({
    required String hint,
    required IconData icon,
    required double fontSize,
    required double iconSize,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: mutedBlue,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(
        icon,
        color: royalBlue,
        size: iconSize,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF1F6FF),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
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
          width: 1.3,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: royalBlue,
          width: 2,
        ),
      ),
    );
  }

  Widget gradientLine(double width) {
    return Container(
      width: width,
      height: 5,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2166D5),
            Color(0xFF56D5FF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF398DFF).withOpacity(0.28),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          final isMobile = screenWidth < 600;
          final isTablet =
              screenWidth >= 600 && screenWidth < 1000;
          final isShortScreen = screenHeight < 650;

          final horizontalPadding = isMobile ? 18.0 : 32.0;
          final cardWidth = isMobile
              ? screenWidth
              : isTablet
                  ? 560.0
                  : 500.0;

          final cardPadding = isMobile
              ? 23.0
              : isTablet
                  ? 42.0
                  : 44.0;

          final logoSize = isMobile
              ? 88.0
              : isTablet
                  ? 104.0
                  : 112.0;

          final brandFont = isMobile ? 32.0 : 38.0;
          final titleFont = isMobile ? 27.0 : 32.0;
          final bodyFont = isMobile ? 14.0 : 15.0;
          final labelFont = isMobile ? 14.0 : 15.0;
          final spacing = isMobile ? 23.0 : 28.0;
          final cardRadius = isMobile ? 27.0 : 34.0;
          final buttonHeight = isMobile ? 58.0 : 64.0;
          final inputIconSize = isMobile ? 21.0 : 23.0;

          return Stack(
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

              // LAPISAN CAHAYA LEMBUT
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white.withOpacity(0.16),
                        Colors.transparent,
                        const Color(0x183D8FFF),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.32, 0.68, 1.0],
                    ),
                  ),
                ),
              ),

              // KONTEN LOGIN RESPONSIF
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: isShortScreen ? 14 : 28,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: cardWidth,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: cardPadding,
                          vertical: isMobile ? 27 : 38,
                        ),
                        decoration: BoxDecoration(
                          // KARTU BIRU ES PREMIUM
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFFFFFF),
                              Color(0xFFF5F9FF),
                              Color(0xFFE5F0FF),
                            ],
                            stops: [0.0, 0.55, 1.0],
                          ),
                          borderRadius:
                              BorderRadius.circular(cardRadius),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.95),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF071B49)
                                  .withOpacity(0.25),
                              blurRadius: 45,
                              spreadRadius: 2,
                              offset: const Offset(0, 20),
                            ),
                            BoxShadow(
                              color: const Color(0xFF56B4F8)
                                  .withOpacity(0.18),
                              blurRadius: 24,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // LOGO MINDSPhERE PREMIUM
                            Container(
                              width: logoSize + 12,
                              height: logoSize + 12,
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
                                    color: const Color(0xFF238BFF)
                                        .withOpacity(0.38),
                                    blurRadius: 32,
                                    spreadRadius: 3,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF174A9C),
                                      Color(0xFF087FE8),
                                      Color(0xFF36C4F5),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.85),
                                    width: 2,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.auto_awesome_rounded,
                                      size: logoSize * 0.85,
                                      color: Colors.white
                                          .withOpacity(0.12),
                                    ),
                                    Icon(
                                      Icons.psychology_alt_rounded,
                                      size: logoSize * 0.57,
                                      color: Colors.white,
                                    ),
                                    Positioned(
                                      bottom: logoSize * 0.12,
                                      right: logoSize * 0.10,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFEBA6),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.15),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.menu_book_rounded,
                                          color:
                                              const Color(0xFF174A9C),
                                          size: isMobile ? 18 : 21,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: logoSize * 0.13,
                                      right: logoSize * 0.18,
                                      child: Icon(
                                        Icons.star_rounded,
                                        color:
                                            const Color(0xFFFFEBA6),
                                        size: isMobile ? 17 : 19,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // NAMA APLIKASI
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Mind',
                                    style: TextStyle(
                                      color: deepBlue,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'Sphere',
                                    style: TextStyle(
                                      color: Color(0xFF1683F7),
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: brandFont,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.5,
                                shadows: [
                                  Shadow(
                                    color: royalBlue.withOpacity(0.12),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              'Learn smarter. Grow better.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: mutedBlue,
                                fontSize: isMobile ? 13 : 14,
                                letterSpacing: 0.5,
                              ),
                            ),

                            SizedBox(height: spacing),

                            // JUDUL LOGIN
                            Text(
                              'Selamat Datang!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: deepBlue,
                                fontSize: titleFont,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                              ),
                            ),

                            const SizedBox(height: 15),

                            gradientLine(isMobile ? 78 : 100),

                            const SizedBox(height: 16),

                            Text(
                              'Masuk dan lanjutkan perjalanan\n'
                              'belajarmu bersama MindSphere.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: mutedBlue,
                                fontSize: bodyFont,
                                height: 1.6,
                              ),
                            ),

                            SizedBox(height: spacing),

                            // EMAIL
                            fieldLabel('Email', labelFont),

                            const SizedBox(height: 10),

                            TextField(
                              controller: emailController,
                              keyboardType:
                                  TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              decoration: fieldDecoration(
                                hint: 'Masukkan email kamu',
                                icon: Icons.mail_outline_rounded,
                                fontSize: bodyFont,
                                iconSize: inputIconSize,
                              ),
                            ),

                            const SizedBox(height: 21),

                            // PASSWORD
                            fieldLabel('Password', labelFont),

                            const SizedBox(height: 10),

                            TextField(
                              controller: passwordController,
                              obscureText: !passwordVisible,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => login(),
                              decoration: fieldDecoration(
                                hint: 'Masukkan password kamu',
                                icon: Icons.lock_outline_rounded,
                                fontSize: bodyFont,
                                iconSize: inputIconSize,
                                suffixIcon: IconButton(
                                  tooltip: passwordVisible
                                      ? 'Sembunyikan password'
                                      : 'Lihat password',
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible =
                                          !passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: mutedBlue,
                                    size: inputIconSize,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: spacing),

                            // TOMBOL LOGIN
                            SizedBox(
                              width: double.infinity,
                              height: buttonHeight,
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
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: royalBlue.withOpacity(0.30),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Masuk Sekarang',
                                        style: TextStyle(
                                          fontSize:
                                              isMobile ? 16 : 18,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: isMobile ? 22 : 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // LINK REGISTER
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment:
                                  WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'Belum punya akun? ',
                                  style: TextStyle(
                                    color: mutedBlue,
                                    fontSize: isMobile ? 13 : 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: openRegister,
                                  style: TextButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 6,
                                    ),
                                  ),
                                  child: Text(
                                    'Daftar di sini',
                                    style: TextStyle(
                                      color: const Color(0xFF1477E8),
                                      fontWeight: FontWeight.w800,
                                      fontSize: isMobile ? 13 : 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // FOOTER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Color(0xFF399BEE),
                                  size: 16,
                                ),
                                const SizedBox(width: 7),
                                Flexible(
                                  child: Text(
                                    'Mulai belajar, raih potensimu.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: mutedBlue,
                                      fontSize: isMobile ? 11 : 12,
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
              ),
            ],
          );
        },
      ),
    );
  }
}