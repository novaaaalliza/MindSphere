
import 'package:cloud_firestore/cloud_firestore.dart';

class MateriData {
  static final CollectionReference<Map<String, dynamic>>
      _materiCollection =
      FirebaseFirestore.instance.collection('materi');

  // Mengubah dokumen Firestore menjadi data materi
  static Map<String, String> _mapMateri(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    return {
      'id': doc.id,
      'namaKelas': data['namaKelas']?.toString() ?? '',
      'kodeKelas': data['kodeKelas']?.toString() ?? '',
      'judul': data['judul']?.toString() ?? '',
      'isi': data['isi']?.toString() ?? '',
      'sumber': data['sumber']?.toString() ?? '',
      'link': data['link']?.toString() ??
          data['sumber']?.toString() ??
          '',
      'deskripsi': data['deskripsi']?.toString() ?? '',
    };
  }

  // Mengambil semua materi dari Firebase
  static Stream<List<Map<String, String>>> getAllMateri() {
    return _materiCollection.snapshots().map((snapshot) {
      return snapshot.docs.map(_mapMateri).toList();
    });
  }

  // Mengambil materi berdasarkan kode kelas
  static Stream<List<Map<String, String>>> getMateriByKelas(
    String kodeKelas,
  ) {
    return _materiCollection
        .where('kodeKelas', isEqualTo: kodeKelas)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(_mapMateri).toList();
    });
  }
}
