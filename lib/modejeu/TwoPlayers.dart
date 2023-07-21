import 'package:flutter/material.dart';
import 'package:songhogame/controller/gameController.dart';
import 'package:songhogame/views/widget/drawer.dart';
import 'package:songhogame/views/widget/player.dart';

class TwoPlayers extends StatefulWidget {
  const TwoPlayers({Key? key}) : super(key: key);
  @override
  State<TwoPlayers> createState() => _TwoPlayersState();
}

class _TwoPlayersState extends State<TwoPlayers> {
  late List<int> _board;
  late List<Color> _colorList;
  @override
  void initState() {
    super.initState();
    // initialisation du plateau avec 5 billes par case
    _board = List<int>.filled(14, 5);
    // _board = [1, 3, 2, 6, 2, 2, 2, 2, 3, 2, 4, 4, 2, 3];

    _colorList = List<Color>.generate(14, (index) => Colors.grey[300]!);
  }

  int score1 = 0;
  int score2 = 0;
  String message = "Joueur 1 a vous de commencer";
  String statuts = "J1";
  int statut_joueur = 1;
  int gagnant = -1;
  String winner = "";
  String messageSuccess = "";
  int cpt1 = 0, cpt2 = 0;
  bool _jeuEstEnCours = false;
  final gameController = GameController();

  @override
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Player(
                      score: score1,
                      icon: Icons.people,
                      playerName: 'J1',
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize:
                            14, // Taille de police plus petite que l'original (à ajuster selon vos préférences)
                        fontWeight: FontWeight
                            .bold, // Texte en gras pour attirer l'attention
                        color: Colors.black, // Couleur du texte
                      ),
                    ),
                    Player(
                      score: score2,
                      icon: Icons.people,
                      playerName: 'J2',
                    )
                  ],
                ),
              ),
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

  Future<void> _distributePawns(int index) async {
    int pawns = _board[index];
    bool isMyHome = false;
    _board[index] = 0;
    int currentIndex = index;

    //distribuer les pions dans le sens inverse des aiguilles d'une montre
    while (pawns > 0) {
      currentIndex = (currentIndex + 1) % 14;

      gameController.playSound('distri.wav');

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

    if (((index >= 0 && index <= 6) &&
            (currentIndex >= 0 && currentIndex <= 6)) ||
        ((index >= 7 && index <= 13) &&
            (currentIndex >= 7 && currentIndex <= 13))) {
      setState(() {
        isMyHome = true;
      });
    } else {
      setState(() {
        isMyHome = false;
      });
    }

    bool allWithinRange = true;

    // Vérifier si toutes les cases de A ou B ont un nombre de pierres compris entre 2 et 4
    if ((index >= 0 && index <= 6) || (index >= 7 && index <= 13)) {
      for (int i = 0; i <= 6; i++) {
        if (_board[i] < 2 || _board[i] > 4) {
          allWithinRange = false;
          break;
        }
      }
    }

    // Ne pas effectuer de prise si toutes les cases de A ou B ont un nombre de pierres compris entre 2 et 4
    if (allWithinRange) {
      setState(() {
        _jeuEstEnCours = false;
      });

      setState(() {
        if (statuts == "J1") {
          message = "A vous de Jouer joueur 1";
        } else {
          message = "A vous de Jouer joueur 2";
        }
      });

      return;
    }

    while (
        _board[currentIndex] >= 2 && _board[currentIndex] <= 4 && !isMyHome) {
      setState(() {
        if (statuts == "J2" && currentIndex >= 0 && currentIndex <= 6) {
          // Vérifier que la case actuelle appartient au joueur 1
          // et qu'elle remplit les conditions de prise
          if (_board[currentIndex] >= 2 && _board[currentIndex] <= 4) {
            score1 = score1 + _board[currentIndex];
            gameController.playSound('prise.mp3');
            _board[currentIndex] = 0;
          }
        } else if (statuts == "J1" && currentIndex >= 7 && currentIndex <= 13) {
          // Vérifier que la case actuelle appartient au joueur 2
          // et qu'elle remplit les conditions de prise
          if (_board[currentIndex] >= 2 && _board[currentIndex] <= 4) {
            score2 = score2 + _board[currentIndex];

            gameController.playSound('prise.mp3');
            _board[currentIndex] = 0;
          }
        }
      });

      await Future.delayed(const Duration(milliseconds: 1500));
      if (currentIndex == 0) {
        currentIndex = 14;
      }
      currentIndex--;
    }

    setState(() {
      _jeuEstEnCours = false;
    });

    setState(() {
      if (statuts == "J1") {
        message = "A vous de Jouer joueur 1";
      } else {
        message = "A vous de Jouer joueur 2";
      }
    });

    //verif pour le score deja
    setState(() {
      if (score1 > 35 && score2 <= 35) {
        messageSuccess = "Victoire J1";
        gameController.WinnerSms(messageSuccess, context);
      }
      if (score1 <= 35 && score2 > 35) {
        messageSuccess = "Victoire J2";
        gameController.WinnerSms(messageSuccess, context);
      }
    });

    //Vicoire en fonction du nombre de pierres de son cote
    setState(() {
      for (int i = 6; i >= 0; i--) {
        if (_board[i] != 0) {
          cpt1 = cpt1 + _board[i];
        }
      }

      for (int i = 7; i <= 13; i++) {
        if (_board[i] != 0) {
          cpt2 = cpt2 + _board[i];
        }
      }
      if (score1 < 35 && score2 < 35 && (cpt1 + cpt2) < 10) {
        if ((score1 + cpt1) > 35) {
          messageSuccess = "Victoire J1";
          gameController.WinnerSms(messageSuccess, context);
        } else if ((score2 + cpt2) > 35) {
          messageSuccess = "Victoire J2";
          gameController.WinnerSms(messageSuccess, context);
        }
      }

      if (cpt1 == 0 && cpt2 != 0) {
        messageSuccess = "Victoire J2";
        gameController.WinnerSms(messageSuccess, context);
      }
      if (cpt1 != 0 && cpt2 == 0) {
        messageSuccess = "Victoire J1";
        gameController.WinnerSms(messageSuccess, context);
      }
    });
  }

  void _onTapCell(int index) {
    if ((index == 0 || index == 7) && (_board[index] == 1)) {
      gameController.showSnackBar(context, "Impossible de jouer cette case");
    } else if ((index == 0 || index == 7) && (_board[index] == 2)) {
      if (((_board[(index + 1)] < 4) && (_board[(index + 1)] >= 2)) &&
          ((_board[(index + 2)] < 4) && (_board[(index + 2)] >= 2))) {
        _distributePawns(index);
      } else {
        gameController.showSnackBar(context, "Impossible de jouer cette case");
      }
    } else {
      setState(() {
        if (_jeuEstEnCours == false) {
          if (statuts == "J1") {
            if (index >= 0 && index <= 6) {
              statut_joueur = 0;
              gameController.showSnackBar(
                  context, "Cette case ne vous appartient pas.");
            } else {
              if (_board[index] != 0) {
                _distributePawns(index);
                setState(() {
                  message = "Patientez J2.....";
                  statuts = "J2";
                });
              } else {
                gameController.showSnackBar(
                    context, "Selectionner une case contenant ds pions");
              }
            }
          } else {
            statut_joueur = 0;
            if (index >= 7 && index <= 13) {
              gameController.showSnackBar(
                  context, "Cette case ne vous appartient pas.");
            } else {
              if (_board[index] != 0) {
                _distributePawns(index);
                setState(() {
                  message = "Patienter J1...";
                  statuts = "J1";
                });
              } else {
                gameController.showSnackBar(
                    context, "Selectionner une case contenant ds pions");
              }
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
  }

  Widget buildCell(int index, Color color) {
    return GestureDetector(
      onTap: () {
        _onTapCell(index);
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
}
