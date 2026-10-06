
import 'package:flutter/material.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _KuisPageState extends State<KuisPage> {
  static const Color navy = Color(0xFF102653);
  static const Color blue = Color(0xFF2864E8);
  static const Color bg = Color(0xFFF5F7FC);

  final List<Map<String, dynamic>> soal = [
    {
      'kategori': 'Pengenalan Komputer',
      'pertanyaan': 'Apa fungsi utama komputer?',
      'pilihan': [
        'Mengolah data menjadi informasi',
        'Hanya untuk bermain game',
        'Hanya untuk mencetak dokumen',
        'Menggantikan semua perangkat jaringan',
      ],
      'jawaban': 0,
      'penjelasan':
          'Komputer digunakan untuk menerima, mengolah, menyimpan, dan menghasilkan informasi.'
    },
    {
      'kategori': 'Hardware',
      'pertanyaan': 'Manakah yang termasuk perangkat keras?',
      'pilihan': [
        'Microsoft Word',
        'Sistem operasi',
        'Keyboard',
        'Browser',
      ],
      'jawaban': 2,
      'penjelasan':
          'Keyboard adalah perangkat keras yang digunakan untuk memasukkan teks dan perintah.'
    },
    {
      'kategori': 'Software',
      'pertanyaan': 'Apa yang dimaksud dengan software?',
      'pilihan': [
        'Perangkat untuk mencetak',
        'Program atau instruksi pada komputer',
        'Kabel penghubung jaringan',
        'Bagian fisik monitor',
      ],
      'jawaban': 1,
      'penjelasan':
          'Software adalah program atau instruksi yang membantu komputer menjalankan tugas.'
    },
    {
      'kategori': 'Internet',
      'pertanyaan': 'Apa fungsi browser?',
      'pilihan': [
        'Membersihkan keyboard',
        'Memperbaiki monitor',
        'Menyimpan listrik',
        'Membuka dan menampilkan halaman web',
      ],
      'jawaban': 3,
      'penjelasan':
          'Browser seperti Chrome digunakan untuk membuka dan menampilkan halaman web.'
    },
    {
      'kategori': 'Jaringan Komputer',
      'pertanyaan': 'Apa fungsi utama router?',
      'pilihan': [
        'Mengetik dokumen',
        'Mencetak gambar',
        'Meneruskan data antarjaringan',
        'Menampilkan video',
      ],
      'jawaban': 2,
      'penjelasan':
          'Router meneruskan paket data antarjaringan berdasarkan informasi tujuan.'
    },
    {
      'kategori': 'Jaringan Komputer',
      'pertanyaan': 'Apa fungsi switch dalam jaringan lokal?',
      'pilihan': [
        'Menghubungkan perangkat dalam LAN',
        'Membuat dokumen',
        'Mengedit foto',
        'Menjalankan aplikasi presentasi',
      ],
      'jawaban': 0,
      'penjelasan':
          'Switch menghubungkan perangkat dalam jaringan lokal dan meneruskan data ke perangkat tujuan.'
    },
    {
      'kategori': 'Keamanan Digital',
      'pertanyaan': 'Bagaimana cara menjaga keamanan akun?',
      'pilihan': [
        'Membagikan kata sandi ke teman',
        'Menggunakan kata sandi yang kuat',
        'Menggunakan kata sandi yang sama untuk semua akun',
        'Membagikan kode verifikasi kepada orang lain',
      ],
      'jawaban': 1,
      'penjelasan':
          'Gunakan kata sandi yang kuat dan jangan membagikan kata sandi atau kode verifikasi.'
    },
    {
      'kategori': 'Database',
      'pertanyaan': 'Apa fungsi database?',
      'pilihan': [
        'Mengatur kecerahan monitor',
        'Menghubungkan keyboard',
        'Mencetak halaman',
        'Menyimpan dan mengelola data secara terstruktur',
      ],
      'jawaban': 3,
      'penjelasan':
          'Database membantu menyimpan, mencari, dan mengelola data secara terorganisasi.'
    },
    {
      'kategori': 'Pemrograman',
      'pertanyaan': 'Apa fungsi HTML?',
      'pilihan': [
        'Menyusun struktur halaman web',
        'Menghubungkan kabel LAN',
        'Mengatur daya komputer',
        'Menggantikan sistem operasi',
      ],
      'jawaban': 0,
      'penjelasan':
          'HTML digunakan untuk menyusun struktur konten pada halaman web.'
    },
    {
      'kategori': 'Pemrograman',
      'pertanyaan': 'Apa fungsi CSS?',
      'pilihan': [
        'Mengelola database',
        'Menghubungkan router',
        'Mengatur tampilan halaman web',
        'Memindai virus secara otomatis',
      ],
      'jawaban': 2,
      'penjelasan':
          'CSS digunakan untuk mengatur tampilan, warna, ukuran teks, dan tata letak halaman web.'
    },
  ];

  int nomor = 0;
  int? pilihanDipilih;
  int jumlahBenar = 0;
  bool sudahDijawab = false;
  bool selesai = false;

  void pilihJawaban(int index) {
    if (sudahDijawab) return;

    setState(() {
      pilihanDipilih = index;
      sudahDijawab = true;

      if (index == soal[nomor]['jawaban']) {
        jumlahBenar++;
      }
    });
  }

  void lanjut() {
    if (!sudahDijawab) return;

    setState(() {
      if (nomor < soal.length - 1) {
        nomor++;
        pilihanDipilih = null;
        sudahDijawab = false;
      } else {
        selesai = true;
      }
    });
  }

  void ulangiKuis() {
    setState(() {
      nomor = 0;
      pilihanDipilih = null;
      jumlahBenar = 0;
      sudahDijawab = false;
      selesai = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        elevation: 0,
        title: const Text(
          'Kuis MindSphere',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: selesai ? halamanHasil() : halamanSoal(),
      ),
    );
  }

  Widget halamanSoal() {
    final item = soal[nomor];
    final List<String> pilihan =
        List<String>.from(item['pilihan']);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF193C91), blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.quiz_rounded,
                color: Colors.white,
                size: 34,
              ),
              const SizedBox(height: 12),
              const Text(
                'Uji Pemahamanmu!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pilih jawaban yang paling tepat.',
                style: TextStyle(
                  color: Color(0xFFE0EAFF),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: (nomor + 1) / soal.length,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${nomor + 1}/${soal.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          item['kategori'],
          style: const TextStyle(
            color: blue,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          item['pertanyaan'],
          style: const TextStyle(
            color: navy,
            fontSize: 21,
            fontWeight: FontWeight.w800,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(pilihan.length, (index) {
          final bool dipilih = pilihanDipilih == index;
          final bool benar = index == item['jawaban'];

          Color warnaLatar = Colors.white;
          Color warnaBorder = const Color(0xFFE2E8F2);
          Color warnaTeks = navy;
          IconData? ikon;

          if (sudahDijawab && benar) {
            warnaLatar = const Color(0xFFE4F8ED);
            warnaBorder = const Color(0xFF24A56A);
            ikon = Icons.check_circle_rounded;
          } else if (sudahDijawab && dipilih && !benar) {
            warnaLatar = const Color(0xFFFFE9E9);
            warnaBorder = Colors.red;
            warnaTeks = Colors.red.shade800;
            ikon = Icons.cancel_rounded;
          } else if (dipilih) {
            warnaBorder = blue;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: warnaLatar,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: warnaBorder,
                width: 1.5,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () => pilihJawaban(index),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: warnaBorder.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          color: warnaTeks,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Text(
                        pilihan[index],
                        style: TextStyle(
                          color: warnaTeks,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                    if (ikon != null) ...[
                      const SizedBox(width: 8),
                      Icon(ikon, color: warnaBorder, size: 21),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
        if (sudahDijawab) ...[
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EFFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: blue,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item['penjelasan'],
                    style: const TextStyle(
                      color: navy,
                      height: 1.6,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: lanjut,
              style: FilledButton.styleFrom(
                backgroundColor: blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                nomor == soal.length - 1
                    ? 'Lihat Hasil'
                    : 'Soal Selanjutnya',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget halamanHasil() {
    final nilai = (jumlahBenar / soal.length * 100).round();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color(0xFFE6EBF4),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFE7EFFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: blue,
                  size: 49,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Kuis Selesai!',
                style: TextStyle(
                  color: navy,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Terima kasih sudah menyelesaikan kuis.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7786A0),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                '$nilai',
                style: const TextStyle(
                  color: blue,
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'NILAI AKHIR',
                style: TextStyle(
                  color: Color(0xFF7786A0),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: kotakHasil(
                      'Jawaban benar',
                      '$jumlahBenar',
                      const Color(0xFFE4F8ED),
                      const Color(0xFF168B58),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: kotakHasil(
                      'Jawaban salah',
                      '${soal.length - jumlahBenar}',
                      const Color(0xFFFFE9E9),
                      Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: ulangiKuis,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Ulangi Kuis'),
                  style: FilledButton.styleFrom(
                    backgroundColor: blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: navy,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Kembali ke Dashboard'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget kotakHasil(
    String judul,
    String angka,
    Color latar,
    Color warna,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 10),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            angka,
            style: TextStyle(
              color: warna,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            judul,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: warna,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}