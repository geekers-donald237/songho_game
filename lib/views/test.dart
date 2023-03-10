// import 'dart:core';
// import 'package:flutter/material.dart';
//
//
// class Start extends StatefulWidget {
//   const Start({Key? key}) : super(key: key);
//
//   @override
//   State<Start> createState() => _StartState();
// }
//
// class _StartState extends State<Start> {
//
//   String _selectedItem = '';
//   late List<int> _board;
//   List<String> _jeuOptions = ['Jeu 1', 'Jeu 2', 'Jeu 3'];
//   List<String> _proposOptions = ['A propos 1', 'A propos 2', 'A propos 3'];
//   List<String> _optionsOptions = ['Option 1', 'Option 2', 'Option 3'];
//
//   @override
//   void initState() {
//     super.initState();
//     // initialisation du plateau avec 5 billes par case
//     _board = List<int>.filled(14, 5);
//   }
//
//   int score1 = 0 ;
//   int score2 = 0;
//   String message = "Joueur 1 a vous de commencer";
//   String statuts = "J1";
//   Color? color = Colors.grey[300];
//   int statut_joueur = 1;
//   int gagnant = -1;
//
//
//   void _onTap(int index) {
//     setState(() {
//       if(statuts == "J1"){
//         if(index >= 0 && index <= 6){
//           statut_joueur = 0;
//           showDialog( context: context, builder: (BuildContext context) {
//             return AlertDialog( title: Text('Erreur'),
//               content: Text('Cette case ne vous appartient pas.'),
//               actions: <Widget>[ FloatingActionButton( child: Text('OK'), onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               ),
//               ],
//             );
//           },
//           );
//         }else {
//           _distributePawns(index);
//           message = "Joueur 2 a vous de Jouer !!";
//           statuts = "J2";
//         }
//       } else {
//         statut_joueur = 0;
//         if(index >= 7 && index <= 13){
//           showDialog( context: context, builder: (BuildContext context) {
//             return AlertDialog( title: Text('Erreur'), content: Text('Cette case ne vous appartient pas.'),
//               actions: <Widget>[ FloatingActionButton( child: Text('OK'), onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               ),
//               ],
//             );
//           },
//           );
//         } else {
//           _distributePawns(index);
//           message = "Joueur 1 a vous de Jouer !!";
//           statuts = "J1";
//         }
//       }
//     }
//     );
//   }
//
//
//   Widget _buildCell(int index) {
//     return GestureDetector(
//       onTap: () {
//         _onTap(index);
//       },
//       child: Container(
//         width: 90,
//         height: 90,
//         decoration: BoxDecoration(
//           color:color,
//           shape: BoxShape.circle,
//         ),
//         child: Center(
//           child: Text(
//             '${_board[index]}',
//             style: TextStyle(fontSize: 14),
//           ),
//         ),
//       ),
//     );
//
//   }
//
//
//
//   Widget _player(String nom_player , int score){
//     return Container(
//       width: 110,
//       height: 45,
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.rectangle,
//       ),
//       child: Column(
//         children: [
//           Center(
//             child: Row(
//               children: [
//                 Icon(Icons.people),
//                 Text(' '),
//                 Text(nom_player),
//                 Text('',style: TextStyle(fontSize: 14),),
//               ],
//             ),
//           ),
//           Text('Score : ${score}')
//         ],
//       ),
//     );
//   }
//
//   int _jeu_est_fini() {
//     for (int i = 6; i >= 0; i--){
//       if (_board[i] == 0) {
//         gagnant = 1;
//       }
//     }
//
//     for (int i = 7; i <= 13; i++){
//       if (_board[i] == 0) {
//         gagnant = 2;
//       }
//     }
//     return gagnant;
//   }
//
//   @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(title: Text('Jeu de Songho')),
//   //     body: SingleChildScrollView(
//   //       child: Center(
//   //         child: Column(
//   //           children: [
//   //             SizedBox(height: 5,),
//   //             Padding(
//   //               padding: const EdgeInsets.symmetric(horizontal: 20 ),
//   //               child: Row(
//   //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                 children: [
//   //                   _player('Player 1',score1),
//   //                   Text(message),
//   //                   _player('Player 2',score2)
//   //                 ],
//   //               ),
//   //             ),
//   //             Container(
//   //               child: GridView.count(
//   //                   padding: EdgeInsets.all(30),
//   //                   primary: false,
//   //                   shrinkWrap: true,
//   //                   crossAxisCount: 7,
//   //                   children: <Widget> [
//   //                     for (int i = 6; i >= 0; i--)
//   //                       Row(
//   //                         children: [
//   //                           _buildCell(i),
//   //                           SizedBox(height: 10,width: 10,),
//   //                         ],
//   //                       ),
//   //
//   //
//   //                     for (int i = 7; i <= 13; i++)
//   //                       Row(
//   //                         children: [
//   //                           _buildCell(i),
//   //                           SizedBox(height: 10,width: 10,),
//   //                         ],
//   //                       ),
//   //                   ]
//   //               ),
//   //             ),
//   //             SizedBox(height: 20,),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   //
//   // }
//
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Jeu de Songho')),
//       drawer: Drawer(
//         child: ListView(
//           children: <Widget>[
//             DropdownButton(
//               value: _selectedItem,
//               items: _jeuOptions.map((option) {
//                 return DropdownMenuItem(
//                   value: option,
//                   child: Text(option),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 // Do something
//                 setState(() {
//                   _selectedItem = value!;
//                 });
//               },
//               hint: Text('Jeu'),
//             ),
//             DropdownButton(
//               value: _selectedItem,
//               items: _proposOptions.map((option) {
//                 return DropdownMenuItem(
//                   value: option,
//                   child: Text(option),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 // Do something
//                 setState(() {
//                   _selectedItem = value!;
//                 });
//               },
//               hint: Text('A propos'),
//             ),
//             DropdownButton(
//               value: _selectedItem,
//               items: _optionsOptions.map((option) {
//                 return DropdownMenuItem(
//                   value: option,
//                   child: Text(option),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 // Do something
//                 setState(() {
//                   _selectedItem = value!;
//                 });
//               },
//               hint: Text('Option'),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 5,),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _player('Player 1',score1),
//                     Text(message),
//                     _player('Player 2',score2)
//                   ],
//                 ),
//               ),
//               Container(
//                 child: GridView.count(
//                     padding: EdgeInsets.all(30),
//                     primary: false,
//                     shrinkWrap: true,
//                     crossAxisCount: 7,
//                     children: <Widget> [
//                       for (int i = 6; i >= 0; i--)
//                         Row(
//                           children: [
//                             _buildCell(i),
//                             SizedBox(height: 10,width: 10,),
//                           ],
//                         ),
//
//                       for (int i = 7; i <= 13; i++)
//                         Row(
//                           children: [
//                             _buildCell(i),
//                             SizedBox(height: 10,width: 10,),
//                           ],
//                         ),
//                     ]
//                 ),
//               ),
//               SizedBox(height: 20,),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//   Future<void> _distributePawns(int index) async {
//     int pawns = _board[index];
//     _board[index] = 0;
//     int currentIndex = index;
//     //distribuer les pions dans le sens inverse des aiguilles d'une montre
//     while (pawns > 0) {
//       currentIndex = (currentIndex + 1) % 14;
//       // if (currentIndex != index) {
//       _board[currentIndex]++;
//       pawns--;
//       await Future.delayed(const Duration(milliseconds: 500));
//       _board[currentIndex];
//     }
//     setState(() {});
//
//     while(_board[currentIndex] == 2 || _board[currentIndex] == 3){
//       if(statuts == "J2"){
//         score1 = score1 +  _board[currentIndex];
//       }else {
//         score2 = score2 +  _board[currentIndex];
//       }
//       _board[currentIndex] = 0;
//       currentIndex--;
//     }
//   }
// }
//
//
//
//
//
