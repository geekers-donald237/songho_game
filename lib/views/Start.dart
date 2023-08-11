import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:songhogame/controller/gameController.dart';
import 'package:songhogame/controller/internet.dart';
import 'package:songhogame/modejeu/OnePlayers.dart';
import 'package:songhogame/modejeu/TwoPlayers.dart';
import 'package:songhogame/onboarding/Regle.dart';
import 'package:songhogame/views/login_screen.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final gameController = GameController();
  bool showContainer = false;

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
                        minimumSize: Size(double.infinity,
                            25), // Augmente la longueur du bouton
                      ),
                      onPressed: () {
                        setState(() {
                          showContainer = true;
                        });
                      },
                      child: Text(
                        'Jouer',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
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
                        minimumSize: Size(double.infinity,
                            25), // Augmente la longueur du bouton
                      ),
                      onPressed: () {
                        //Get.to(() => LogInScreen());
                        Colors.black;
                      },
                      child: Text(
                        'Connexion',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (showContainer) ...[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.person, color: Colors.white),
                              title: Text(
                                "Player And Computer",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "lets Go on computer",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                gameController.changeScreenOrientation(
                                    context, const OnePlayers());
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.online_prediction,
                                  color: Colors.white),
                              title: Text(
                                "Online",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "Play with any friends",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                checkInternetAndOpenModal(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.group_add_outlined,
                                  color: Colors.white),
                              title: Text(
                                "Two players",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "Get's Started",
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
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        /* floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellowAccent,
          foregroundColor: Colors.black,
          child: Icon(Icons.info_outline),
          onPressed: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            gameController.changeScreenOrientation(context, const Regle());
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop, */
      ),
    );
  }

  void initialize() async {
    /// here we will add a wait second to move on next screen
    await Future.delayed(Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }
}
