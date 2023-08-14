import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:songhogame/views/login_screen.dart';
import 'package:songhogame/controller/gameController.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:songhogame/views/menuJeu.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final gameController = GameController();

  @override
  void initState() {
    super.initState();
    initialize();
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
                        height: 120,
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
                                width: 200,
                                height: 200,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.white30),
                          ),
                          backgroundColor: Color.fromARGB(255, 140, 143, 2),
                          elevation: 5,
                          padding: EdgeInsets.all(15),
                          minimumSize: Size(double.infinity, 25),
                        ),
                        onPressed: () {
                          Get.to(() => MenuJeu());
                        },
                        child: Stack(
                          children: [
                            Align(
                              alignment:
                                  Alignment.center, // Centre le texte "Jouer"
                              child: Text(
                                'Jouer',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment
                                  .centerRight, // Place l'icône à la fin du bouton
                              child: Icon(
                                Icons.play_circle_outline_rounded,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.white30),
                          ),
                          backgroundColor: Color.fromARGB(255, 140, 143, 2),
                          elevation: 5,
                          padding: EdgeInsets.all(15),
                          minimumSize: Size(double.infinity, 25),
                        ),
                        onPressed: () {
                          Get.to(() => LogInScreen());
                        },
                        child: Stack(
                          children: [
                            Align(
                              alignment:
                                  Alignment.center, // Centre le texte "Jouer"
                              child: Text(
                                'Connexion',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment
                                  .centerRight, // Place l'icône à la fin du bouton
                              child: Icon(
                                Icons.question_mark,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Ajoutez ici le code à exécuter lorsque le bouton est cliqué
            },
            backgroundColor: Colors.white, // Couleur de fond du bouton
            mini: true,
            child: Icon(
              Icons.settings,
              color: Colors.black,
            ), // Icône "paramètres"
          )),
    );
  }

  void initialize() async {
    /// here we will add a wait second to move on next screen
    await Future.delayed(Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }
}
