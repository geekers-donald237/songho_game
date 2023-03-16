import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:songhogame/views/Start.dart';

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
  int cpt1 = 0,
      cpt2 = 0;
  bool _jeuEstEnCours = false;


  Widget _buildCell(int index, Color color){
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
                Text('', style: TextStyle(fontSize: 14),),
              ],
            ),
          ),
          Text('Score : ${score}')
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Jeu de Songho')),
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
                      MaterialPageRoute(builder: (context) => const OnePlayers()),
                          (route) => false
                  );
                });
              },

            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Acceuil"),
              onTap: (){
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
                          (route) => false
                  );
                });
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Fermer'),
              onTap: (){
                SystemNavigator.pop();
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child:
              ListTile(
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
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _player('You ', scorePlayer),
                    Text(message),
                    _player('Computer', scoreComputer)
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
                    ]
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  void _WinnerSms(String sms) {
    showDialog(context: context,barrierDismissible: false, builder: (BuildContext context) {
      return AlertDialog(title: Text('Successs !'), content: Text(sms),
        actions: <Widget>[
          FloatingActionButton(child: Text('OK'), onPressed: () {
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


  void _onTap(int index) {
    setState(() {
      if(_jeuEstEnCours == false){
        if (index >= 0 && index <= 6) {
          showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
            return AlertDialog(title: Text('Erreur'),
              content: Text('Cette case ne vous appartient pas.'),
              actions: <Widget>[
                FloatingActionButton(child: Text('OK'), onPressed: () {
                  Navigator.of(context).pop();
                },
                ),
              ],
            );
          },
          );
        } else {
          if (_board[index] != 0) {
            message = "Vous Jouez..... ";
            _distributePawns(index);
          }else {
            showDialog( context: context, barrierDismissible: false, builder: (BuildContext context) {
              return AlertDialog( title: Text('Erreur'),
                content: Text('Selectionner une case contenant des pions'),
                actions: <Widget>[ FloatingActionButton( child: Text('OK'), onPressed: () {
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

    while(_board[currentIndex] >= 2 && _board[currentIndex] <= 4){
      setState(() {
        scorePlayer = scorePlayer + _board[currentIndex];
        final player = AudioCache();
        player.play('prise.mp3');
        _board[currentIndex]= 0;
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

  Future<void> _computerDistributePawns()async {
        int computerMoveIndex = Random().nextInt(7);
        while(_board[computerMoveIndex] == 0){
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

        while(_board[currentComputerIndex] >= 2 && _board[currentComputerIndex] <= 4){
            setState((){
              scoreComputer = scoreComputer + _board[currentComputerIndex];
              final player = AudioCache();
              player.play('prise.mp3');
              _board[currentComputerIndex]= 0;
            });
            await Future.delayed(const Duration(milliseconds: 1500));
            currentComputerIndex--;
        }

        setState(() {
          if(scorePlayer >= 35 && scoreComputer < 35){
            messageSuccess = "Victoire !!!!";
            _WinnerSms(messageSuccess);
          }if(scorePlayer < 35 && scoreComputer >= 35) {
            messageSuccess = "Game Over";
            _WinnerSms(messageSuccess);
          }
        });
         setState(() {
           for (int i = 6; i >= 0; i--){
             if(_board[i] != 0){
               cpt1++;
             }
           }

           for (int i = 7; i <= 13; i++){
             if(_board[i] != 0){
               cpt2++;
             }
           }

           if(cpt1 == 0 && cpt2!=0){
             messageSuccess = "Game Over";
             _WinnerSms(messageSuccess);
           }else if(cpt1 != 0 && cpt2 == 0) {
             messageSuccess = "Victoire !!!";
             _WinnerSms(messageSuccess);
           }

         });

        setState(() {
          if(cpt1 == 0 && cpt2 != 0){
            messageSuccess = "Victoire !!!!!!";
            _WinnerSms(messageSuccess);
          }
          if(cpt2 == 0 && cpt1 != 0){
            messageSuccess = "Youre are lose";
            _WinnerSms(messageSuccess);
          }
        });


        setState(() {
          if(70 - (scorePlayer + scoreComputer) < 10){
            if((scorePlayer + cpt1) > 35){
              messageSuccess = "Vous avez perdue";
              _WinnerSms(messageSuccess);
            }else if((scoreComputer + cpt2) > 35){
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
}


