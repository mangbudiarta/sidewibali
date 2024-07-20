import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Destination> favoriteDestinations = [
    Destination(
      name: 'Desa Ubud',
      image: 'assets/images/ubud.png',
      isLiked: true,
    ),
    Destination(
      name: 'Danau Beratan',
      image: 'assets/images/beratan.png',
      isLiked: true,
    ),
    Destination(
      name: 'Desa Kuta',
      image: 'assets/images/kuta.png',
      isLiked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: favoriteDestinations.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Aksi jika ditekan
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Stack(
                      children: [
                        Image.asset(
                          favoriteDestinations[index].image,
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                favoriteDestinations[index].isLiked =
                                    !favoriteDestinations[index].isLiked;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                favoriteDestinations[index].isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: favoriteDestinations[index].isLiked
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      favoriteDestinations[index].name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Destination {
  final String name;
  final String image;
  bool isLiked;

  Destination({
    required this.name,
    required this.image,
    this.isLiked = false,
  });
}
