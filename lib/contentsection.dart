import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContentSection extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  const ContentSection({super.key, required this.backgroundColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: child,
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color textColor;
  final Color dividerColor;

  const SectionHeader({super.key, 
    required this.title,
    required this.subtitle,
    required this.textColor,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.raleway(
            fontSize: 18,
            color: textColor.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: 50,
          height: 4,
          color: dividerColor,
        ),
      ],
    );
  }
}

