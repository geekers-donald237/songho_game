import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:songhogame/views/login_screen.dart';
import 'package:songhogame/views/menuJeu.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  bool adVisible = false;

  @override
  void initState() {
    super.initState();
    // Montre la publicité après 5 secondes
    Future.delayed(Duration(seconds: 6), () {
      setState(() {
        adVisible = true; // Affiche la publicité
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 119, 95, 86),
        body: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 120),
                    Text(
                      'SONGHO',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white60,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Venez découvrir le jeu Songho, originaire du Centre Cameroun',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
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
                            alignment: Alignment.center,
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
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
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
                            alignment: Alignment.center,
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
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.private_connectivity_rounded,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3),
                    if (adVisible)
                      Container(
                        child: AdmobBanner(
                          adUnitId: "ca-app-pub-3940256099942544/6300978111",
                          adSize: AdmobBannerSize.BANNER,
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
