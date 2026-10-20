# AI DECLARATION – MINDSHPERE

## 1. Informasi Project

**Nama Project:** MindSphere  
**Jenis Project:** Aplikasi Mobile Media Pembelajaran  
**Framework:** Flutter  
**Bahasa Pemrograman:** Dart  
**Target Pengguna:** Siswa dan Guru SMK  

Dokumen ini dibuat sebagai bentuk transparansi penggunaan Artificial Intelligence (AI) dalam proses pengembangan aplikasi MindSphere. AI digunakan sebagai alat bantu dalam proses pemrograman, terutama untuk memahami error, mencari solusi, menjelaskan kode, dan membantu mengembangkan beberapa fungsi aplikasi.

Penggunaan AI tidak menggantikan proses perancangan dan pengambilan keputusan dalam pengembangan aplikasi. Setiap kode atau solusi yang diperoleh dari AI diperiksa, disesuaikan, dan diuji kembali agar sesuai dengan struktur dan kebutuhan aplikasi MindSphere.

---

## 2. Daftar Alat AI

Alat AI yang digunakan dalam proses pengembangan aplikasi MindSphere adalah:

### ChatGPT

ChatGPT digunakan sebagai alat bantu dalam proses pengembangan Flutter dan Dart. Penggunaannya meliputi:

- Membantu memahami pesan error pada Flutter.
- Membantu mencari penyebab error pada kode.
- Memberikan saran perbaikan kode.
- Membantu menjelaskan fungsi dan alur kode.
- Membantu menyusun atau memperbaiki fungsi tertentu.
- Membantu menyesuaikan hubungan antarfile.
- Membantu memberikan alternatif solusi ketika terjadi kendala dalam pengembangan.

ChatGPT tidak digunakan untuk menggantikan proses pengembangan secara keseluruhan. Kode yang diberikan tetap diperiksa dan disesuaikan dengan struktur project sebelum digunakan.

---

## 3. Pembagian Peran AI dan Pengembang

Dalam pengembangan MindSphere, pembagian peran antara pengembang dan AI dilakukan sebagai berikut.

### 3.1 Bagian yang Dirancang dan Ditentukan oleh Pengembang

Pengembang menentukan konsep utama aplikasi MindSphere, meliputi:

- Nama dan konsep aplikasi MindSphere.
- Target pengguna yaitu Siswa dan Guru SMK.
- Pembagian role Guru dan Siswa.
- Konsep pembelajaran berbasis materi dan tantangan.
- Alur penggunaan aplikasi.
- Fitur utama yang dibutuhkan.
- Struktur navigasi aplikasi.
- Kebutuhan kelas, materi, tantangan, hasil, progress, dan aktivitas.
- Konsep hubungan data berdasarkan kelas.
- Tampilan dan susunan fitur sesuai kebutuhan project.

Keputusan mengenai fitur dan alur aplikasi ditentukan berdasarkan kebutuhan project dan tidak diserahkan sepenuhnya kepada AI.

### 3.2 Bagian yang Dibantu AI

AI digunakan sebagai alat bantu terutama pada bagian implementasi dan pemecahan masalah, seperti:

- Perbaikan error pada kode Flutter dan Dart.
- Penyesuaian kode antarfile.
- Pembuatan atau perbaikan fungsi tertentu.
- Penjelasan logika pengolahan data.
- Perbaikan navigasi dan struktur kode.
- Penyusunan fungsi untuk pengelolaan data kelas, materi, tantangan, hasil, dan aktivitas.
- Pemeriksaan penyebab error berdasarkan pesan yang muncul ketika aplikasi dijalankan.

Kode yang diberikan AI tidak langsung digunakan tanpa pemeriksaan. Kode perlu disesuaikan kembali karena AI tidak mengetahui seluruh kondisi dan struktur project secara otomatis.

### 3.3 Pembagian Tanggung Jawab

Pengembang bertanggung jawab terhadap keputusan akhir mengenai kode dan fitur yang digunakan dalam aplikasi. AI berperan sebagai alat bantu untuk memberikan saran dan alternatif solusi.

Dengan demikian, pembagian perannya adalah:

**Pengembang →** menentukan konsep, kebutuhan fitur, alur aplikasi, struktur data, melakukan pemeriksaan, penyesuaian, dan pengujian.

**AI →** membantu memberikan solusi kode, menjelaskan error, memberikan contoh implementasi, dan membantu memahami logika pemrograman.

---

## 4. Studi Kasus Prompting

### 4.1 Studi Kasus 1 – Perbaikan Error pada Project

Salah satu prompt yang digunakan adalah:

> “Saya lagi bikin aplikasi MindSphere pakai Flutter dan Dart untuk media pembelajaran siswa SMK. Di aplikasi ini ada role Guru dan Siswa, terus ada fitur kelas, materi, tantangan, hasil, progress, aktivitas, dan profil. Aku lagi mengalami masalah di bagian kode dan butuh bantuan buat memperbaikinya. Tolong cek dulu kode yang aku kasih, jelaskan kenapa errornya bisa terjadi, lalu kasih solusi yang sesuai sama struktur project aku. Jangan ubah bagian yang nggak berhubungan, dan jelaskan juga kode yang kamu ubah supaya aku ngerti.”

### Hasil Awal dari AI

AI memberikan penjelasan mengenai kemungkinan penyebab error dan memberikan contoh perubahan kode yang diperlukan agar fungsi atau data dapat dikenali oleh file yang menggunakannya.

Namun, hasil dari AI tidak langsung dianggap sebagai solusi akhir. Kode tetap diperiksa kembali berdasarkan struktur file dan kondisi project MindSphere.

### Penyesuaian Manual

Penyesuaian dilakukan dengan memeriksa file yang mengalami error, file sumber data, import yang digunakan, serta hubungan antarfile. Setelah kode disesuaikan, aplikasi dijalankan kembali untuk melihat apakah error masih muncul.

Proses tersebut menunjukkan bahwa solusi dari AI perlu disesuaikan dengan kondisi project karena struktur project yang sebenarnya dapat berbeda dari asumsi yang digunakan AI.

---

## 5. Studi Kasus 2 – Pengelolaan Data Berdasarkan Kelas

AI juga digunakan untuk membantu menyusun logika pengelolaan data agar materi dan tantangan yang ditampilkan sesuai dengan kelas yang dipilih.

Contoh prompt:

> “Saya punya aplikasi MindSphere dengan data kelas, materi, dan tantangan. Materi dan tantangan harus menggunakan data yang sama antara dashboard Guru dan halaman kelas. Kalau dibuka dari kelas tertentu, yang muncul hanya materi dan tantangan dari kelas tersebut. Tolong buatkan logika filtering berdasarkan kode kelas dan nama kelas yang saya sudah buat tanpa membuat data baru yang terpisah.”

### Hasil Awal dari AI

AI memberikan contoh fungsi untuk mengambil data materi berdasarkan kode kelas dan nama kelas. Salah satu fungsi yang digunakan adalah:

```dart
List<Map<String, String>> ambilMateriKelas(
  String kodeKelas,
  String namaKelas,
) {
  return daftarMateriGlobal
      .where(
        (materi) =>
            materi['kodeKelas'] == kodeKelas &&
            materi['namaKelas'] == namaKelas,
      )
      .toList();
}

Fungsi tersebut digunakan untuk melakukan penyaringan data sehingga hanya materi yang memiliki kode dan nama kelas yang sesuai yang ditampilkan.

### Penyesuaian Manual

Logika tersebut kemudian disesuaikan dengan struktur data MindSphere. Data materi tidak dibuat menjadi salinan baru untuk setiap halaman, tetapi menggunakan data bersama pada `data_global.dart`.

Pengembang juga memastikan bahwa data materi dan tantangan yang dibuat oleh Guru memiliki informasi `kodeKelas` dan `namaKelas`. Dengan demikian, halaman pengelolaan Guru dan halaman pembelajaran Siswa dapat menggunakan sumber data yang sama.

Alur data yang diterapkan adalah:

```text
Guru membuat materi
        ↓
Data disimpan pada data bersama
        ↓
Data memiliki kode dan nama kelas
        ↓
Siswa membuka kelas
        ↓
Data difilter berdasarkan kelas
        ↓
Materi yang sesuai ditampilkan

## 6. Pemeriksaan dan Pengujian Hasil AI

Setiap solusi yang diperoleh dari AI diperiksa kembali sebelum digunakan. Pemeriksaan dilakukan dengan melihat kesesuaian kode dengan struktur project, menjalankan aplikasi, serta memperhatikan error yang muncul.

Apabila kode yang diberikan AI tidak sesuai dengan kondisi project, kode tersebut disesuaikan secara manual. Setelah perubahan dilakukan, aplikasi dijalankan kembali untuk memastikan fitur dapat berfungsi dan tidak menyebabkan masalah pada bagian lainnya.

Salah satu hal yang ditemukan selama proses pengembangan adalah AI tidak selalu dapat mengetahui kondisi seluruh project, terutama ketika terdapat banyak file yang saling berhubungan. Oleh karena itu, pesan error, struktur folder, import, nama variabel, dan sumber data tetap perlu diperiksa secara langsung oleh pengembang.

---

## 7. Kesimpulan Penggunaan AI

AI memberikan bantuan dalam mempercepat proses pengembangan MindSphere, terutama dalam memahami error, mencari solusi kode, dan menjelaskan logika pemrograman. Namun, AI digunakan sebagai alat bantu dan bukan sebagai pengganti proses berpikir serta tanggung jawab pengembang.

Konsep aplikasi, kebutuhan fitur, pembagian role Guru dan Siswa, alur pembelajaran, serta keputusan akhir terhadap kode ditentukan dan diperiksa oleh pengembang. Setiap hasil dari AI tetap melalui proses penyesuaian dan pengujian agar dapat digunakan sesuai dengan kebutuhan aplikasi MindSphere.

Dengan penggunaan tersebut, AI membantu proses pengembangan menjadi lebih efisien sekaligus membantu pengembang memahami dan menyelesaikan permasalahan yang muncul selama proses pembuatan aplikasi.