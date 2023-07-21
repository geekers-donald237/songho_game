import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:songhogame/controller/gameController.dart';
import 'package:songhogame/modejeu/OnePlayers.dart';
import 'package:songhogame/modejeu/TwoPlayers.dart';

import '../onboarding/Regle.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final gameController = GameController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose Your Mode"),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Player And Computer"),
                    subtitle: Text("lets Go on computer"),
                    onTap: () {
                      gameController.changeScreenOrientation(
                          context, const OnePlayers());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.online_prediction),
                    title: Text("Online"),
                    subtitle: Text("Play with friends everywhere"),
                  ),
                  ListTile(
                    leading: Icon(Icons.group_add_outlined),
                    title: Text("Two players"),
                    subtitle: Text("Get's Started"),
                    onTap: () {
                      //screen orientation
                      gameController.changeScreenOrientation(
                          context, const TwoPlayers());
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.home),
          title: Text("Bienvenue !"),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
                gameController.changeScreenOrientation(context, const Regle());
              },
            ),
          ],
        ),
      ),
    );
  }
}
