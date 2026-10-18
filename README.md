# MindSphere

## Tentang MindSphere

MindSphere merupakan aplikasi mobile media pembelajaran yang dikembangkan sebagai media pembelajaran interaktif bagi siswa SMK.

Aplikasi ini menggunakan konsep pembelajaran berbasis eksplorasi dan tantangan. Siswa tidak hanya membaca materi, tetapi juga dapat mengeksplorasi materi pembelajaran dan mengerjakan tantangan untuk menguji pemahaman.

MindSphere memiliki dua jenis pengguna utama, yaitu Guru dan Siswa. Guru berperan dalam mengelola kelas, materi, dan tantangan pembelajaran. Sementara itu, Siswa menggunakan aplikasi untuk mengikuti pembelajaran, mempelajari materi, mengerjakan tantangan, melihat hasil, dan memantau progress pembelajaran.

MindSphere dikembangkan menggunakan Flutter dan Dart dengan Visual Studio Code sebagai lingkungan pengembangan. Pengelolaan source code dilakukan menggunakan Git dan GitHub.

---

## Tujuan Aplikasi

MindSphere dikembangkan dengan tujuan:

- Menyediakan media pembelajaran berbasis mobile bagi siswa SMK.
- Membantu siswa mempelajari materi secara lebih mandiri.
- Menyediakan materi pembelajaran yang dapat diakses melalui aplikasi.
- Menyediakan aktivitas tantangan untuk menguji pemahaman siswa.
- Memberikan hasil dan nilai setelah siswa mengerjakan tantangan.
- Membantu siswa melihat perkembangan pembelajaran.
- Membantu Guru dalam mengelola kelas, materi, dan tantangan pembelajaran.

---

## Sasaran Pengguna

MindSphere memiliki dua jenis pengguna utama.

### Guru

Guru berperan sebagai pengelola pembelajaran dalam aplikasi.

Guru dapat:

- Login ke aplikasi.
- Melihat dashboard Guru.
- Membuat dan mengelola kelas.
- Melihat daftar siswa dalam kelas.
- Menambahkan materi pembelajaran.
- Mengedit materi pembelajaran.
- Menghapus materi pembelajaran.
- Membuat tantangan.
- Mengelola tantangan.
- Melihat hasil siswa.
- Melihat aktivitas pembelajaran.
- Mengelola profil.

### Siswa

Siswa merupakan pengguna utama dalam proses pembelajaran.

Siswa dapat:

- Melakukan register.
- Login ke aplikasi.
- Melihat dashboard Siswa.
- Bergabung ke kelas menggunakan kode kelas.
- Melihat materi pembelajaran.
- Membaca materi.
- Menyelesaikan materi.
- Melihat tantangan.
- Mengerjakan tantangan.
- Mendapatkan hasil dan nilai.
- Melihat progress pembelajaran.
- Mengelola profil.

---

## Fitur Utama

### 1. Login dan Register

Fitur Login digunakan untuk masuk ke dalam aplikasi, sedangkan Register digunakan untuk membuat akun pengguna.

Aplikasi menyediakan pilihan penggunaan berdasarkan peran pengguna, yaitu Guru dan Siswa.

### 2. Kelas

Guru dapat membuat kelas dan memberikan kode kelas kepada siswa.

Siswa dapat menggunakan kode kelas untuk bergabung ke kelas yang tersedia.

Informasi pembelajaran seperti materi dan tantangan disesuaikan dengan kelas yang diikuti.

### 3. Materi Pembelajaran

Guru dapat menambahkan materi pembelajaran ke kelas.

Siswa dapat melihat dan membaca materi yang diberikan oleh Guru sesuai dengan kelas yang diikuti.

Materi pembelajaran dapat dilengkapi dengan sumber eksternal seperti link YouTube sebagai sumber pendukung pembelajaran.

### 4. Tantangan

Guru dapat membuat tantangan yang digunakan untuk menguji pemahaman siswa setelah mempelajari materi.

Jenis soal yang tersedia dalam tantangan meliputi:

- Pilihan Ganda
- Benar / Salah
- Pilihan Ganda Kompleks
- Isian Singkat
- Menjodohkan

Setelah siswa menyelesaikan tantangan, aplikasi menghitung hasil dan nilai berdasarkan jawaban yang diberikan.

### 5. Hasil

Siswa dapat melihat hasil setelah menyelesaikan tantangan.

Guru juga dapat melihat hasil siswa berdasarkan kelas.

### 6. Progress

Progress digunakan untuk melihat perkembangan pembelajaran siswa berdasarkan aktivitas materi dan tantangan yang telah diselesaikan.

### 7. Profil

Fitur Profil digunakan untuk melihat dan mengelola informasi pengguna.

### 8. Aktivitas Terbaru

Aplikasi mencatat aktivitas pembelajaran tertentu, seperti:

- Siswa bergabung ke kelas.
- Siswa menyelesaikan materi.
- Siswa menyelesaikan tantangan.

Aktivitas tersebut dapat ditampilkan pada bagian aktivitas terbaru.

---

## Alur Penggunaan Aplikasi

### Alur Guru

```text
Login
  ↓
Dashboard Guru
  ↓
Kelola Kelas
  ↓
Pilih Kelas
  ↓
Kelola Materi / Kelola Tantangan
  ↓
Siswa Mengikuti Pembelajaran
  ↓
Melihat Hasil Siswa