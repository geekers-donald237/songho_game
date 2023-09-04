import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:songhogame/modejeu/OnePlayers.dart';
import 'package:songhogame/modejeu/TwoPlayers.dart';
import 'package:songhogame/views/Start.dart';
import 'package:songhogame/controller/internet.dart';
import 'package:songhogame/controller/gameController.dart';

class MenuJeu extends StatefulWidget {
  @override
  _MenuJeuState createState() => _MenuJeuState();
}

class _MenuJeuState extends State<MenuJeu> {
  final gameController = GameController();
  bool showContainer = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor:
            Color.fromARGB(255, 119, 95, 86), // Couleur de fond de la page
        body: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      'SONGHO',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white60, // Couleur du texte en blanc
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Venez découvrir le jeu Songho, originaire du Centre Cameroun',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70, // Couleur du texte en blanc
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Stack(
                      children: [
                        Container(
                          child: ClipRRect(
                            child: Image.asset(
                              'assets/images/songho_board.png',
                              width: 170,
                              height: 170,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54, width: 4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Joueur vs Ordinateur",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Jouer contre l'ordinateur",
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              gameController.changeScreenOrientation(
                                  context, const OnePlayers());
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.online_prediction_rounded,
                                color: Colors.white),
                            title: Text(
                              "Online",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Jouer à distance",
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () async {
                              EasyLoading.show(status: '');
                              await Future.delayed(Duration(seconds: 2));
                              checkInternetAndOpenPage(context);
                              EasyLoading.dismiss();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.group_add_rounded,
                                color: Colors.white),
                            title: Text(
                              "Deux joueurs",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Jouer contre un ami",
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              gameController.changeScreenOrientation(
                                  context, const TwoPlayers());
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.white30),
                            ),
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Get.to(() => Start());
                          },
                          child: Row(
                            children: [
                              Text(
                                'Annuler',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.close,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.rule_sharp, color: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
