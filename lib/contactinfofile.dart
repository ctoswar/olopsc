import 'package:flutter/material.dart';


class ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  
  const ContactInfoTile(this.icon, this.title, this.content, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.indigo,
          ),
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 15, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
