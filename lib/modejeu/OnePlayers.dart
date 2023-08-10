import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:songhogame/controller/gameController.dart';
import 'package:songhogame/widget/drawer.dart';
import 'package:songhogame/widget/gameInfo.dart';

class OnePlayers extends StatefulWidget {
  const OnePlayers({Key? key}) : super(key: key);

  @override
  State<OnePlayers> createState() => _OnePlayersState();
}

class _OnePlayersState extends State<OnePlayers> {
  late List<int> _board;
  late List<Color> _colorList;

  @override
  void initState() {
    super.initState();
    // initialisation du plateau avec 5 billes par case
    _board = List<int>.filled(14, 5);
    // _board = [1, 4, 2, 3, 4, 1, 3, 2, 3, 2, 4, 4, 3, 4];

    _colorList = List<Color>.generate(14, (index) => Colors.grey[300]!);
  }

  int scorePlayer = 0;
  int scoreComputer = 0;
  String message = "A vous de commencer";
  int gagnant = -1;
  String winner = "";
  String messageSuccess = "";
  int cpt1 = 0, cpt2 = 0;
  bool _jeuEstEnCours = false;
  final gameController = GameController();

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Jeu de Songho')),
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                GameInfoBar(
                    scorePlayer: scorePlayer,
                    message: message,
                    scoreComputer: scoreComputer),
                Container(
                  child: GridView.count(
                      padding: EdgeInsets.all(30),
                      primary: false,
                      shrinkWrap: true,
                      crossAxisCount: 7,
                      children: <Widget>[
                        for (int i = 6; i >= 0; i--)
                          Row(
                            children: [
                              buildCell(i, Colors.grey[300]!),
                              SizedBox(
                                height: 10,
                                width: 10,
                              ),
                            ],
                          ),
                        for (int i = 7; i <= 13; i++)
                          Row(
                            children: [
                              buildCell(i, Colors.grey[300]!),
                              SizedBox(
                                height: 10,
                                width: 10,
                              ),
                            ],
                          ),
                      ]),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _distributePawns(int index) async {
    int pawns = _board[index];
    bool isMyHome = false;
    _board[index] = 0;
    int currentIndex = index;

    // distribuer les pions dans le sens inverse des aiguilles d'une montre
    while (pawns > 0) {
      currentIndex = (currentIndex + 1) % 14;
      final player = AudioCache();
      player.play('distri.wav');
      if (currentIndex != index) {
        setState(() {
          _colorList[currentIndex] = Colors.grey[300]!;
          _colorList[currentIndex] = Colors.blue;
          _board[currentIndex]++;
          _jeuEstEnCours = true;
          pawns--;
        });
        await Future.delayed(const Duration(milliseconds: 1000));
      }
      setState(() {
        _colorList[currentIndex] = Colors.blue;
        _colorList[currentIndex] = Colors.grey[300]!;
      });
    }

    if ((index >= 7 && index <= 13) &&
        (currentIndex >= 7 && currentIndex <= 13)) {
      setState(() {
        isMyHome = true;
      });
    } else {
      setState(() {
        isMyHome = false;
      });
    }

    // La prise ne se passe que pour les valeurs d'indice comprises entre 0 et 6 (indices du joueur)
    while (_board[currentIndex] >= 2 &&
        _board[currentIndex] <= 4 &&
        !isMyHome &&
        currentIndex >= 0 &&
        currentIndex <= 6) {
      setState(() {
        scorePlayer = scorePlayer + _board[currentIndex];
      });

      final player = AudioCache();
      player.play('prise.mp3');
      _board[currentIndex] = 0;

      await Future.delayed(const Duration(milliseconds: 1500));
      if (currentIndex == 0) {
        currentIndex = 14;
      }
      currentIndex--;
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      message = "patientez....,L'ordinateur joue";
    });
    _computerDistributePawns();
  }

  Future<void> _computerDistributePawns() async {
    bool isMyHome = false;
    int computerMoveIndex = Random().nextInt(7);
    while (_board[computerMoveIndex] == 0) {
      computerMoveIndex = Random().nextInt(7);
    }
    int computerMovePawns = _board[computerMoveIndex];
    _board[computerMoveIndex] = 0;
    int currentComputerIndex = computerMoveIndex;

    // distribuer les pions dans le sens inverse des aiguilles d'une montre
    while (computerMovePawns > 0) {
      final player = AudioCache();
      player.play('distri.wav');
      currentComputerIndex = (currentComputerIndex + 1) % 14;
      if (currentComputerIndex != computerMoveIndex) {
        setState(() {
          _colorList[currentComputerIndex] = Colors.grey[300]!;
          _colorList[currentComputerIndex] = Colors.blue;
          _jeuEstEnCours = true;
          _board[currentComputerIndex]++;
        });
        computerMovePawns--;

        await Future.delayed(const Duration(milliseconds: 1500));
      }

      setState(() {
        _colorList[currentComputerIndex] = Colors.blue;
        _colorList[currentComputerIndex] = Colors.grey[300]!;
      });
    }

    // La prise se passe uniquement pour les valeurs d'indice comprises entre 7 et 13 (indices de l'adversaire)
    while (_board[currentComputerIndex] >= 2 &&
        _board[currentComputerIndex] <= 4 &&
        !isMyHome &&
        (currentComputerIndex >= 7 && currentComputerIndex <= 13)) {
      setState(() {
        scoreComputer = scoreComputer + _board[currentComputerIndex];
      });
      final player = AudioCache();
      player.play('prise.mp3');
      _board[currentComputerIndex] = 0;
      await Future.delayed(const Duration(milliseconds: 1500));
      if (currentComputerIndex == 0) {
        currentComputerIndex = 14;
      }
      currentComputerIndex--;
    }

     setState(() {
        message = "A vous de jouer..";
        _jeuEstEnCours = false;
      });

    setState(() {
      if (scorePlayer > 35 && scoreComputer <= 35) {
        messageSuccess = "Victoire !!!!";
        gameController.WinnerSms(messageSuccess, context);
      }
      if (scorePlayer <= 35 && scoreComputer > 35) {
        messageSuccess = "Game Over";
        gameController.WinnerSms(messageSuccess, context);
      }

      if (scoreComputer < 35 && scorePlayer < 35 && (cpt1 + cpt2) < 10) {
        if ((scorePlayer + cpt1) > 35) {
          messageSuccess = "Vous avez perdu";
          gameController.WinnerSms(messageSuccess, context);
        } else if ((scoreComputer + cpt2) > 35) {
          messageSuccess = "Vous avez gagné";
          gameController.WinnerSms(messageSuccess, context);
        }
      }

      if (cpt1 == 0 && cpt2 != 0) {
        messageSuccess = "Game Over";
        gameController.WinnerSms(messageSuccess, context);
      } else if (cpt1 != 0 && cpt2 == 0) {
        messageSuccess = "Victoire !!!";
        gameController.WinnerSms(messageSuccess, context);
      }
    });
  }

  Widget buildCell(int index, Color color) {
    return GestureDetector(
      onTap: () {
        onTapBtn(index);
      },
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: _colorList[index],
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        child: Center(
          child: Text(
            '${_board[index]}',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  void onTapBtn(int index) {
    if (index == 7 && _board[index] == 1) {
      gameController.showSnackBar(context, "Impossible de jouer cette case");
    } else if (index == 7 && _board[index] == 2) {
      if (((_board[(index + 1)] < 4) && (_board[(index + 1)] >= 2)) &&
          ((_board[(index + 2)] < 4) && (_board[(index + 2)] >= 2))) {
        _distributePawns(index);
      } else {
        gameController.showSnackBar(context, "Impossible de jouer cette case");
      }
    } else {
      setState(() {
        if (_jeuEstEnCours == false) {
          if (index >= 0 && index <= 6) {
            gameController.showSnackBar(
                context, "Cette case ne vous appartient pas.");
          } else {
            if (_board[index] != 0) {
              message = "Vous Jouez..... ";
              _distributePawns(index);
            } else {
              gameController.showSnackBar(
                  context, "Selectionner une case contenant ds pions");
            }
          }
        } else {
          gameController.showSnackBar(
            context,
            "Veuillez patienter....",
          );
        }
      });
    }
    setState(() {
      message;
    });
  }
}
