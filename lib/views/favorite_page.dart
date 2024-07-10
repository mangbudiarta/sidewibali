import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
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
        title: Text('Favorit'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: favoriteDestinations.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Implement onTap action if needed
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: Stack(
                      children: [
                        Image.asset(
                          favoriteDestinations[index].image,
                          width: double.infinity,
                          height: 160, // Adjusted height
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(
                              favoriteDestinations[index].isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favoriteDestinations[index].isLiked
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                favoriteDestinations[index].isLiked =
                                    !favoriteDestinations[index].isLiked;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      favoriteDestinations[index].name,
                      style: TextStyle(
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
