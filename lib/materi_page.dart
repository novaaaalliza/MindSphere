
import 'package:flutter/material.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  final TextEditingController _searchController =
      TextEditingController();

  String _kataKunci = '';

  static const Color navy = Color(0xFF102653);
  static const Color blue = Color(0xFF2864E8);
  static const Color bg = Color(0xFFF5F7FC);
  static const Color muted = Color(0xFF7786A0);

  final List<_Materi> _daftarMateri = const [
    _Materi(
      'Pengenalan Komputer',
      'Teknologi',
      'Mengenal pengertian, fungsi, dan cara kerja komputer.',
      Icons.laptop_mac_rounded,
      Color(0xFFE7EFFF),
      Color(0xFF2864E8),
      'Komputer adalah perangkat elektronik yang menerima data, mengolahnya berdasarkan instruksi, menyimpan hasil, dan menghasilkan informasi. Komputer digunakan untuk belajar, bekerja, berkomunikasi, serta mengolah berbagai jenis data.\n\nKomponen utama komputer meliputi perangkat keras (hardware), perangkat lunak (software), dan pengguna (brainware). Ketiganya saling mendukung agar komputer dapat digunakan dengan baik.\n\nContoh perangkat keras adalah monitor, keyboard, mouse, CPU, dan printer. Contoh perangkat lunak adalah sistem operasi dan aplikasi pengolah kata.',
    ),
    _Materi(
      'Hardware dan Software',
      'Komputer',
      'Memahami perbedaan perangkat keras dan perangkat lunak.',
      Icons.memory_rounded,
      Color(0xFFE1F6EF),
      Color(0xFF15977E),
      'Hardware adalah bagian komputer yang memiliki bentuk fisik dan dapat disentuh, seperti monitor, keyboard, mouse, motherboard, dan printer. Setiap perangkat memiliki fungsi tertentu, misalnya keyboard untuk memasukkan teks dan monitor untuk menampilkan informasi.\n\nSoftware adalah kumpulan program atau instruksi yang mengatur kerja komputer. Contohnya sistem operasi, aplikasi perkantoran, browser, dan aplikasi desain.\n\nHardware dan software saling membutuhkan. Perangkat keras menjalankan instruksi dari perangkat lunak, sedangkan perangkat lunak membantu pengguna menyelesaikan pekerjaan.',
    ),
    _Materi(
      'Sistem Operasi',
      'Software',
      'Mengenal fungsi sistem operasi pada perangkat.',
      Icons.settings_rounded,
      Color(0xFFF0E8FF),
      Color(0xFF8555D9),
      'Sistem operasi adalah perangkat lunak utama yang mengatur sumber daya komputer dan menjadi penghubung antara pengguna, aplikasi, dan perangkat keras.\n\nFungsi sistem operasi antara lain mengelola file, menjalankan aplikasi, mengatur memori, mengelola perangkat, dan menyediakan antarmuka bagi pengguna.\n\nContoh sistem operasi pada komputer adalah Windows, Linux, dan macOS. Pada perangkat seluler terdapat Android dan iOS.',
    ),
    _Materi(
      'Dasar Internet',
      'Internet',
      'Memahami internet dan penggunaannya secara aman.',
      Icons.language_rounded,
      Color(0xFFFFF0DC),
      Color(0xFFDC8A28),
      'Internet adalah jaringan global yang menghubungkan banyak perangkat agar dapat bertukar informasi. Melalui internet, pengguna dapat mencari informasi, belajar daring, berkomunikasi, dan berbagi file.\n\nBrowser seperti Chrome atau Firefox digunakan untuk membuka halaman web. Mesin pencari membantu menemukan informasi berdasarkan kata kunci.\n\nGunakan internet secara bertanggung jawab: periksa kebenaran informasi, jaga kata sandi, hindari membagikan data pribadi sembarangan, dan jangan membuka tautan yang mencurigakan.',
    ),
    _Materi(
      'Dasar Jaringan Komputer',
      'Jaringan',
      'Mengenal jaringan dan perangkat yang menghubungkan komputer.',
      Icons.hub_rounded,
      Color(0xFFE0F5EF),
      Color(0xFF168B7A),
      'Jaringan komputer adalah kumpulan dua atau lebih perangkat yang terhubung untuk bertukar data dan berbagi sumber daya, misalnya file, printer, atau koneksi internet.\n\nPerangkat jaringan yang umum digunakan antara lain NIC, switch, router, access point, dan kabel jaringan. NIC memungkinkan perangkat terhubung ke jaringan. Switch menghubungkan perangkat dalam jaringan lokal, sedangkan router meneruskan lalu lintas data antarjaringan.\n\nJaringan dapat membantu komunikasi dan berbagi sumber daya, tetapi perlu dikelola dan diamankan agar penggunaannya tetap aman.',
    ),
    _Materi(
      'Pengenalan HTML',
      'Pemrograman',
      'Mengenal struktur dasar halaman web.',
      Icons.code_rounded,
      Color(0xFFFFEBDD),
      Color(0xFFCE792A),
      'HTML (HyperText Markup Language) adalah bahasa markup yang digunakan untuk menyusun struktur halaman web. HTML menggunakan elemen atau tag untuk menandai bagian halaman, seperti judul, paragraf, gambar, dan tautan.\n\nContoh struktur sederhana HTML meliputi <!DOCTYPE html>, <html>, <head>, <title>, dan <body>. Isi yang terlihat oleh pengunjung umumnya diletakkan di dalam elemen body.\n\nHTML berfokus pada struktur konten. Tampilan dapat dipercantik menggunakan CSS, sedangkan interaksi dapat ditambahkan menggunakan JavaScript.',
    ),
    _Materi(
      'Dasar CSS',
      'Pemrograman',
      'Mengatur warna, ukuran, dan tata letak halaman web.',
      Icons.palette_rounded,
      Color(0xFFE7EFFF),
      Color(0xFF2864E8),
      'CSS (Cascading Style Sheets) digunakan untuk mengatur tampilan halaman HTML. Dengan CSS, pengembang dapat mengubah warna teks, ukuran huruf, jarak, latar belakang, garis tepi, dan tata letak.\n\nAturan CSS biasanya terdiri dari selector dan deklarasi. Selector memilih elemen yang akan diatur, sedangkan deklarasi berisi properti dan nilai, misalnya color: blue; atau font-size: 18px;.\n\nCSS dapat ditulis langsung pada elemen, di bagian style dalam HTML, atau pada file terpisah berekstensi .css. Pemisahan HTML dan CSS membantu kode lebih rapi.',
    ),
    _Materi(
      'Pengenalan Database',
      'Database',
      'Memahami penyimpanan dan pengelolaan data.',
      Icons.storage_rounded,
      Color(0xFFF0E8FF),
      Color(0xFF8055CC),
      'Database adalah kumpulan data yang disimpan secara terorganisasi sehingga mudah dicari, dikelola, dan diperbarui. Contohnya data siswa, data buku perpustakaan, dan data produk toko.\n\nDalam database relasional, data umumnya disimpan dalam tabel yang terdiri dari baris dan kolom. Setiap tabel dapat memiliki primary key sebagai identitas unik suatu data.\n\nDBMS adalah perangkat lunak untuk mengelola database. Contohnya MySQL, PostgreSQL, dan SQLite. SQL digunakan untuk mengambil, menambah, mengubah, dan menghapus data.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasil = _daftarMateri.where((materi) {
      final q = _kataKunci.toLowerCase();

      return materi.judul.toLowerCase().contains(q) ||
          materi.kategori.toLowerCase().contains(q) ||
          materi.ringkasan.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        elevation: 0,
        title: const Text(
          'Materi Belajar',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF193C91), blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_stories_rounded,
                    color: Color(0xFFC8DCFF),
                    size: 30,
                  ),
                  SizedBox(height: 13),
                  Text(
                    'Jelajahi Materi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Pilih topik yang ingin kamu pelajari dan pahami langkah demi langkah.',
                    style: TextStyle(
                      color: Color(0xFFE0EAFF),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _kataKunci = value);
              },
              decoration: InputDecoration(
                hintText: 'Cari materi atau kategori...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: muted,
                ),
                suffixIcon: _kataKunci.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _kataKunci = '');
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(color: Color(0xFFE6EBF4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(color: Color(0xFFE6EBF4)),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Semua materi',
                    style: TextStyle(
                      color: navy,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${hasil.length} topik',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            if (hasil.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 35,
                      color: muted,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Materi tidak ditemukan',
                      style: TextStyle(
                        color: navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Coba gunakan kata kunci lain.',
                      style: TextStyle(color: muted),
                    ),
                  ],
                ),
              )
            else
              ...hasil.map((materi) => _kartuMateri(context, materi)),
          ],
        ),
      ),
    );
  }

  Widget _kartuMateri(BuildContext context, _Materi materi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EBF4)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailMateriPage(materi: materi),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: materi.tint,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  materi.icon,
                  color: materi.warna,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materi.kategori.toUpperCase(),
                      style: TextStyle(
                        color: materi.warna,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      materi.judul,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      materi.ringkasan,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: materi.warna,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailMateriPage extends StatelessWidget {
  final _Materi materi;

  const DetailMateriPage({
    super.key,
    required this.materi,
  });

  static const Color navy = Color(0xFF102653);
  static const Color muted = Color(0xFF7786A0);

  @override
  Widget build(BuildContext context) {
    final paragraf = materi.isi.split('\n\n');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        elevation: 0,
        title: const Text(
          'Detail Materi',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF193C91), Color(0xFF2864E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(
                    materi.icon,
                    color: Colors.white,
                    size: 31,
                  ),
                ),
                const SizedBox(height: 17),
                Text(
                  materi.kategori.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFC8DCFF),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  materi.judul,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  materi.ringkasan,
                  style: const TextStyle(
                    color: Color(0xFFE0EAFF),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: const Color(0xFFE6EBF4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Materi pembelajaran',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 15),
                ...paragraf.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(
                      p,
                      style: const TextStyle(
                        color: Color(0xFF40516D),
                        fontSize: 14,
                        height: 1.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F0FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFF2864E8),
                  size: 23,
                ),
                SizedBox(width: 11),
                Expanded(
                  child: Text(
                    'Tips belajar: baca setiap bagian dengan teliti, lalu coba jelaskan kembali menggunakan kata-katamu sendiri.',
                    style: TextStyle(
                      color: Color(0xFF294578),
                      fontSize: 12,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check_circle_outline_rounded),
            label: const Text('Selesai membaca'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2864E8),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Materi {
  final String judul;
  final String kategori;
  final String ringkasan;
  final IconData icon;
  final Color tint;
  final Color warna;
  final String isi;

  const _Materi(
    this.judul,
    this.kategori,
    this.ringkasan,
    this.icon,
    this.tint,
    this.warna,
    this.isi,
  );
}