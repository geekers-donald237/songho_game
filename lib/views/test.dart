// import 'package:flutter/cupertino.dart';
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
//   List<List<int>> board = [
//     [5, 5, 5, 5, 5, 5, 5],
//     [5, 5, 5, 5, 5, 5, 5],
//   ];
//
//   List<int> playerOnePits = List<int>.generate(7, (index) => 5);
//   List<int> playerTwoPits = List<int>.generate(7, (index) => 5);
//
//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Jeu de Songho'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text('Joueur 1'),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(7, (index) => const Hole()),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(7, (index) => const Hole()),
//           ),
//           const Text('Joueur 2'),
//         ],
//       ),
//     );
//   }
//
// }
//
// class Hole extends StatelessWidget {
//   const Hole({Key? key}) : super(key: key);
//   List<int> pits ;
//   int index;
//
//   @override
//   Widget build(BuildContext context){
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Container(
//         width: 70,
//         height: 70,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(),
//         ),
//         child: Text(
//           '${pits[index]}',
//         ),
//       ),
//     );
//   }
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       title: Text('Jeu du songho'),
//   //     ),
//   //     body: Padding(
//   //       padding: const EdgeInsets.all(30.0),
//   //       child: Center(
//   //         child: GridView.builder(
//   //           itemCount: 14,
//   //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//   //             crossAxisCount: 7,
//   //           ),
//   //           itemBuilder: (context, index) {
//   //             int playerOneIndex = index - 7;
//   //             // print(playerOneIndex);
//   //             if (index < 7) {
//   //               return _buildPit(playerTwoPits, index);
//   //             } else if (index > 6) {
//   //               return _buildPit(playerOnePits, playerOneIndex);
//   //             } else {
//   //               return Container();
//   //             }
//   //           },
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   // Widget _buildPit(List<int> pits, int index) {
//   //   return GestureDetector(
//   //     onTap: () {
//   //       // print(pits);
//   //       // print(index);
//   //       setState(() {
//   //         distribution(pits,index);
//   //       });
//   //     },
//   //     child: Padding(
//   //       padding: const EdgeInsets.all(2.0),
//   //       child: Container(
//   //         width: 50,
//   //         height: 50,
//   //         decoration: BoxDecoration(
//   //           shape: BoxShape.circle,
//   //           border: Border.all(),
//   //         ),
//   //         child: Center(
//   //           child: Text(
//   //             '${pits[index]}',
//   //             textAlign: TextAlign.center,
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  List<List<int>> board = [
    [5, 5, 5, 5, 5, 5, 5],
    [5, 5, 5, 5, 5, 5, 5],
  ];


  List<int> playerOnePits = List<int>.generate(14, (index) => 5);
  List<int> playerTwoPits = List<int>.generate(7, (index) => 5);

  void _onGridItemTap(int index) {
    int value = playerOnePits[index];
    playerOnePits[index] = 0;
    for (int i = index + 1; i <= index + value; i++) {
      int j = i % playerOnePits.length;
      playerOnePits[j]++;

      print(j);
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu du songho'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: GridView.builder(
            itemCount: playerOnePits.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    print(index);
                    if(playerOnePits[index] > 0){
                      _onGridItemTap(index);
                    }
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(),
                  ),
                  child: Center(
                    child: Text(
                      playerOnePits[index].toString(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPit(List<int> pits, int index) {
    return GestureDetector(
      onTap: () {
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(),
          ),
          child: Center(
            child: Text(
              '${pits[index]}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

