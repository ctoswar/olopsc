import 'package:flutter/material.dart';

class FooterNavItem extends StatelessWidget {
  final String text;
  
  const FooterNavItem(this.text, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: () {},
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}