import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:songhogame/modejeu/OnePlayers.dart';
import 'package:songhogame/modejeu/TwoPlayers.dart';

import '../onboarding/Regle.dart';

class Start extends StatelessWidget {

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
              icon: Icon(Icons.info_outline) ,onPressed:() {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Regle()),
                      (route) => false);
            },
            ),
          ],
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
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
                              //screen orientation
                              WidgetsFlutterBinding.ensureInitialized();
                              // Step 3
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeLeft,
                                DeviceOrientation.landscapeRight,
                              ]);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const OnePlayers ()),
                                      (route) => false);
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
                              WidgetsFlutterBinding.ensureInitialized();
                              // Step 3
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeLeft,
                                DeviceOrientation.landscapeRight,
                              ]);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const TwoPlayers ()),
                                      (route) => false);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Get Started"),
            ),
          ),
        ),
      ),
    );
  }
}
