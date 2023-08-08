import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songhogame/constants.dart';
import 'package:songhogame/controller/auth_controller.dart';
import 'package:songhogame/controller/gameController.dart';
import 'package:songhogame/models/dataOnline.dart';
import 'package:songhogame/onboarding/hashcode.dart';

var user = FirebaseAuth.instance.currentUser!;
final gameController = GameController();

void openModal(BuildContext context) {
  TextEditingController codeController = TextEditingController();

  bool isEditable = true;
  bool joinEnabled = true;
  bool lancerEnabled = true;
  bool isButtonDisabled = false;

  showModalBottomSheet(
    context: context,
    //isScrollControlled: true,
    builder: (BuildContext context) {
      getCurrentUser();
      Size mediaQuery = MediaQuery.of(context).size;
      String hashCode = '';

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            color: Color.fromARGB(255, 33, 51, 49),
            height: mediaQuery.height * 4,
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                          onChanged:
                              getValueFromTextField, // Écoute les changements dans le TextField
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
                      ElevatedButton(
                        onPressed: () {
                          performFirebaseActions();
                          // Action à effectuer lors de la pression sur le bouton
                          // Appeler la fonction de recherche
                          onPressedButton();
                          joinEnabled
                              ? () {
                                  setState(() {
                                    lancerEnabled = false;
                                  });
                                }
                              : null;
                        },
                        child: Text('Join'),
                      )
                    ],
                  ),
                  SizedBox(height: 50),
                  Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                    height: 20.0,
                  ),
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
                    onPressed: () {
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
                      ElevatedButton(
                        onPressed: () {
                          copyCodeToClipboard(context, hashCode);
                        },
                        child: Text('Copier'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  FloatingActionButton(
                    onPressed: () {
                        getEmailUsernameFromFirestore();
                      storeUsernameOnFirestore();
                      // Action à effectuer lorsque le bouton du modal est pressé
                      // Ajoutez votre logique ici
                      /* gameController.changeScreenOrientation(
                          context, const Online());
                      print('Le bouton du modal a été pressé !'); */
                    },
                    child: Icon(Icons.start_sharp),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
