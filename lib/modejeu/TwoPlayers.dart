import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../views/Start.dart';
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

  Widget _buildCell(int index, Color color) {
    return GestureDetector(
      onTap: () {
        _onTap(index);
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

  Widget _player(String nomPlayer, int score) {
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
                Icon(Icons.people),
                Text(' '),
                Text(nomPlayer),
                Text(
                  '',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Text('Score : ${score}')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Jeu de Songho')),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              child: DrawerHeader(
                child: Center(
                  child: Text(
                    'Songho',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.cached_outlined),
              title: Text("Recommencer"),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const TwoPlayers()),
                          (route) => false);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Acceuil"),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                Future.delayed(Duration(seconds: 1), () {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Start()),
                          (route) => false);
                });
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Fermer'),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('A propos de notre jeu de songho '),
              ),
            ),
          ],
        ),
      ),
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
                    _player('Player 1', score1),
                    Text(message),
                    _player('Player 2', score2)
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
                            _buildCell(i, Colors.grey[300]!),
                            SizedBox(
                              height: 10,
                              width: 10,
                            ),
                          ],
                        ),
                      for (int i = 7; i <= 13; i++)
                        Row(
                          children: [
                            _buildCell(i, Colors.grey[300]!),
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

  void _onTap(int index) {
    setState(() {
      if(_jeuEstEnCours == false){
        if(statuts == "J1") {
          if (index >= 0 && index <= 6) {
            statut_joueur = 0;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Erreur'),
                  content: Text('Cette case ne vous appartient pas.'),
                  actions: <Widget>[
                    FloatingActionButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            if (_board[index] != 0) {
              _distributePawns(index);
             setState(() {
               message = "Patientez J2.....";
               statuts = "J2";
             });
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Erreur'),
                    content: Text('Selectionner une case contenant des pions'),
                    actions: <Widget>[
                      FloatingActionButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }
        }else {
      statut_joueur = 0;
      if (index >= 7 && index <= 13) {
      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
      return AlertDialog(
      title: Text('Erreur'),
      content: Text('Cette case ne vous appartient pas.'),
      actions: <Widget>[
      FloatingActionButton(
      child: Text('OK'),
      onPressed: () {
      Navigator.of(context).pop();
      },
      ),
      ],
      );
      },
      );
      } else {
      if (_board[index] != 0) {
      _distributePawns(index);
      setState(() {
        message = "Patienter J1...";
        statuts = "J1";
      });
      } else {
      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
      return AlertDialog(
      title: Text('Erreur'),
      content: Text('Selectionner une case contenant des pions'),
      actions: <Widget>[
      FloatingActionButton(
      child: Text('OK'),
      onPressed: () {
      Navigator.of(context).pop();
      },
      ),
      ],
      );
      },
      );
      }
      }
      }
      }else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
          Center(child: Text('Veuillez Patienter..')),
          duration: Duration(milliseconds: 500),
          backgroundColor: const Color.fromARGB(255, 154, 153, 157),
          padding: const EdgeInsets.all(15.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
              behavior: SnackBarBehavior.floating,
              width: 300,
        ),);
      }
    });
  }

  Future<void> _distributePawns(int index) async {
    int pawns = _board[index];
    _board[index] = 0;
    int currentIndex = index;
    //distribuer les pions dans le sens inverse des aiguilles d'une montre
    while (pawns > 0){
      currentIndex = (currentIndex + 1) % 14;
      final player = AudioCache();
      player.play('distri.wav');
      if (currentIndex != index){
        setState((){
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

    while (_board[currentIndex] >= 2 && _board[currentIndex] <= 4){
      setState((){
        if (statuts == "J2") {
          score1 = score1 + _board[currentIndex];
        }else{
          score2 = score2 + _board[currentIndex];
        }
        final player = AudioCache();
        player.play('prise.mp3');
        _board[currentIndex] = 0;
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      if(currentIndex == 0){
        currentIndex = 14;
      }
      currentIndex--;
    }

    setState(() {
      _jeuEstEnCours = false;
    });

    setState((){
      if(statuts == "J1"){
        message = "A vous de Jouer joueur 1";
      }else{
        message = "A vous de Jouer joueur 2";
      }
    });

    //verif pour le score deja
    setState(() {
      if(score1 >= 35 && score2 < 35) {
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
         cpt2 =  cpt2 + _board[i];
        }
      }
      if (70 - (score2 + score1) < 10) {
        if ((score1 + cpt1) > 35) {
          messageSuccess = "Victoire  J1";
          _WinnerSms(messageSuccess);
        }else if ((score2 + cpt2) > 35) {
          messageSuccess = "Victoire J2";
          _WinnerSms(messageSuccess);
        }
      }

      if(cpt1 == 0 && cpt2!=0){
        messageSuccess = "Victoire ! J2";
        _WinnerSms(messageSuccess);
      }
      if(cpt1 != 0 && cpt2 == 0) {
        messageSuccess = "Victoire ! J1";
        _WinnerSms(messageSuccess);
      }

    });
  }
}
