import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final int score;
  final IconData icon;

  const Player({
    Key? key,
    required this.score,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.rectangle,
      ),
      child: Column(
        children: [
          Center(
            child: Row(
              children: [
                Icon(icon),
                Text(
                  '',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Text('Score : $score') // Utilisez la variable score ici pour afficher le score réel
        ],
      ),
    );
  }
}
