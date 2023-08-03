import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final int score;
  final IconData icon;
  final String playerName;

  const Player({
    Key? key,
    required this.score,
    required this.icon,
    required this.playerName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      child: Container(
        width: 120,
        height: 50,
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: 28),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    playerName,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Score: $score',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
