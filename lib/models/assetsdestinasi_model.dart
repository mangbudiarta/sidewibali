class Assetdestinasi {
  final int id;
  final String gambar;
  final int idDesaWisata;

  Assetdestinasi({
    required this.id,
    required this.gambar,
    required this.idDesaWisata,
  });
  factory Assetdestinasi.fromJson(Map<String, dynamic> json) {
    return Assetdestinasi(
        id: json['id'],
        gambar: json['gambar'],
        idDesaWisata: json['id_desawisata']);
  }
}
