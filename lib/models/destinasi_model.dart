class Destinasi {
  final int id;
  final String gambar;
  final String nama;
  final String deskripsi;
  final int id_kategoridestinasi;
  final int id_desawisata;

  Destinasi({
    required this.id,
    required this.gambar,
    required this.nama,
    required this.deskripsi,
    required this.id_kategoridestinasi,
    required this.id_desawisata,
  });
  factory Destinasi.fromJson(Map<String, dynamic> json) {
    return Destinasi(
        id: json['id'],
        gambar: json['gambar'],
        nama: json['nama'],
        deskripsi: json['deskripsi'],
        id_kategoridestinasi: json['id_kategoridestinasi'],
        id_desawisata: json['id_desawisata']);
  }
}
