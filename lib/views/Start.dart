import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:songhogame/onboarding/Regle.dart';
import 'package:songhogame/views/login_screen.dart';
import 'package:songhogame/views/menuJeu.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  bool adVisible = false;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Montre la publicité après 5 secondes
    Future.delayed(Duration(seconds: 6), () {
      setState(() {
        adVisible = true; // Affiche la publicité
      });
    });
  }

  void toggleSound() {
    // Mettez ici votre logique pour activer/désactiver le son
    setState(() {
      isMuted = !isMuted;
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
                    SizedBox(height: 90),
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
                          adUnitId: "ca-app-pub-5829950338127826/9635098933",
                          adSize: AdmobBannerSize.BANNER,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
          // Le FAB principal
          visible: true,
          closeManually: true,
          overlayOpacity: 0.5,
          curve: Curves.bounceIn,
          activeIcon: Icons.close,
          overlayColor: Colors.black,
          icon: Icons.settings_rounded,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8.0,
          children: [
            SpeedDialChild(
              child: Icon(
                isMuted ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              onTap: () {
                toggleSound();
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.rule_rounded,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Regle()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        
      ),
    );
  }
}
