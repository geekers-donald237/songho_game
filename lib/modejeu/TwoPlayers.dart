import 'package:flutter/material.dart';
import 'package:songhogame/views/widget/drawer.dart';
import 'package:songhogame/views/widget/player.dart';
import 'package:audioplayers/audioplayers.dart';

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

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
                    Player(score: score1, icon: Icons.people),
                    Text(message),
                    Player(score: score2, icon: Icons.people)
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
                    MaterialPageRoute(builder: (context) => const TwoPlayers()),
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
        if (statuts == "J2") {
          score1 = score1 + _board[currentIndex];
        } else {
          score2 = score2 + _board[currentIndex];
        }
        final player = AudioCache();
        player.play('prise.mp3');
        _board[currentIndex] = 0;
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
      if (score1 >= 35 && score2 < 35) {
        messageSuccess = "Victoire J1";
        _WinnerSms(messageSuccess);
      }
      if (score1 < 35 && score2 >= 35) {
        messageSuccess = "Victoire  J2";
        _WinnerSms(messageSuccess);
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
      if (70 - (score2 + score1) < 10) {
        if ((score1 + cpt1) > 35) {
          messageSuccess = "Victoire  J1";
          _WinnerSms(messageSuccess);
        } else if ((score2 + cpt2) > 35) {
          messageSuccess = "Victoire J2";
          _WinnerSms(messageSuccess);
        }
      }

      if (cpt1 == 0 && cpt2 != 0) {
        messageSuccess = "Victoire ! J2";
        _WinnerSms(messageSuccess);
      }
      if (cpt1 != 0 && cpt2 == 0) {
        messageSuccess = "Victoire ! J1";
        _WinnerSms(messageSuccess);
      }
    });
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

   void _onTapCell(int index) {
    setState(() {
      if (_jeuEstEnCours == false) {
        if (statuts == "J1") {
          if (index >= 0 && index <= 6) {
            statut_joueur = 0;
            showSnackBar(context, "Cette case ne vous appartient pas.");
          } else {
            if (_board[index] != 0) {
              _distributePawns(index);
              setState(() {
                message = "Patientez J2.....";
                statuts = "J2";
              });
            } else {
              showSnackBar(context, "Selectionner une case contenant ds pions");
            }
          }
        } else {
          statut_joueur = 0;
          if (index >= 7 && index <= 13) {
            showSnackBar(context, "Cette case ne vous appartient pas.");
          } else {
            if (_board[index] != 0) {
              _distributePawns(index);
              setState(() {
                message = "Patienter J1...";
                statuts = "J1";
              });
            } else {
              showSnackBar(context, "Selectionner une case contenant ds pions");
            }
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
