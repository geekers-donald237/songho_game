import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songhogame/constants.dart';
import 'package:songhogame/controller/gameController.dart';
import 'package:songhogame/models/dataOnline.dart';
import 'package:songhogame/onboarding/hashcode.dart';

var user = FirebaseAuth.instance.currentUser!;
final gameController = GameController();
List<String> username = [];
String usernameP1 = '';
String usernameP2 = '';

void openModal(BuildContext context) {
  TextEditingController codeController = TextEditingController();

  bool isEditable = true;
  bool joinEnabled = true;
  bool lancerEnabled = true;
  bool isButtonDisabled = false;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      getCurrentUser();
      //final double screenHeight = MediaQuery.of(context).size.height;
      
      Size mediaQuery = MediaQuery.of(context).size;
      String hashCode = '';

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return FractionallySizedBox(
            //heightFactor: desiredHeight / screenHeight,
            child: Container(
              color: Color.fromARGB(255, 48, 51, 33),
              //height: mediaQuery.height * 20,
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Initier une partie',
                      style: TextStyle(
                        color: buttonColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        isButtonDisabled ? null : () {};
                        ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: isButtonDisabled
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.grey,
                        );

                        lancerEnabled
                            ? () {
                                setState(() {
                                  joinEnabled = false;
                                });
                              }
                            : null;
                        setState(() {
                          hashCode = generateHashCode();
                          isEditable = false;
                        });
                        saveHashCode(hashCode, user.uid);
                        createAndSaveFirebaseTable(user.uid);
                        retrieveFirebaseTable(user.uid);
                        username = await getUsernameFromFirebase(
                                          user.uid);
                                      setState(() {
                                        usernameP1 = username[0];
                                      });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                        color: buttonColor,
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
                                codeController.text = value.substring(0,
                                    4); // Ignorer les caractères excédentaires
                                codeController.selection =
                                    TextSelection.fromPosition(
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
                              prefixIcon: Icon(Icons.password),
                              labelStyle: const TextStyle(fontSize: 20),
                              border: InputBorder
                                  .none, // Supprime la bordure inférieure
                              focusedBorder: InputBorder
                                  .none, // Supprime la bordure inférieure pendant le focus
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
                                      username = await getUsernameFromFirebase(
                                          user.uid);
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
                    FloatingActionButton(
                      onPressed: () async {
                        //print(usernameP2);

                        //getEmailUsernameFromFirestore();
                        // Action à effectuer lorsque le bouton du modal est pressé
                        // Ajoutez votre logique ici
                      },
                      child: Icon(Icons.start_sharp),
                    ),
                    buildUserInfoCard(usernameP2),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

/* void executeAfterDelay() {
  // Définir la durée de délai à 5 secondes (5000 millisecondes)
  const delayDuration = Duration(seconds: 5);

  // Utiliser Future.delayed pour exécuter la fonction après le délai spécifié
  Future.delayed(delayDuration, () {
    gameController.changeScreenOrientation(
        context as BuildContext, const Online());
  });
} */