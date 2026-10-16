import 'package:flutter/material.dart';

class KelolaMateriPage extends StatefulWidget {
  const KelolaMateriPage({super.key});

  @override
  State<KelolaMateriPage> createState() => _KelolaMateriPageState();
}

class _KelolaMateriPageState extends State<KelolaMateriPage> {
  final List<Map<String, String>> daftarMateri = [];

  void tambahMateri() {
    final judulController = TextEditingController();
    final isiController = TextEditingController();
    final sumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Tambah Materi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Materi',
                    hintText: 'Contoh: Jaringan Komputer',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.menu_book_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: isiController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Isi Materi',
                    hintText: 'Tuliskan materi pembelajaran...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.article_outlined),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: sumberController,
                  decoration: const InputDecoration(
                    labelText: 'Link Sumber Tambahan',
                    hintText: 'Opsional, misalnya link YouTube',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (judulController.text.trim().isEmpty ||
                    isiController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Judul dan isi materi wajib diisi.',
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  daftarMateri.add({
                    'judul': judulController.text.trim(),
                    'isi': isiController.text.trim(),
                    'sumber': sumberController.text.trim(),
                  });
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Materi berhasil ditambahkan.'),
                  ),
                );
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void lihatMateri(Map<String, String> materi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailMateriPage(
          judul: materi['judul'] ?? '',
          isi: materi['isi'] ?? '',
          sumber: materi['sumber'] ?? '',
        ),
      ),
    );
  }

  void hapusMateri(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Materi'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus materi ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  daftarMateri.removeAt(index);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Materi berhasil dihapus.'),
                  ),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Materi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: daftarMateri.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Belum Ada Materi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tambahkan materi pembelajaran untuk siswa.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: tambahMateri,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Materi'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: daftarMateri.length,
              itemBuilder: (context, index) {
                final materi = daftarMateri[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        child: Icon(Icons.menu_book),
                      ),
                      title: Text(
                        materi['judul'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          'Tekan untuk melihat detail materi',
                        ),
                      ),
                      onTap: () => lihatMateri(materi),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'hapus') {
                            hapusMateri(index);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'hapus',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline),
                                SizedBox(width: 8),
                                Text('Hapus'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: tambahMateri,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Materi'),
      ),
    );
  }
}

class DetailMateriPage extends StatelessWidget {
  final String judul;
  final String isi;
  final String sumber;

  const DetailMateriPage({
    super.key,
    required this.judul,
    required this.isi,
    required this.sumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Materi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Isi Materi',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isi,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),
            if (sumber.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Sumber Tambahan',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SelectableText(
                sumber,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}