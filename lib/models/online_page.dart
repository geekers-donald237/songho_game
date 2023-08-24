import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:songhogame/constants.dart';
import 'package:songhogame/controller/gameController.dart';
import 'package:songhogame/onboarding/hashcode.dart';
import 'package:songhogame/views/menuJeu.dart';
import 'package:songhogame/widget/custom_app_bar.dart';

class OnlinePage extends StatefulWidget {
  OnlinePage({super.key});

  @override
  State<OnlinePage> createState() => _OnlinePageState();
}

class _OnlinePageState extends State<OnlinePage> {
  final gameController = GameController();
  TextEditingController codeController = TextEditingController();
  List<String> username = [];
  bool isEditable = true;
  bool joinEnabled = true;
  bool lancerEnabled = true;
  bool isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 119, 95, 86),
      appBar: CustomAppBar(),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Initier une partie',
                style: TextStyle(
                  color: Color.fromARGB(255, 162, 210, 218),
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  /* setState(() {
                    isEditable = false;
                    joinEnabled = false;
                    hashCode = generateHashCode();
                  }); */
                  isButtonDisabled ? null : () {};
                  ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: isButtonDisabled
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : Colors.grey,
                  );

                  setState(() {
                    hashCode = generateHashCode();
                  });
                  /* saveHashCode(hashCode, user.uid); */
                  /*createAndSaveFirebaseTable(user.uid);
                  retrieveFirebaseTable(user.uid);
                  username = await getUsernameFromFirebase(user.uid);
                  setState(() {
                    usernameP1 = username[0];
                  }); */
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 218, 203, 162),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.white30),
                  ),
                  minimumSize: Size(
                    mediaQuery.width * 0.98,
                    mediaQuery.height * 0.08,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Lancer',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Code de la partie : $hashCode',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 45.0,
                    height: 45.0,
                    child: ElevatedButton(
                      onPressed: () {
                        //share();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.black,
                        shape: CircleBorder(),
                        side: BorderSide(color: Colors.white, width: 1.2),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.share_rounded),
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 1.0,
                height: 20.0,
              ),
              SizedBox(height: 20),
              Text(
                'Rejoindre une partie',
                style: TextStyle(
                  color: Color.fromARGB(255, 162, 210, 218),
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: isEditable,
                      onTap: () {
                        setState(() {
                          isButtonDisabled = false;
                        });
                      },
                      controller: codeController,
                      maxLength:
                          4, // Autorise la saisie de 5 caractères au maximum pour inclure le caractère supérieur
                      onChanged: (value) {
                        if (value.length > 4) {
                          codeController.text = value.substring(
                              0, 4); // Ignorer les caractères excédentaires
                          codeController.selection = TextSelection.fromPosition(
                            TextPosition(
                                offset:
                                    4), // Position du curseur à la fin du texte
                          );
                        }
                        getValueFromTextField; // Appeler la fonction pour obtenir la valeur du champ de texte
                      },
                      // Écoute les changements dans le TextField
                      decoration: InputDecoration(
                        labelText: 'Saisissez votre code ici',
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.white,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white, // Ajoutez cette ligne
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 1.2),
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: joinEnabled
                            ? () async {
                                performFirebaseActions();
                                // Appeler la fonction de recherche
                                setState(() {
                                  lancerEnabled = false;
                                });
                                username =
                                    await getUsernameFromFirebase(user.uid);
                                setState(() {
                                  usernameP2 = username[1];
                                });
                                //executeAfterDelay();
                              }
                            : null,
                        icon: Icon(
                          Icons.check_box,
                          color: Colors.white,
                        ),
                        iconSize: 24.0,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 25),
              /* FloatingActionButton(
                onPressed: () async {
                  //print(usernameP2);

                  //getEmailUsernameFromFirestore();
                  // Action à effectuer lorsque le bouton du modal est pressé
                  // Ajoutez votre logique ici
                },
                child: Icon(Icons.start_sharp),
              ), */
              buildUserInfoCard(usernameP2),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.white30),
                      ),
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Get.to(() => MenuJeu());
                    },
                    child: Row(
                      children: [
                        Text(
                          'Annuler',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.close,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var user = FirebaseAuth.instance.currentUser!;
String usernameP1 = '';
String usernameP2 = '';

bool online = false;

String hashCode = '';

String inputValue = '';

// Fonction pour récupérer la valeur saisie dans le TextField
String getValueFromTextField(String value) {
  inputValue = value;
  //print(inputValue);

  return inputValue;
}

void onPressedButton() async {
  final inputHashCode = getValueFromTextField(
      inputValue); // Récupère la valeur saisie dans le TextField
  final result = await saveUidIfHashCodeExists(
      inputHashCode, user.uid); // Vérifie si le hashCode existe dans Firebase

  if (result != null) {
    print('Le hashCode existe dans Firebase et l\'UID a été enregistré.');
    // Effectuez ici les actions à réaliser lorsque le hashCode existe et que l'UID a été enregistré
  } else {
    print('Le hashCode n\'existe pas dans Firebase.');
    // Effectuez ici les actions à réaliser lorsque le hashCode n'existe pas
  }
}

void performFirebaseActions() async {
  // Afficher l'indicateur de chargement
  EasyLoading.show(status: 'Recherche en cours...');

  try {
    //saveUidIfHashCodeExists(inputValue, user.uid);
/*     getUsernameFromFirebase(user.uid);
    saveUsernameIfHashCodeExists(hashCode, user.uid); */
    //saveUsernameIfHashCodeExists(inputValue, user.uid);
    // Simuler une pause pour représenter le temps d'exécution de la recherche
    await Future.delayed(Duration(seconds: 4));

    // Afficher un message de succès
    EasyLoading.showSuccess('Reussie');
  } catch (e) {
    // Afficher un message d'erreur en cas d'échec
    EasyLoading.showError('Code absent');
  }

  // Masquer l'indicateur de chargement une fois la recherche terminée
  EasyLoading.dismiss();
}

// CARD FOR PLAYERS INFOS
Card buildUserInfoCard(String useName) {
  return Card(
    child: ListTile(
      title: Text(
        ': $useName',
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Icon(
        Icons.person_add_alt_1_rounded,
        size: 25,
        color: Colors.black,
      ),
    ),
    color: Colors.white,
  );
}

Future<List<String>> getUsernameFromFirebase(String uid) async {
  // Récupérer la référence de la collection "players" dans Firebase
  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('players');

  // Récupérer le document correspondant à l'utilisateur donné
  DocumentSnapshot document = await playersCollection.doc(uid).get();

  // Initialiser une liste pour stocker les noms d'utilisateur
  List<String> usernames = [];

  // Vérifier si le document existe
  if (document.exists) {
    // Récupérer les données du document
    Map<String, dynamic> userData = document.data() as Map<String, dynamic>;

    // Récupérer le nom d'utilisateur P2 et l'ajouter à la liste
    if (userData.containsKey('usernameP1')) {
      String usernameP1 = userData['usernameP1'];
      usernames.add(usernameP1);
    }

    // Récupérer le nom d'utilisateur P1 et l'ajouter à la liste
    if (userData.containsKey('usernameP1')) {
      String usernameP2 = userData['usernameP1'];
      usernames.add(usernameP2);
    }

    // Retourner la liste de noms d'utilisateur
    return usernames;
  } else {
    // Retourner une liste vide si l'utilisateur n'existe pas
    return usernames;
  }
}
