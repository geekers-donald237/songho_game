import 'package:flutter/material.dart';
import 'package:songhogame/views/widget/player.dart';

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
          ),
          Text(message),
          Player(
            icon: Icons.laptop_chromebook,
            score: scoreComputer,
          )
        ],
      ),
    );
  }
}
