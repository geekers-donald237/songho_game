import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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

  void _onTap(int index) {
    setState(() {
      _distributePawns(index);
    });
  }


  void _distributePawns(int index) {
    int pawns = _board[index];
    _board[index] = 0;
    int currentIndex = index;

    // distribuer les pions dans le sens inverse des aiguilles d'une montre
    while (pawns > 0) {
      currentIndex = (currentIndex + 1) % 14;
      if (currentIndex != index) {
        _board[currentIndex]++;
        pawns--;
      }
    }
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
          color: Colors.grey[300],
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

  String score1 = '0' ;
  String score2 = '0';

  Widget _player(String nom_player , String score){
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
                Text(
                  nom_player
                ),
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
    return Scaffold(
      appBar: AppBar(title: Text('Jeu de Songho')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 5,),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _player('player 1',score1),
                    Text('hghjgh'),
                    _player('Player 2',score2)
                  ],
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );

  }
}

