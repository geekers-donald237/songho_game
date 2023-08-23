import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:songhogame/views/login_screen.dart';
import 'package:songhogame/controller/gameController.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:songhogame/views/menuJeu.dart';
import 'package:admob_flutter/admob_flutter.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final gameController = GameController();

  bool adVisible = false;

  @override
  void initState() {
    super.initState();
    // Affiche la publicité au début
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        adVisible = true;
      });
    });

    // Masque la publicité après 3 secondes
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        adVisible = false;
      });
    });

    // Affiche la publicité à nouveau après 8 secondes
    Future.delayed(Duration(seconds: 11), () {
      setState(() {
        adVisible = true;
      });
    });
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
                        backgroundColor: Color.fromARGB(255, 218, 203, 162),
                        elevation: 5,
                        padding: EdgeInsets.all(15),
                        minimumSize: Size(double.infinity, 25),
                      ),
                      onPressed: () async {
                        EasyLoading.show(status: '');
                        await Future.delayed(Duration(seconds: 2));

                        Get.to(() => MenuJeu());

                        EasyLoading.dismiss();
                      },
                      child: Stack(
                        children: [
                          Align(
                            alignment:
                                Alignment.center, // Centre le texte "Jouer"
                            child: Text(
                              'Jouer',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment
                                .centerRight, // Place l'icône à la fin du bouton
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
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
                        backgroundColor: Colors.black,
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
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment
                                .centerRight, // Place l'icône à la fin du bouton
                            child: Icon(
                              Icons.private_connectivity_rounded,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),

                          /* _isAdLoaded
                              ? Container(
                                  height: _bannerAd.size.height.toDouble(),
                                  width: _bannerAd.size.width.toDouble(),
                                  child: AdWidget(ad: _bannerAd),
                                )
                              : SizedBox(), */
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      child: FutureBuilder(
                        // Utilisez `adVisible` pour afficher ou masquer la publicité
                        future: Future.delayed(Duration(seconds: 8)),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            if (snapshot.hasError) {
                              return Text('Erreur de chargement');
                            } else {
                              return adVisible
                                  ? AdmobBanner(
                                      adUnitId:
                                          "ca-app-pub-3940256099942544/6300978111",
                                      adSize: AdmobBannerSize.BANNER,
                                    )
                                  : Container();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.white, // Couleur de fond du bouton
          mini: true,
          child: Icon(
            Icons.settings,
            color: Colors.black,
          ), // Icône "paramètres"
        ),
      ),
    );
  }

  void initialize() async {
    /// here we will add a wait second to move on next screen
    await Future.delayed(Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }
}
