import 'package:flutter/material.dart';
import 'package:songhogame/models/online_page.dart';
import 'package:songhogame/widget/player1.dart';
import 'package:songhogame/widget/player2.dart';

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
          Player1(
            icon: Icons.person,
            score: scorePlayer,
            playerName: usernameP1,
          ),
          Container(
            padding: EdgeInsets.all(8), // Espacement interne du cadre
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 218, 203, 162), // Couleur du cadre
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Player2(
            icon: Icons.laptop_chromebook,
            score: scoreComputer,
            playerName: 'IA',
          )
        ],
      ),
    );
  }
}
