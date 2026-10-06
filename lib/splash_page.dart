import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'icon': Icons.public,
      'title': 'Belajar Lebih Dalam',
      'description':
          'Pelajari materi pembelajaran dengan cara yang lebih terstruktur, mudah, dan menarik.',
    },
    {
      'icon': Icons.explore_rounded,
      'title': 'Jelajahi Pengetahuan',
      'description':
          'Temukan berbagai materi dan aktivitas belajar yang membantu kamu memahami setiap topik.',
    },
    {
      'icon': Icons.auto_graph_rounded,
      'title': 'Pantau Perkembangan',
      'description':
          'Lihat hasil belajar dan perkembanganmu agar kamu tahu sejauh mana proses belajarmu.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // LOGO + NAMA MINDSHPERE
            // =========================
            Padding(
              padding: const EdgeInsets.only(
                top: 25,
                left: 24,
                right: 24,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF2166D5),
                          Color(0xFF56B4F8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2166D5).withOpacity(0.20),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.public,
                      color: Colors.white,
                      size: 29,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MindSphere',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF123B70),
                        ),
                      ),
                      Text(
                        'Learn smarter. Grow better.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blueGrey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // =========================
            // ONBOARDING CONTENT
            // =========================
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = onboardingData[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Ilustrasi berbentuk lingkaran
                        Container(
                          width: 245,
                          height: 245,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFDCEBFF),
                                Color(0xFFEFF8FF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2166D5)
                                    .withOpacity(0.12),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Lingkaran kecil dekorasi
                              Positioned(
                                top: 25,
                                right: 35,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF56B4F8),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 35,
                                left: 30,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2166D5),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),

                              // Icon utama
                              Container(
                                width: 125,
                                height: 125,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF2166D5)
                                          .withOpacity(0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  data['icon'],
                                  size: 68,
                                  color: const Color(0xFF2166D5),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 42),

                        Text(
                          data['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF123B70),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          data['description'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.blueGrey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // =========================
            // INDICATOR
            // =========================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) {
                  final isActive = currentPage == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF2166D5)
                          : const Color(0xFFD1E2F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // BUTTON
            // =========================
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 25),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2166D5),
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor:
                        const Color(0xFF2166D5).withOpacity(0.30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Text(
                    currentPage == onboardingData.length - 1
                        ? 'Mulai Belajar'
                        : 'Lanjut',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}