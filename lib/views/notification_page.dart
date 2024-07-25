import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sidewibali/models/notifikasi_model.dart';
import 'package:sidewibali/services/api_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<Notifikasi>> _NotifikasiFuture;

  @override
  void initState() {
    super.initState();
    _NotifikasiFuture = ApiService().fetchNotifikasi();
  }

  Future<void> _updateStatus(int id) async {
    bool response = await ApiService().updateStatusNotifikasi(id);
    if (response) {
      setState(() {
        _NotifikasiFuture = ApiService().fetchNotifikasi();
      });
    } else {
      print('Gagal update status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Notifikasi>>(
        future: _NotifikasiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Tidak ada notifikasi',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600])));
          } else {
            final notifikasiList = snapshot.data!;
            notifikasiList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return ListView.builder(
              itemCount: notifikasiList.length,
              itemBuilder: (context, index) {
                final notifikasi = notifikasiList[index];
                final createdAt = notifikasi.createdAt;
                final formattedDate =
                    DateFormat('dd MMMM yyyy, HH:mm').format(createdAt);

                return Column(
                  children: [
                    if (index > 0)
                      Divider(height: 0.5, color: Colors.grey[300]),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(
                        notifikasi.deskripsi,
                        style: TextStyle(
                          fontWeight: notifikasi.status
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: notifikasi.status
                              ? Colors.black
                              : Colors.grey[700],
                        ),
                      ),
                      subtitle: Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        if (notifikasi.status) {
                          _updateStatus(notifikasi.id);
                        }
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
