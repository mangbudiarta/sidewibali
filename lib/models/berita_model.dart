import 'package:flutter/foundation.dart';

class Berita {
  final String judul;
  final String isi_berita;
  final String gambar;
  final int id_desawisata;
  final DateTime timestamp;

  Berita({
    required this.judul,
    required this.isi_berita,
    required this.gambar,
    required this.id_desawisata,
    required this.timestamp,
  });
}
