import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:songhogame/modejeu/TwoPlayers.dart';

class Regle extends StatefulWidget {
  const Regle({Key? key}) : super(key: key);

  @override
  State<Regle> createState() => _RegleState();
}


class _RegleState extends State<Regle> {
  @override
  void initState(){
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // Set the app to only allow portrait orientation
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Principe du Jeu'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const TwoPlayers()),
                    (route) => false);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Le but du jeu Le but du jeu est de s'emparer d'un maximum de graines. Le joueur qui a le plus de graines à la fin de la partie l'emporte.",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10),
                Text(
                  "La distribution est l'operation qui consiste a prendre la totalites des billes presentes dans un trou de son camp et a les disposer une " +
            "a une dans les cases qui le suivent dans l'ordre inverse des aiguilles d'une montre.(on peut donc distrubuer aussi dans les cases de "
               + " son adversaire).",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10),
                Text(
                  "Une prise est l'operation qui consiste a ramasser la totalite des graines d'un trou dans le camp de l'adversaire car les prises "
                  + " se font uniquement  chez son adversaire.",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10),
                Text(
                  "si la derniere graine distibue tombe dans un trou de l'adversaire comportant 2 ou 3 graines (avec la distibution effectue) ,le "
                   + " joueur captures les 2 ou 3 graines resultantes.",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10),
                Text(
                  "Capture multiple Lorsqu'un joueur s'empare de deux ou trois graines, si la case précédente contient également deux ou trois "
                    + " graines, elle sont capturées aussi, et ainsi de suite.",
                    style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10),
                Text("Bouclage Si le nombre de graines prises dans le trou de départ est supérieur à 11, cela fait que l'on va boucler un tour : auquel cas,"
               + " à chaque passage, la case de départ est sautée et donc toujours laissée vide. Un trou contenant assez de graines pour faire une "
                + " boucle complète s'appelle un Krou.	",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10),
                Text("Donner à manger On n'a pas le droit d'affamer l'adversaire : De même, un joueur n'a pas le droit de jouer un coup qui prenne toutes "
                    + " les graines du camp de l'adversaire.		",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10),
                Text("Bouclage Si le nombre de graines prises dans le trou de départ est supérieur à 11, cela fait que l'on va boucler un tour : auquel cas, "
                    + " à chaque passage, la case de départ est sautée et donc toujours laissée vide. Un trou contenant assez de graines pour faire une "
                    + " boucle complète s'appelle un Krou.	",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10),
                Text("Si le nombre de pierre pris par l’un des joueurs est supérieur à 35, il gagne;",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10),
                Text(" Si le nombre de pierre des deux  joueurs, en excluant les prises, est inférieuré à 10, le gagnant est celui qui a la somme des ses prises et du nombre des pierres de son côté, supérieur à 35.",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

