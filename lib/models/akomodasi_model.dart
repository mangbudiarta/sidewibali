class Akomodasi {
  final int id;
  final String gambar;
  final String nama;
  final String kategori;
  final int idDesawisata;

  Akomodasi({
    required this.id,
    required this.gambar,
    required this.nama,
    required this.kategori,
    required this.idDesawisata,
  });

  factory Akomodasi.fromJson(Map<String, dynamic> json) {
    return Akomodasi(
        id: json['id'],
        gambar: json['gambar'],
        nama: json['nama'],
        kategori: json['kategori'],
        idDesawisata: json['id_desawisata']);
  }
}
