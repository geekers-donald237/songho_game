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
              Ink(
                decoration: ShapeDecoration(
                  color: Color.fromARGB(255, 218, 203, 162),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.white30,
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isEditable = false;
                      joinEnabled = false;
                      hashCode = generateHashCode();
                      saveHashCode(hashCode, user.uid);
                      createAndSaveFirebaseTable(user.uid);
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Générer le code',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.code_rounded,
                          color: Colors.black,
                        ),
                      ],
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
              SizedBox(height: 10),
              // Informations du joueur 2
              buildUserInfoRow(usernameP2),
              SizedBox(
                height: 20,
              ),
              Text(
                'Appuyer ici pour lancer la partie',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 32,
                color: Colors.white,
              ),
              Ink(
                decoration: ShapeDecoration(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    //mergeTables(dataSubsetP1, remainingData);
                    findPlayersAndExecute();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Play',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
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
    final result = await saveUidIfHashCodeExists(inputHashCode, user.uid); // Vérifie si le hashCode existe dans Firebase

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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 102, 102, 102),
              border: Border.all(
                color: Colors.black38,
                width: 2.0,
              ),
            ),
            child: Card(
              color: Colors.transparent,
              elevation: 0,
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
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 65,
        ),
      ],
    );
  }

  // Fusion des deux tableaux

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
    EasyLoading.show(status: 'Vérification');

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
        EasyLoading.dismiss();
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
        //'usernameP2': username,
      }, SetOptions(merge: true)); // Ajoute l'uid au document existant
      username = await getUsernameFromFirebase(user.uid);
      setState(() {
        usernameP2 = username[1];
      });
      //saveRemainingDataList(user.uid);
      //mergeTables(dataSubsetP1, remainingData);
      EasyLoading.showInfo('Code trouvé');
    } else {
      // Le hashCode n'existe pas dans la base de données
      EasyLoading.showInfo('Le Code $hashCode n\'existe pas');
    }

    return uid;
  }

// Fonction récupérant les données de la liste tableData
void recupererDonneesDeTable(String hashCodeJoueur) {
  // Référence à la collection Players
  final collectionPlayersRef = FirebaseFirestore.instance.collection('Players');

  // Recherche du joueur en utilisant le hashCode
  collectionPlayersRef
      .where('hashCode', isEqualTo: hashCodeJoueur)
      .get()
      .then((querySnapshot) {
    if (querySnapshot.size > 0) {
      var joueurDocRef = querySnapshot.docs[0].reference;

      // Accéder à la sous-collection onlinePart
      final onlinePartRef = joueurDocRef.collection('onlinePart');

      // Récupérer les données de la liste tableData
      onlinePartRef.doc('tableData').get().then((documentSnapshot) {
        if (documentSnapshot.exists) {
          // Les données de la liste tableData existent

          // Récupérer les valeurs de la liste
          var tableData = documentSnapshot.data()?['tableData'];

          // Utilisez tableData selon vos besoins
          print(tableData);
        } else {
          // Les données de la liste tableData n'existent pas
          print("Aucune donnée trouvée dans la liste tableData.");
        }
      }).catchError((error) {
        print("Une erreur s'est produite : $error");
      });
    } else {
      print("Joueur non trouvé pour le hashCode donné");
    }
  }).catchError((error) {
    print("Une erreur s'est produite : $error");
  });
}

// Fonction pour gérer le clic sur le bouton (à déclencher lors du clic)
void lorsqueLeBoutonEstClique() {
  String hashCodeJoueur = hashCode;
  recupererDonneesDeTable(hashCodeJoueur);
}
}
