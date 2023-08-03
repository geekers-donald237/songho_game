import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:songhogame/views/Start.dart';
import 'package:songhogame/widget/buildText.dart';

class Regle extends StatefulWidget {
  const Regle({Key? key}) : super(key: key);

  @override
  State<Regle> createState() => _RegleState();
}

class _RegleState extends State<Regle> {
  final ScrollController _scrollController = ScrollController();
  bool _isButtonVisible = false;
  late SharedPreferences _prefs;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _scrollController.addListener(_scrollListener);
  }

  void _loadPrefs() async {
  _prefs = await SharedPreferences.getInstance();
  _prefs.setBool('isLooked', true);
}

  void _navigateToStart(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Start()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Principe du Jeu'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _navigateToStart(context),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildText(
                    text:
                        "Le but du jeu est de s'emparer d'un maximum de graines. Le joueur qui a le plus de graines à la fin de la partie l'emporte."),
                SizedBox(
                  height: 10,
                ),
                BuildText(
                    text:
                        "La distribution est l'opération qui consiste à prendre la totalité des billes présentes dans un trou de son camp et à les disposer une à une dans les cases qui le suivent dans l'ordre inverse des aiguilles d'une montre. (On peut donc distribuer aussi dans les cases de son adversaire)."),
                SizedBox(
                  height: 10,
                ),
                BuildText(
                    text:
                        "Une prise est l'opération qui consiste à ramasser la totalité des graines d'un trou dans le camp de l'adversaire car les prises se font uniquement chez son adversaire."),
                SizedBox(
                  height: 10,
                ),
                BuildText(
                    text:
                        "Si la dernière graine distribuée tombe dans un trou de l'adversaire comportant 2 ou 3 graines (avec la distribution effectuée), le joueur capture les 2 ou 3 graines résultantes."),
                SizedBox(
                  height: 10,
                ),
                BuildText(
                    text:
                        "Capture multiple : lorsqu'un joueur s'empare de deux ou trois graines, si la case précédente contient également deux ou trois graines, elles sont capturées aussi, et ainsi de suite."),
                SizedBox(
                  height: 10,
                ),
                BuildText(
                    text:
                        "Bouclage : si le nombre de graines prises dans le trou de départ est supérieur à 11, cela fait que l'on va boucler un tour : à chaque passage, la case de départ est sautée et donc toujours laissée vide. Un trou contenant assez de graines pour faire une boucle complète s'appelle un Krou."),
                SizedBox(
                  height: 10,
                ),
                BuildText(
                    text:
                        "Donner à manger : on n'a pas le droit d'affamer l'adversaire. De même, un joueur n'a pas le droit de jouer un coup qui prenne toutes les graines du camp de l'adversaire."),
                SizedBox(
                  height: 10,
                ),
                BuildText(
                    text:
                        "Si le nombre de pierres pris par l'un des joueurs est supérieur à 35, il gagne."),
                SizedBox(
                  height: 10,
                ),
                BuildText(
                    text:
                        "Si le nombre de pierres des deux joueurs, en excluant les prises, est inférieur à 10, le gagnant est celui qui a la somme de ses prises et du nombre de pierres de son côté, supérieure à 35."),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _isButtonVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Start() ),
                  (route) => false,
                );
          },
          child: Icon(Icons.arrow_forward_rounded),
        ),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isButtonVisible = true;
      });
    } else {
      setState(() {
        _isButtonVisible = false;
      });
    }
  }
}
