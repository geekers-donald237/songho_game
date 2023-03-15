import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'Regle.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);
  @override
  State<Start> createState() => _StartState();
}


class _StartState extends State<Start> {

  late List<int> _board;

  @override
  void initState() {
    super.initState();
    // initialisation du plateau avec 5 billes par case
    _board = List<int>.filled(14, 5);
  }

  int score1 = 0 ;
  int score2 = 0;
  String message = "Joueur 1 a vous de commencer";
  String statuts = "J1";
  Color? color = Colors.grey[300];
  int statut_joueur = 1;
  int gagnant = -1;
  String winner = "" ;
  String messageSuccess = "";
  int cpt1 = 0 , cpt2 = 0;

  void _onTap(int index) {
    setState(() {
      if(statuts == "J1"){
        if(index >= 0 && index <= 6){
          statut_joueur = 0;
          showDialog( context: context, builder: (BuildContext context) {
            return AlertDialog( title: Text('Erreur'),
              content: Text('Cette case ne vous appartient pas.'),
              actions: <Widget>[ FloatingActionButton( child: Text('OK'), onPressed: () {
                Navigator.of(context).pop();
              },
              ),
              ],
            );
          },
          );
        }else {
          _distributePawns(index);
          message = "Joueur 2 a vous de Jouer !!";
          statuts = "J2";
        }
      } else {
        statut_joueur = 0;
        if(index >= 7 && index <= 13){
          showDialog( context: context, builder: (BuildContext context) {
            return AlertDialog( title: Text('Erreur'), content: Text('Cette case ne vous appartient pas.'),
              actions: <Widget>[ FloatingActionButton( child: Text('OK'), onPressed: () {
                Navigator.of(context).pop();
              },
              ),
              ],
            );
          },
          );
        } else {
          _distributePawns(index);
          message = "Joueur 1 a vous de Jouer !!";
          statuts = "J1";
        }
      }
    }
    );
  }

  Widget _buildCell(int index) {
    return GestureDetector(
      onTap: () {
        _onTap(index);
      },
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color:color,
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

  Widget _player(String nomPlayer , int score){
    return Container(
      width: 110,
      height: 45,
      decoration: BoxDecoration(
        color:  Colors.grey[300],
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
                Text('',style: TextStyle(fontSize: 14),),
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
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Jeu de Songho')),
        actions: [
          IconButton(
            icon: Icon(Icons.live_help_outlined) ,onPressed:() {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Regle()),
                    (route) => false);
          },
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {

            },
          ),
        ],
      ),
      drawer: Drawer(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  ExpansionTile(
                    title: Text("Jeu"),
                    // leading: Icon(Icons.games),
                    childrenPadding: EdgeInsets.only(left:60),
                    children: [
                      ListTile(
                        leading: Icon(Icons.cached_outlined),
                        title: Text("Recommencer"),
                        onTap: (){
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const Start()),
                                  (route) => false);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.table_rows_outlined),
                        title: Text("Score"),
                        onTap: (){

                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Fermer'),
                        onTap: (){
                          SystemNavigator.pop();
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text("Options"),
                    // leading: Icon(),
                    childrenPadding: EdgeInsets.only(left:60),
                    children: [
                      ListTile(
                        leading: Icon(Icons.layers_outlined),
                        title: Text('Niveau'),
                        onTap: (){
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.sign_language_outlined),
                        title: Text('Statut'),
                        onTap: (){
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _player('Player 1',score1),
                    Text(message),
                    _player('Player 2',score2)
                  ],
                ),
              ),
              Container(
                child: GridView.count(
                    padding: EdgeInsets.all(30),
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: 7,
                    children: <Widget> [
                      for (int i = 6; i >= 0; i--)
                        Row(
                          children: [
                            _buildCell(i),
                            SizedBox(height: 10,width: 10,),
                          ],
                        ),

                      for (int i = 7; i <= 13; i++)
                        Row(
                          children: [
                            _buildCell(i),
                            SizedBox(height: 10,width: 10,),
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

  void _WinnerSms(String sms){
    showDialog( context: context, builder: (BuildContext context) {
      return AlertDialog( title: Text('Successs !'), content: Text(sms),
        actions: <Widget>[ FloatingActionButton( child: Text('OK'), onPressed: ()  {
          Navigator.of(context).pop();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Start()),
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
      if (currentIndex != index) {
        _board[currentIndex]++;
        pawns--;
        await Future.delayed(const Duration(milliseconds: 300));
      }
      setState(() {

      });

    }

    while(_board[currentIndex] == 2 || _board[currentIndex] == 3){
      setState(() {
        if(statuts == "J2"){
          score1 = score1 +  _board[currentIndex];
        }else {
          score2 = score2 +  _board[currentIndex];
        }
        _board[currentIndex] = 0;
      });
      currentIndex--;
      await Future.delayed(const Duration(milliseconds: 200));
    }

    setState(() {
     if(score1 >= 35 && score2 < 35){
       messageSuccess = "Victoire Joueur 1";
       _WinnerSms(messageSuccess);
     }if(score1 < 35 && score2 >= 35) {
       messageSuccess = "Victoire Joueur 2";
       _WinnerSms(messageSuccess);
     }

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
    });

    setState(() {
      if(35 - (score2 + score1) < 10){
        if((score1 + cpt1) > 35){
          messageSuccess = "Victoire Joueur 1";
          _WinnerSms(messageSuccess);
        }if((score2 + cpt2) > 35){
          messageSuccess = "Victoire Joueur 2";
          _WinnerSms(messageSuccess);
        }
      }
    });

    await Future.delayed(const Duration(milliseconds: 200));
    await _computerDistributePawns();
  }

  Future<void> _computerDistributePawns() async {
    int maxPawns = 0;
    int maxPawnsIndex = 0;
    // Find the cell with the maximum number of pawns for the computer
    for (int i = 7; i < 14; i++) {
      if (_board[i] > maxPawns) {
        maxPawns = _board[i];
        maxPawnsIndex = i;
      }
    }
    // Distribute the pawns for the computer
    int pawns = _board[maxPawnsIndex];
    _board[maxPawnsIndex] = 0;
    int currentIndex = maxPawnsIndex;
    while (pawns > 0) {
      currentIndex = (currentIndex + 1) % 14;
      if (currentIndex != maxPawnsIndex && currentIndex < 7) {
        _board[currentIndex]++;
        pawns--;
        await Future.delayed(const Duration(milliseconds: 300));
      }
      setState(() {});
    }
  }


}





