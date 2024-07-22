class Produk {
  final int id;
  final String nama;
  final int harga;
  final String deskripsi;
  final int idDesawisata;
  final String gambar;

  Produk({
    required this.id,
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.idDesawisata,
    required this.gambar,
  });
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
        id: json['id'],
        gambar: json['gambar'],
        nama: json['nama'],
        deskripsi: json['deskripsi'],
        harga: json['harga'],
        idDesawisata: json['id_desawisata']);
  }
}
