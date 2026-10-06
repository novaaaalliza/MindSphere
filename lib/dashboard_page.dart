import 'package:flutter/material.dart';
import 'materi_page.dart';
import 'kuis_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const Color navy = Color(0xFF102653);
  static const Color blue = Color(0xFF2864E8);
  static const Color bg = Color(0xFFF5F7FC);
  static const Color muted = Color(0xFF7786A0);

  void openPage(BuildContext context, String page) {
  if (page == 'Materi') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MateriPage(),
      ),
    );
  if (page == 'Kuis') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const KuisPage(),
    ),
  );
    return;
  }
}
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth >= 900;

            if (desktop) {
              return Row(
                children: [
                  _sidebar(context),
                  Expanded(
                    child: _dashboardContent(
                      context,
                      constraints.maxWidth - 220,
                      true,
                    ),
                  ),
                ],
              );
            }

            return _dashboardContent(
              context,
              constraints.maxWidth,
              false,
            );
          },
        ),
      ),
    );
  }

  // SIDEBAR DESKTOP
  Widget _sidebar(BuildContext context) {
    return Container(
      width: 220,
      color: navy,
      padding: const EdgeInsets.fromLTRB(18, 28, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.blur_on_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MindSphere',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Learn Your Way',
                      style: TextStyle(
                        color: Color(0xFFB8C8E5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          _sideItem(context, Icons.home_rounded, 'Beranda', true),
          _sideItem(context, Icons.menu_book_rounded, 'Materi', false),
          _sideItem(
            context,
            Icons.fact_check_outlined,
            'Kuis',
            false,
          ),
          _sideItem(context, Icons.bolt_rounded, 'Tantangan', false),
          _sideItem(
            context,
            Icons.bar_chart_rounded,
            'Progress',
            false,
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF1A376B),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF83B7FF),
                  size: 23,
                ),
                SizedBox(height: 13),
                Text(
                  'Langkah kecil,\nhasil berarti.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Terus berkembang setiap hari.',
                  style: TextStyle(
                    color: Color(0xFFB8C8E5),
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'MINDSPHERE • V1.0',
              style: TextStyle(
                color: Color(0xFF8296BA),
                fontSize: 9,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideItem(
    BuildContext context,
    IconData icon,
    String title,
    bool selected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: selected
            ? const Color(0xFF244DA0)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: () {
            if (!selected) openPage(context, title);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected
                      ? Colors.white
                      : const Color(0xFFAEC2E5),
                  size: 21,
                ),
                const SizedBox(width: 13),
                Text(
                  title,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(0xFFAEC2E5),
                    fontSize: 13,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // MAIN DASHBOARD
  Widget _dashboardContent(
    BuildContext context,
    double width,
    bool desktop,
  ) {
    final horizontal = width < 400 ? 16.0 : 27.0;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontal,
        23,
        horizontal,
        30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(context, desktop),
              const SizedBox(height: 30),
              _welcome(),
              const SizedBox(height: 21),
              _hero(context, width),
              const SizedBox(height: 28),
              _sectionHeading('Ruang belajar', 'Pilih aktivitas'),
              const SizedBox(height: 14),
              _featureGrid(context, width),
              const SizedBox(height: 24),
              _lowerPanels(context, width),
              const SizedBox(height: 28),
              _popularLessons(context, width),
              const SizedBox(height: 25),
              _footer(),
            ],
          ),
        ),
      ),
    );
  }

  // TOP BAR
  Widget _topBar(BuildContext context, bool desktop) {
    return Row(
      children: [
        if (!desktop) ...[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: blue,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.blur_on_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'MindSphere',
            style: TextStyle(
              color: navy,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
        ] else ...[
          Expanded(
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: navy,
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Cari materi, kuis, atau topik...',
                      style: TextStyle(
                        color: muted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
        _iconButton(
          context,
          Icons.notifications_none_rounded,
          'Notifikasi',
        ),
        const SizedBox(width: 11),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFDDE8FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: blue,
            size: 25,
          ),
        ),
        if (desktop) ...[
          const SizedBox(width: 9),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo,',
                style: TextStyle(
                  color: muted,
                  fontSize: 10,
                ),
              ),
              Text(
                'Nova',
                style: TextStyle(
                  color: navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _iconButton(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () => openPage(context, title),
        child: SizedBox(
          width: 43,
          height: 43,
          child: Icon(icon, color: navy, size: 23),
        ),
      ),
    );
  }

  // WELCOME
  Widget _welcome() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, Nova!',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: navy,
            letterSpacing: -0.8,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Jelajahi ilmu dan kembangkan kemampuanmu.',
          style: TextStyle(
            fontSize: 12,
            color: muted,
          ),
        ),
      ],
    );
  }

  // HERO BANNER
  Widget _hero(BuildContext context, double width) {
    final compact = width < 520;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF193C91),
            Color(0xFF2864E8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -70,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.09),
                  width: 35,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(compact ? 18 : 30),
            child: compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SELAMAT DATANG DI MINDSPHERE',
                        style: TextStyle(
                          color: Color(0xFFC8DCFF),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Jelajahi ilmu,\nraih masa depan!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          height: 1.23,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.7,
                        ),
                      ),
                      const SizedBox(height: 11),
                      const Text(
                        'Belajar, berlatih, dan berkembang '
                        'dengan cara yang menyenangkan.',
                        style: TextStyle(
                          color: Color(0xFFE0EAFF),
                          fontSize: 12,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 17),
                      ElevatedButton(
                        onPressed: () => openPage(context, 'Materi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: navy,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Mulai belajar',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.auto_stories_rounded,
                          color: Color(0xFFBBD5FF),
                          size: 43,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SELAMAT DATANG DI MINDSPHERE',
                              style: TextStyle(
                                color: Color(0xFFC8DCFF),
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Jelajahi ilmu,\nraih masa depan!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                height: 1.23,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.7,
                              ),
                            ),
                            const SizedBox(height: 11),
                            const Text(
                              'Belajar, berlatih, dan berkembang '
                              'dengan cara yang menyenangkan.',
                              style: TextStyle(
                                color: Color(0xFFE0EAFF),
                                fontSize: 12,
                                height: 1.7,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: () =>
                                  openPage(context, 'Materi'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: navy,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Mulai belajar',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 4,
                        child: SizedBox(
                          height: 190,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 155,
                                height: 155,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.09),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Transform.rotate(
                                angle: -0.10,
                                child: Container(
                                  width: 120,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDF3FF),
                                    borderRadius: BorderRadius.circular(23),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.12),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.auto_stories_rounded,
                                        color: blue,
                                        size: 52,
                                      ),
                                      SizedBox(height: 13),
                                      Text(
                                        'KEEP LEARNING',
                                        style: TextStyle(
                                          color: navy,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 1,
                                top: 18,
                                child: _floatingIcon(
                                  Icons.lightbulb_rounded,
                                  const Color(0xFFFFC857),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 17,
                                child: _floatingIcon(
                                  Icons.check_circle_rounded,
                                  const Color(0xFF42D6B1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _floatingIcon(IconData icon, Color color) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(icon, color: navy, size: 24),
    );
  }

  Widget _sectionHeading(String title, String subtitle) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: navy,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: muted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // FEATURE GRID: RESPONSIVE
  Widget _featureGrid(BuildContext context, double width) {
    final count = width < 400
        ? 1
        : width < 700
            ? 2
            : width < 1100
                ? 3
                : 4;

    final items = [
      _Feature(
        '01',
        'Materi',
        'Pelajari hal baru',
        Icons.menu_book_rounded,
        const Color(0xFF2864E8),
        const Color(0xFFE7EFFF),
      ),
      _Feature(
        '02',
        'Kuis',
        'Uji pemahamanmu',
        Icons.fact_check_rounded,
        const Color(0xFF15977E),
        const Color(0xFFE1F6EF),
      ),
      _Feature(
        '03',
        'Tantangan',
        'Coba hal baru',
        Icons.bolt_rounded,
        const Color(0xFFDC8A28),
        const Color(0xFFFFF0DC),
      ),
      _Feature(
        '04',
        'Progress',
        'Pantau belajarmu',
        Icons.insights_rounded,
        const Color(0xFF8555D9),
        const Color(0xFFF0E8FF),
      ),
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 167,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          child: InkWell(
            borderRadius: BorderRadius.circular(19),
            onTap: () => openPage(context, item.title),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: const Color(0xFFE6EBF4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          color: item.tint,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.color,
                          size: 23,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item.number,
                        style: const TextStyle(
                          color: Color(0xFFA5B0C2),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 4,
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: item.color,
                        size: 17,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // RECOMMENDATION AND PROGRESS
  Widget _lowerPanels(BuildContext context, double width) {
    final compact = width < 600;

    final recommendation = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE9F0FF),
            Color(0xFFF4F6FF),
          ],
        ),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFDDE6FA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'REKOMENDASI BELAJAR',
            style: TextStyle(
              color: blue,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 11),
          const Text(
            'Mulai perjalanan\nbelajarmu!',
            style: TextStyle(
              color: navy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Pilih materi dan kembangkan pengetahuanmu.',
            style: TextStyle(
              color: muted,
              fontSize: 11,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 15),
          OutlinedButton(
            onPressed: () => openPage(context, 'Materi'),
            style: OutlinedButton.styleFrom(
              foregroundColor: navy,
              side: const BorderSide(color: Color(0xFFB9CCF5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: const Text(
              'Lihat materi  →',
              style: TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );

    final progress = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFE6EBF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress belajar',
            style: TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pantau perkembangan belajarmu di sini.',
            style: TextStyle(
              color: muted,
              fontSize: 11,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 19),
          Row(
            children: [
              SizedBox(
                width: 77,
                height: 77,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: 0.60,
                      strokeWidth: 8,
                      backgroundColor: const Color(0xFFE8EEFA),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(blue),
                      strokeCap: StrokeCap.round,
                    ),
                    const Center(
                      child: Text(
                        '60%',
                        style: TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Text(
                  'Contoh tampilan progress.\n'
                  'Hubungkan dengan data belajar '
                  'untuk menampilkan hasil sebenarnya.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 11,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (compact) {
      return Column(
        children: [
          recommendation,
          const SizedBox(height: 14),
          progress,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: recommendation),
        const SizedBox(width: 15),
        Expanded(flex: 4, child: progress),
      ],
    );
  }

  // POPULAR LESSONS: RESPONSIVE
  Widget _popularLessons(BuildContext context, double width) {
    final lessons = [
      _Lesson(
        'Teknologi',
        'Pengenalan Komputer',
        Icons.laptop_mac_rounded,
        const Color(0xFFE4EDFF),
        const Color(0xFF2864E8),
        '12 menit',
      ),
      _Lesson(
        'Jaringan',
        'Dasar Jaringan',
        Icons.hub_rounded,
        const Color(0xFFE0F5EF),
        const Color(0xFF168B7A),
        '15 menit',
      ),
      _Lesson(
        'Pemrograman',
        'Mengenal HTML & CSS',
        Icons.code_rounded,
        const Color(0xFFFFEBDD),
        const Color(0xFFCE792A),
        '20 menit',
      ),
      _Lesson(
        'Database',
        'Dasar Database',
        Icons.storage_rounded,
        const Color(0xFFF0E8FF),
        const Color(0xFF8055CC),
        '15 menit',
      ),
    ];

    final count = width < 400
        ? 1
        : width < 700
            ? 2
            : width < 1100
                ? 3
                : 4;

    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Materi pilihan',
                style: TextStyle(
                  color: navy,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () => openPage(context, 'Materi'),
              child: const Text(
                'Lihat semua  →',
                style: TextStyle(
                  color: blue,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: lessons.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 175,
          ),
          itemBuilder: (context, index) {
            final lesson = lessons[index];

            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              child: InkWell(
                onTap: () => openPage(context, lesson.title),
                borderRadius: BorderRadius.circular(17),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: const Color(0xFFE6EBF4),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 73,
                        width: double.infinity,
                        color: lesson.tint,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 13,
                              top: 9,
                              child: Icon(
                                lesson.icon,
                                size: 55,
                                color: lesson.color.withOpacity(0.9),
                              ),
                            ),
                            Positioned(
                              left: 13,
                              bottom: 11,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  lesson.category,
                                  style: TextStyle(
                                    color: lesson.color,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: navy,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule_rounded,
                                  size: 13,
                                  color: muted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  lesson.duration,
                                  style: const TextStyle(
                                    color: muted,
                                    fontSize: 10,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 15,
                                  color: lesson.color,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // FOOTER
  Widget _footer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFF9BC1FF),
            size: 25,
          ),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kamu bisa terus berkembang!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Mulai dari satu langkah kecil hari ini.',
                  style: TextStyle(
                    color: Color(0xFFD0DCF2),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.trending_up_rounded,
            color: Color(0xFF9BC1FF),
            size: 25,
          ),
        ],
      ),
    );
  }
}

// FEATURE MODEL
class _Feature {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color tint;

  const _Feature(
    this.number,
    this.title,
    this.description,
    this.icon,
    this.color,
    this.tint,
  );
}

// LESSON MODEL
class _Lesson {
  final String category;
  final String title;
  final IconData icon;
  final Color tint;
  final Color color;
  final String duration;

  const _Lesson(
    this.category,
    this.title,
    this.icon,
    this.tint,
    this.color,
    this.duration,
  );
}