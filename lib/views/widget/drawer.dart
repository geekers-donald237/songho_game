import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../modejeu/OnePlayers.dart';
import '../Start.dart';
import 'customListtitle.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100,
            child: DrawerHeader(
              child: Center(
                child: Text(
                  'Songho',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ),
          CustomListTile(
            leadingIcon: Icons.cached_outlined,
            title: "Recommencer",
            onTap: () {
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
                  MaterialPageRoute(builder: (context) => const OnePlayers()),
                  (route) => false,
                );
              });
            },
          ),
          CustomListTile(
            leadingIcon: Icons.home,
            title: "Accueil",
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
              Future.delayed(Duration(seconds: 1), () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Start()),
                  (route) => false,
                );
              });
            },
          ),
          const Divider(),
          CustomListTile(
            leadingIcon: Icons.exit_to_app,
            title: "Fermer",
            onTap: () {
              SystemNavigator.pop();
            },
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('À propos de notre jeu de Songho'),
            ),
          ),
        ],
      ),
    );
  }
}
