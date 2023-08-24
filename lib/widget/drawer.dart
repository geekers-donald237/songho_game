import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:songhogame/controller/auth_controller.dart';
import 'package:songhogame/onboarding/Regle.dart';
import 'package:songhogame/views/Start.dart';
import 'customListtitle.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.ontap});
  final VoidCallback ontap;

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
              ontap;
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
            leadingIcon: Icons.logout_rounded,
            title: "Deconnexion",
            onTap: () {
              AuthController().logout(context);
            },
          ),
          CustomListTile(
            leadingIcon: Icons.close_rounded,
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
              onTap: () {
                Future.delayed(Duration(seconds: 1), () {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Regle()),
                    (route) => false,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
