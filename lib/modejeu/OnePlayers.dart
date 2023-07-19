import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:songhogame/views/widget/drawer.dart';

import '../views/widget/gameInfo.dart';

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
    _colorList = List<Color>.generate(14, (index) => Colors.grey[300]!);
  }

  int scorePlayer = 0;
  int scoreComputer = 0;
  String message = "A vous de commencer";
  String statuts = "Player";
  int gagnant = -1;
  String winner = "";
  String messageSuccess = "";
  int cpt1 = 0, cpt2 = 0;
  bool _jeuEstEnCours = false;

  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  void _WinnerSms(String sms) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successs !'),
          content: Text(sms),
          actions: <Widget>[
            FloatingActionButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const OnePlayers()),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _distributePawns(int index) async {
    int pawns = _board[index];
    _board[index] = 0;
    int currentIndex = index;
    //distribuer les pions dans le sens inverse des aiguilles d'une montre
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

    while (_board[currentIndex] >= 2 && _board[currentIndex] <= 4) {
      setState(() {
        scorePlayer = scorePlayer + _board[currentIndex];
        final player = AudioCache();
        player.play('prise.mp3');
        _board[currentIndex] = 0;
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      currentIndex--;
    }

    setState(() {
      message = "patientez....,L'ordinateur joue";
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    _computerDistributePawns();
  }

  Future<void> _computerDistributePawns() async {
    int computerMoveIndex = Random().nextInt(7);
    while (_board[computerMoveIndex] == 0) {
      computerMoveIndex = Random().nextInt(7);
    }
    int computerMovePawns = _board[computerMoveIndex];
    _board[computerMoveIndex] = 0;
    int currentComputerIndex = computerMoveIndex;
    //distribuer les pions dans le sens inverse des aiguilles d'une montre
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
          computerMovePawns--;
        });
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      setState(() {
        _colorList[currentComputerIndex] = Colors.blue;
        _colorList[currentComputerIndex] = Colors.grey[300]!;
      });
    }

    while (_board[currentComputerIndex] >= 2 &&
        _board[currentComputerIndex] <= 4) {
      setState(() {
        scoreComputer = scoreComputer + _board[currentComputerIndex];
        final player = AudioCache();
        player.play('prise.mp3');
        _board[currentComputerIndex] = 0;
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      currentComputerIndex--;
    }

    setState(() {
      if (scorePlayer >= 35 && scoreComputer < 35) {
        messageSuccess = "Victoire !!!!";
        _WinnerSms(messageSuccess);
      }
      if (scorePlayer < 35 && scoreComputer >= 35) {
        messageSuccess = "Game Over";
        _WinnerSms(messageSuccess);
      }
    });
    setState(() {
      for (int i = 6; i >= 0; i--) {
        if (_board[i] != 0) {
          cpt1++;
        }
      }

      for (int i = 7; i <= 13; i++) {
        if (_board[i] != 0) {
          cpt2++;
        }
      }

      if (cpt1 == 0 && cpt2 != 0) {
        messageSuccess = "Game Over";
        _WinnerSms(messageSuccess);
      } else if (cpt1 != 0 && cpt2 == 0) {
        messageSuccess = "Victoire !!!";
        _WinnerSms(messageSuccess);
      }
    });

    setState(() {
      if (cpt1 == 0 && cpt2 != 0) {
        messageSuccess = "Victoire !!!!!!";
        _WinnerSms(messageSuccess);
      }
      if (cpt2 == 0 && cpt1 != 0) {
        messageSuccess = "Youre are lose";
        _WinnerSms(messageSuccess);
      }
    });

    setState(() {
      if (70 - (scorePlayer + scoreComputer) < 10) {
        if ((scorePlayer + cpt1) > 35) {
          messageSuccess = "Vous avez perdue";
          _WinnerSms(messageSuccess);
        } else if ((scoreComputer + cpt2) > 35) {
          messageSuccess = "Vous avez gagne";
          _WinnerSms(messageSuccess);
        }
      }
    });

    setState(() {
      message = "A vous de jouer..";
    });

    setState(() {
      _jeuEstEnCours = false;
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

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1000),
      padding: const EdgeInsets.all(15.0),
      width: 500,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void onTapBtn(int index) {
    setState(() {
      if (_jeuEstEnCours == false) {
        if (index >= 0 && index <= 6) {
          showSnackBar(context, "Cette case ne vous appartient pas.");
        } else {
          if (_board[index] != 0) {
            message = "Vous Jouez..... ";
            _distributePawns(index);
          } else {
            showSnackBar(context, "Selectionner une case contenant ds pions");
          }
        }
      } else {
        showSnackBar(
          context,
          "Veuillez patienter....",
        );
      }
    });
  }
}
