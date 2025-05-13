import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamMember extends StatelessWidget {
  final String name;
  final String position;
  final String imageUrl;
  final String description;
  final String role;
  final String photoUrl;

  const TeamMember({
    super.key, 
    required this.name,
    required this.position,
    required this.imageUrl,
    required this.description,
    required this.role,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(imageUrl),
        ),
        SizedBox(height: 15),
        Text(
          name,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.indigo.shade800,
          ),
        ),
        SizedBox(height: 5),
        Text(
          position,
          style: GoogleFonts.raleway(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 200,
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}