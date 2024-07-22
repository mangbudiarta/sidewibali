import 'package:flutter/foundation.dart';

class Berita {
  final int id;
  final String judul;
  final String isiBerita;
  final String gambar;
  final int idDesawisata;
  final DateTime createdAt;

  Berita({
    required this.id,
    required this.judul,
    required this.isiBerita,
    required this.gambar,
    required this.idDesawisata,
    required this.createdAt,
  });
  
  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      id: json['id'],
      judul: json['judul'],
      gambar: json['gambar'],
      isiBerita: json['isi_berita'],
      idDesawisata: json['id_desawisata'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
