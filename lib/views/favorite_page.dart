import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/models/destinasi_model.dart';
import 'package:sidewibali/models/desawisata_model.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:sidewibali/utils/colors.dart';
import 'package:sidewibali/views/detaildestinasi_page.dart';
import 'package:sidewibali/views/detaildesa_page.dart';
import 'package:sidewibali/views/login_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  late TabController _tabController;
  List<DesaWisata> favoriteDesas = [];
  List<Destinasi> favoriteDestinations = [];
  List<int> likedDestinationsId = [];
  List<int> likedDesasId = [];
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchDestinasiFavorit();
    _fetchDesaFavorit();
  }

  Future<void> _toggleFavorite(int idDestinasi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? userId = prefs.getInt('userId');

    if (token == null || token.isEmpty || userId == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
      return;
    }

    final List<int> favorites = await apiService.fetchMyDestinasiFavorite();
    if (favorites.contains(idDestinasi)) {
      final int idFavorit = await apiService.fetchIdByIdDestinasi(idDestinasi);
      final isUnlike = await apiService.deleteDestinasiFavorite(idFavorit);
      if (isUnlike) {
        setState(() {
          likedDestinationsId.remove(idDestinasi);
          likeCount--;
        });
      } else {
        print("Gagal unlike");
      }
    } else {
      final isLike = await apiService.addDestinasiFavorite(idDestinasi);
      if (isLike) {
        setState(() {
          likedDestinationsId.add(idDestinasi);
          likeCount++;
        });
      } else {
        print("Gagal like");
      }
    }
  }

  Future<void> _toggleDesaFavorite(int idDesa) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? userId = prefs.getInt('userId');

    if (token == null || token.isEmpty || userId == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
      return;
    }

    final List<int> favorites = await apiService.fetchMyDesaFavorite();
    if (favorites.contains(idDesa)) {
      final int idFavorit = await apiService.fetchIdByIdDesa(idDesa);
      final isUnlike = await apiService.deleteDesaFavorite(idFavorit);
      if (isUnlike) {
        setState(() {
          likedDesasId.remove(idDesa);
          likeCount--;
        });
      } else {
        print("Gagal unlike");
      }
    } else {
      final isLike = await apiService.addDesaFavorite(idDesa);
      if (isLike) {
        setState(() {
          likedDesasId.add(idDesa);
          likeCount++;
        });
      } else {
        print("Gagal like");
      }
    }
  }

  Future<void> _fetchDestinasiFavorit() async {
    try {
      List<int> destinationId = await apiService.fetchMyDestinasiFavorite();
      setState(() {
        likedDestinationsId = destinationId;
      });
      await _fetchDestinationDetails(destinationId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchDesaFavorit() async {
    try {
      List<int> desaId = await apiService.fetchMyDesaFavorite();
      setState(() {
        likedDesasId = desaId;
      });
      await _fetchDesaDetails(desaId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchDestinationDetails(List<int> destinationId) async {
    List<Destinasi> destinations = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    for (int id in destinationId) {
      final response = await http.get(
        Uri.parse('http://8.215.11.162:3000/destinasiwisata/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        final destinasi = Destinasi.fromJson(data);
        destinations.add(destinasi);
      } else {
        throw Exception('Failed to load destination details');
      }
    }

    setState(() {
      favoriteDestinations = destinations;
    });
  }

  Future<void> _fetchDesaDetails(List<int> desaId) async {
    List<DesaWisata> desas = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    for (int id in desaId) {
      final response = await http.get(
        Uri.parse('http://8.215.11.162:3000/desawisata/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        final desa = DesaWisata.fromJson(data);
        desas.add(desa);
      } else {
        throw Exception('Failed to load desa details');
      }
    }

    setState(() {
      favoriteDesas = desas;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primary,
          labelColor: primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Desa Favorit'),
            Tab(text: 'Destinasi Favorit'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildDesaFavoriteList(favoriteDesas),
          buildDestinasiFavoriteList(favoriteDestinations),
        ],
      ),
    );
  }

  Widget buildDestinasiFavoriteList(List<Destinasi> favorites) {
    return favorites.isEmpty
        ? Center(
            child: Text('Belum ada destinasi favorit, yuk tambahkan!',
                style: TextStyle(fontSize: 16, color: Colors.grey)))
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              var favorite = favorites[index];
              String name = favorite.nama;
              String image = favorite.gambar;
              bool isFavorite = likedDestinationsId.contains(favorite.id);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailDestinasi(destinasi: favorite),
                    ),
                  );
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                                bottom: Radius.circular(20)),
                            child: Image.network(
                              "http://8.215.11.162:3000/resource/destinasiwisata/$image",
                              width: double.infinity,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/default_image.png',
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                _toggleFavorite(favorite.id);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget buildDesaFavoriteList(List<DesaWisata> favorites) {
    return favorites.isEmpty
        ? Center(
            child: Text('Belum ada desa favorit, yuk tambahkan!',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])))
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              var favorite = favorites[index];
              String name = favorite.nama;
              String image = favorite.gambar;
              bool isFavorite = likedDesasId.contains(favorite.id);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailDesa(desa: favorite),
                    ),
                  );
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                                bottom: Radius.circular(20)),
                            child: Image.network(
                              "http://8.215.11.162:3000/resource/desawisata/$image",
                              width: double.infinity,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/default_image.png',
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                _toggleDesaFavorite(favorite.id);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
