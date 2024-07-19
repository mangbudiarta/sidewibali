class ReviewDestinasi {
  final int id;
  final int id_akun;
  final int id_destinasiwisata;
  final int rating;
  final String review;
  final bool setujui;

  ReviewDestinasi({
    required this.id,
    required this.id_akun,
    required this.id_destinasiwisata,
    required this.rating,
    required this.review,
    required this.setujui,
  });

  factory ReviewDestinasi.fromJson(Map<String, dynamic> json) {
    return ReviewDestinasi(
      id: json['id'],
      id_akun: json['id_akun'],
      id_destinasiwisata: json['id_destinasiwisata'],
      rating: json['rating'],
      review: json['review'],
      setujui: json['setujui'] == 1, // Ubah menjadi bool jika perlu
    );
  }
}
