class ReviewDestinasi {
  final int id;
  final int idAkun;
  final int idDestinasiwisata;
  final int rating;
  final String review;
  final bool setujui;

  ReviewDestinasi({
    required this.id,
    required this.idAkun,
    required this.idDestinasiwisata,
    required this.rating,
    required this.review,
    required this.setujui,
  });

  factory ReviewDestinasi.fromJson(Map<String, dynamic> json) {
    return ReviewDestinasi(
      id: json['id'],
      idAkun: json['id_akun'],
      idDestinasiwisata: json['id_destinasiwisata'],
      rating: json['rating'],
      review: json['review'],
      setujui: json['setujui'] == 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_akun': idAkun,
      'id_destinasiwisata': idDestinasiwisata,
      'rating': rating,
      'review': review,
      'setujui': setujui ? 1 : 0,
    };
  }
}
