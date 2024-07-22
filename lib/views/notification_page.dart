import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifikasiList = [
    {"deskripsi": "Selamat Datang Pengguna Baru", "bold": false},
    {"deskripsi": "Pemberitahuan Update Aplikasi", "bold": true},
    {"deskripsi": "Yuk ajak temanmu pakai Sidewi Bali", "bold": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: notifikasiList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              if (index > 0)
                Divider(
                    height: 0.5,
                    color: Colors.grey[300]), // Garis pembatas tipis
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  notifikasiList[index]["deskripsi"],
                  style: TextStyle(
                    fontWeight: notifikasiList[index]["bold"]
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: notifikasiList[index]["bold"]
                        ? Colors.black
                        : Colors.grey[700], // Warna abu-abu yang lebih gelap
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (notifikasiList[index]["bold"]) {
                      notifikasiList[index]["bold"] =
                          !notifikasiList[index]["bold"];
                    }
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: NotificationPage(),
  ));
}
