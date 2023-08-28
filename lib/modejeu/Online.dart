import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:songhogame/constants.dart';
import 'package:songhogame/controller/gameController.dart';
import 'package:songhogame/models/dataOnline.dart';
import 'package:songhogame/models/online_page.dart';
import 'package:songhogame/widget/custom_app_bar.dart';
import 'package:songhogame/widget/drawer.dart';
import 'package:songhogame/widget/player1.dart';
import 'package:songhogame/widget/player2.dart';

class Online extends StatefulWidget {
  const Online({Key? key}) : super(key: key);

  @override
  _OnlineState createState() => _OnlineState();
}

class _OnlineState extends State<Online> {
  late List<int> _board;
  late List<Color> _colorList;

  @override
  void initState() {
    super.initState();
    retrieveFirebaseTable(user.uid); // Remplacez 'playerID' par l'ID approprié

    // initialisation du plateau avec 5 billes par case
    _board = data;
    _colorList = colorList;
  }

  int score1 = 0;
  int score2 = 0;
  String message = "$u à vous de commencer";
  String statuts = u;
  int statut_joueur = 1;
  int gagnant = -1;
  String winner = "";
  String messageSuccess = "";
  int cpt1 = 0, cpt2 = 0;
  bool _jeuEstEnCours = false;
  final gameController = GameController();
  final int numOfStones = 4; // Nombre de pierres dans chaque trou
  final double stoneSize = 20.0; // Taille des pierres

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 119, 95, 86),
      appBar: AppBar(
        title: Text(
          "Online",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: CustomDrawer(
        ontap: () {
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
              MaterialPageRoute(builder: (context) => Online()),
              (route) => false,
            );
          });
        },
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
                    Player1(
                      score: score1,
                      icon: Icons.person_rounded,
                      playerName: u,
                    ),
                    Container(
                      padding: EdgeInsets.all(8), // Espacement interne du cadre
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                            255, 218, 203, 162), // Couleur du cadre
                      ),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Player2(
                      score: score2,
                      icon: Icons.person_rounded,
                      playerName: "J2",
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
                          buildCell(i, Colors.amber!),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      setState(
        () {
          if (_jeuEstEnCours == false) {
            if (statuts == u) {
              if (index >= 0 && index <= 6) {
                statut_joueur = 0;
                gameController.showSnackBar(
                    context, "Cette case ne vous appartient pas.");
              } else {
                if (_board[index] != 0) {
                  _updateDataOnFirestore();
                  _distributePawns(index);
                  setState(() {
                    backgroundColor;
                    message = "Patientez J2.....";
                    statuts = "J2";
                  });
                } else {
                  gameController.showSnackBar(
                      context, "Sélectionnez une case contenant des pions");
                }
              }
            } else {
              statut_joueur = 0;
              if (index >= 7 && index <= 13) {
                gameController.showSnackBar(
                    context, "Cette case ne vous appartient pas.");
              } else {
                if (_board[index] != 0) {
                  _updateDataOnFirestore();
                  _distributePawns(index);
                  setState(() {
                    message = "Patientez $u...";
                    statuts = u;
                  });
                } else {
                  gameController.showSnackBar(
                      context, "Sélectionnez une case contenant des pions");
                }
              }
            }
            _updateCellOnFirestore(data);
          } else {
            gameController.showSnackBar(
              context,
              "Veuillez patienter....",
            );
          }
        },
      );
    }
  }

  List<int> data = List<int>.filled(14, 5);

  void _updateCellOnFirestore(List<int> data) {
    FirebaseFirestore.instance
        .collection('players')
        .doc(user.uid)
        .collection('onlinepart')
        .doc(user.uid)
        .set({'tableData': data}, SetOptions(merge: true));
  }

  void _updateDataOnFirestore() {
    FirebaseFirestore.instance
        .collection('players')
        .doc(user.uid)
        .collection('onlinepart')
        .doc(user.uid)
        .update({
      'message': message,
      'statuts': statuts,
      'statut_joueur': statut_joueur,
    });
  }

  /* void _onTapCell(int index) {
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
          if (statuts == u) {
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
                    context, "Selectionner une case contenant des pions");
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
                  message = "Patientez $u...";
                  statuts = u;
                });
              } else {
                gameController.showSnackBar(
                    context, "Selectionner une case contenant des pions");
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
  } */

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
        if (statuts == u) {
          _updateDataOnFirestore();
          message = "$u à vous de Jouer";
          _updateDataOnFirestore();
        } else {
          message = "J2 à vous de Jouer";
          _updateDataOnFirestore();
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
        } else if (statuts == u && currentIndex >= 7 && currentIndex <= 13) {
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
      if (statuts == u) {
        message = "$u à vous de Jouer";
        _updateDataOnFirestore();
      } else {
        message = "J2 vous de Jouer";
        _updateDataOnFirestore();
      }
    });

    //verif pour le score deja
    setState(() {
      if (score1 > 35 && score2 <= 35) {
        messageSuccess = "Victoire $u";
        gameController.WinnerSms(messageSuccess, context);
        _resetScores();
      }
      if (score1 <= 35 && score2 > 35) {
        messageSuccess = "Victoire J2";
        gameController.WinnerSms(messageSuccess, context);
        _resetScores();
      }
    });

    //Vicoire en fonction du nombre de pierres de son cote
    setState(
      () {
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
            messageSuccess = "Victoire $u";
            gameController.WinnerSms(messageSuccess, context);
            _resetScores();
          } else if ((score2 + cpt2) > 35) {
            messageSuccess = "Victoire J2";
            gameController.WinnerSms(messageSuccess, context);
            _resetScores();
          }
        }

        if (cpt1 == 0 && cpt2 != 0) {
          messageSuccess = "Victoire J2";
          gameController.WinnerSms(messageSuccess, context);
          _resetScores();
        }
        if (cpt1 != 0 && cpt2 == 0) {
          messageSuccess = "Victoire $u";
          gameController.WinnerSms(messageSuccess, context);
          _resetScores();
        }
      },
    );
    _updateFirestoreData();
  }

// Sauvegarder les scores sur firebase
  void _updateFirestoreData() {
    FirebaseFirestore.instance
        .collection('players')
        .doc(user.uid)
        .collection('onlinepart')
        .doc(user.uid)
        .update({
      'score1': score1,
      'score2': score2,
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

/* Future<String> fetchUsernameP1() async {
  String usernameP1 = '';

  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('players')
        .doc(user.uid) // Remplacez 'userID' par l'identifiant de l'utilisateur dont vous souhaitez récupérer le usernameP1
        .get();

    if (snapshot.exists) {
      usernameP1 = snapshot.data()!['usernameP1']
    } else {
      usernameP1 = 'Utilisateur non trouvé';
    }
  } catch (e) {
    usernameP1 = 'Erreur de récupération';
  }

  return usernameP1;
} */

  Future<void> retrieveFirebaseTable(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference playersCollectionRef = firestore.collection('players');
    DocumentReference documentRef = playersCollectionRef.doc(uid);
    CollectionReference onlinePartCollectionRef =
        documentRef.collection('onlinepart');

    try {
      DocumentSnapshot docSnapshot =
          await onlinePartCollectionRef.doc(uid).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        List<int> tableData =
            List<int>.from(data['tableData'] as List<dynamic>);
        List<String> colorList =
            List<String>.from(data['colorList'] as List<dynamic>);
        List<Color> colors =
            colorList.map((hex) => Color(int.parse(hex, radix: 16))).toList();

        setState(() {
          _board = tableData;
          _colorList = colors;
        });
      } else {
        if (kDebugMode) {
          print("Le document n'existe pas.");
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("Erreur : $error");
      }
    }
  }

// remet les scores à zero lorsque la partie de jeu est terminée
  void _resetScores() {
    FirebaseFirestore.instance
        .collection('players')
        .doc(user.uid)
        .collection('onlinepart')
        .doc(user.uid)
        .update({
      'score1': 0,
      'score2': 0,
    });
  }
}
