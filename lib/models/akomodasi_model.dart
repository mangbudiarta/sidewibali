class Akomodasi {
  final int id;
  final String gambar;
  final String nama;
  final String kategori;
  final int id_desawisata;

  Akomodasi({
    required this.id,
    required this.gambar,
    required this.nama,
    required this.kategori,
    required this.id_desawisata,
  });

  factory Akomodasi.fromJson(Map<String, dynamic> json) {
    return Akomodasi(
        id: json['id'],
        gambar: json['gambar'],
        nama: json['nama'],
        kategori: json['kategori'],
        id_desawisata: json['id_desawisata']);
  }
}
