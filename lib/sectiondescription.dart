import 'package:flutter/material.dart';


class SectionDescription extends StatelessWidget {
  final String text;

  const SectionDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1.5),
        textAlign: TextAlign.center,
      ),
    );
  }
}
