import 'package:flutter/material.dart';
import 'package:songhogame/widget/player.dart';

class GameInfoBar extends StatelessWidget {
  const GameInfoBar({
    super.key,
    required this.scorePlayer,
    required this.message,
    required this.scoreComputer,
  });

  final int scorePlayer;
  final String message;
  final int scoreComputer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Player(
            icon: Icons.person,
            score: scorePlayer,
            playerName: 'J1',
          ),
          Text(
            message,
            style: TextStyle(
              fontSize:
                  14, // Taille de police plus petite que l'original (à ajuster selon vos préférences)
              fontWeight:
                  FontWeight.bold, // Texte en gras pour attirer l'attention
              color: Colors.black, // Couleur du texte
            ),
          ),
          Player(
            icon: Icons.laptop_chromebook,
            score: scoreComputer,
            playerName: 'IA',
          )
        ],
      ),
    );
  }
}
