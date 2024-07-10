import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final Widget page;

  MenuItem(this.title, this.imagePath, this.page);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: screenSize.width * 0.06,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: const TextStyle(fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
