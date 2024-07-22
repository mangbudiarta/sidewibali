import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/models/destinasi_model.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:sidewibali/utils/colors.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Desa> favoriteDesas = [];
  List<Destinasi> favoriteDestinations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    ApiService().fetchMyDestinasiFavorite();
  }

  Future<void> _fetchDestinationDetails(List<int> destinationIds) async {
    List<Destinasi> destinations = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    for (int id in destinationIds) {
      final response = await http.get(
        Uri.parse('http://localhost:3000/destinasiwisata/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        destinations.add(Destinasi.fromJson(data));
      } else {
        throw Exception('Failed to load destination details');
      }
    }

    setState(() {
      favoriteDestinations = destinations;
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
          buildFavoriteList<Desa>(favoriteDesas),
          buildFavoriteList<Destinasi>(favoriteDestinations),
        ],
      ),
    );
  }

  Widget buildFavoriteList<T>(List<T> favorites) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        var favorite = favorites[index];
        String name = '';
        String image = '';
        bool isLiked = false;

        if (favorite is Desa) {
          name = favorite.name;
          image = favorite.image;
          isLiked = favorite.isLiked;
        } else if (favorite is Destinasi) {
          name = favorite.nama;
          image = favorite.gambar;
        }

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
                  child: Image.network(
                    image,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    name,
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
    );
  }
}

class Desa {
  final String name;
  final String image;
  bool isLiked;

  Desa({
    required this.name,
    required this.image,
    this.isLiked = false,
  });
}
