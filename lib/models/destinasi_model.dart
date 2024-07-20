class Destinasi {
  final int id;
  final String gambar;
  final String nama;
  final String deskripsi;
  final int idKategoridestinasi;
  final int idDesawisata;

  Destinasi({
    required this.id,
    required this.gambar,
    required this.nama,
    required this.deskripsi,
    required this.idKategoridestinasi,
    required this.idDesawisata,
  });
  factory Destinasi.fromJson(Map<String, dynamic> json) {
    return Destinasi(
        id: json['id'],
        gambar: json['gambar'],
        nama: json['nama'],
        deskripsi: json['deskripsi'],
        idKategoridestinasi: json['id_kategoridestinasi'],
        idDesawisata: json['id_desawisata']);
  }
}
