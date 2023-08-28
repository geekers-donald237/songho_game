import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:songhogame/controller/gameController.dart';
import 'package:songhogame/modejeu/Online.dart';
import 'package:songhogame/models/dataOnline.dart';
import 'package:songhogame/onboarding/hashcode.dart';
import 'package:songhogame/views/menuJeu.dart';
import 'package:songhogame/widget/custom_app_bar.dart';

class OnlinePage extends StatefulWidget {
  OnlinePage({super.key});

  @override
  State<OnlinePage> createState() => _OnlinePageState();
}

String hashCode = '';
String userIdP1 = '';
String userIdP2 = '';
String usernameP1 = '';
String usernameP2 = '';
var user = FirebaseAuth.instance.currentUser!;
final gameController = GameController();
TextEditingController codeController = TextEditingController();

class _OnlinePageState extends State<OnlinePage> {
  List<String> username = [];
  bool isEditable = true;
  bool joinEnabled = true;
  bool lancerEnabled = true;
  bool isButtonDisabled = false;
  bool online = false;
  String inputValue = '';

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
              SizedBox(height: 10),
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
                  setState(() {
                    isEditable = false;
                    joinEnabled = false;
                    hashCode = generateHashCode();
                    saveHashCode(hashCode, user.uid);
                    createAndSaveFirebaseTable(user.uid);
                  });
                  isButtonDisabled ? null : () {};
                  ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: isButtonDisabled
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : Colors.grey,
                  );

                  /* setState(() {
                    hashCode = generateHashCode();
                  });
                   saveHashCode(hashCode, user.uid); */
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
                          lancerEnabled = false;
                        });
                      },
                      controller: codeController,
                      maxLength:
                          4, // Autorise la saisie de 4 caractères au maximum pour inclure le caractère supérieur
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
                        getValueFromTextField(
                            value); // Appeler la fonction pour obtenir la valeur du champ de texte
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
                        onPressed: () async {
                          onPressedButton(); // Appel de la fonction de recherche
                        },
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
              SizedBox(height: 20),
              // Informations du joueur 2
              buildUserInfoRow(usernameP2),
              SizedBox(
                height: 40,
              ),
              FloatingActionButton(
                onPressed: () {
                  findPlayersAndExecute();
                },
                child: Icon(Icons.play_arrow),
                backgroundColor: Colors.white,
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

  // Fonction pour récupérer la valeur saisie dans le TextField
  String getValueFromTextField(String value) {
    inputValue = value;
    // print(inputValue);

    return inputValue;
  }

  void onPressedButton() async {
    final inputHashCode = getValueFromTextField(
        inputValue); // Récupère la valeur saisie dans le TextFiel
    final result = await saveUidIfHashCodeExists(
        inputHashCode, user.uid); // Vérifie si le hashCode existe dans Firebase
    //EasyLoading.showSuccess('Reussie');
/*     if (result != null) {
      //print('Le hashCode existe dans Firebase et l\'UID a été enregistré.');
      //EasyLoading.showSuccess('Reussie');
      // Effectuez ici les actions à réaliser lorsque le hashCode existe et que l'UID a été enregistré
    } else {
      // print('Le hashCode n\'existe pas dans Firebase.');
      // EasyLoading.showError('Code absent');
      EasyLoading.dismiss();
    } */
  }

// CARD FOR PLAYERS INFOS
  Row buildUserInfoRow(String useName) {
    return Row(
      children: [
        SizedBox(
          width: 65,
        ),
        Expanded(
          child: Card(
            color: Color.fromARGB(255, 102, 102, 102),
            child: Column(
              children: [
                Stack(
                  children: [
                    ListTile(
                      title: Text(
                        useName.isNotEmpty ? useName : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedOpacity(
                              opacity: useName.isNotEmpty ? 0.0 : 0.6,
                              duration: Duration(milliseconds: 200),
                              child: Icon(
                                Icons.add,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: useName.isNotEmpty ? 0.0 : 0.6,
                              duration: Duration(milliseconds: 200),
                              child: Text(
                                'Nouveau joueur',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 65,
        ),
      ],
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

  void findPlayersAndExecute() {
    FirebaseFirestore.instance
        .collection("players")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (DocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey("uid")) {
          userIdP1 = data["uid"];
        }
        if (data.containsKey("hashCode")) {
          hashCode = data["hashCode"];
        }
        if (data.containsKey("userIdP2")) {
          userIdP2 = data["userIdP2"];
        }

        if (userIdP1 != null && hashCode != null && userIdP2 != null) {
          gameController.changeScreenOrientation(context, Online());
          return;
        } else {
          EasyLoading.showInfo('Configuration incorrecte !');
        }
      }
    });
  }

  Future<String> saveUidIfHashCodeExists(String hashCode, String uid) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('players')
        .where('hashCode', isEqualTo: hashCode)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          snapshot.docs.first;
      final String documentId = documentSnapshot.id;

      await FirebaseFirestore.instance
          .collection('players')
          .doc(documentId)
          .set({
        'userIdP2': uid,
      }, SetOptions(merge: true)); // Ajoute l'uid au document existant
      username = await getUsernameFromFirebase(user.uid);
      setState(() {
        usernameP2 = username[1];
      });
      EasyLoading.showInfo('Code trouvé');
    } else {
      // Le hashCode n'existe pas dans la base de données
      EasyLoading.showInfo('Le Code $hashCode n\'existe pas');
    }

    return uid;
  }
}
