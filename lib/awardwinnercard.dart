import 'package:flutter/material.dart';




class AwardWinnerCard extends StatelessWidget {
  final String awardName;
  final String projectTitle;
  final List<String> members;
  
  const AwardWinnerCard(this.awardName, this.projectTitle, this.members, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            awardName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Title: "$projectTitle"',
            style: TextStyle(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 10),
          Text(
            'Group Members:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: members.map((member) => Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                '• $member',
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
