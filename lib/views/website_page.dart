import 'package:flutter/material.dart';
import 'package:sidewibali/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsitePage extends StatelessWidget {
  // url website
  final String url = "https://bali.jadesta.com/";

  const WebsitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Website'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/logo_text_max.png',
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'Selamat datang di Sidewi Bali',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Temukan keindahan dan budaya Bali bersama kami. Jelajahi juga lebih lanjut melalui website kami.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color.fromARGB(255, 0, 194, 204),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Buka Website', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
