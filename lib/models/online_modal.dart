import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songhogame/constants.dart';
import 'package:songhogame/onboarding/hashcode.dart';

var user = FirebaseAuth.instance.currentUser!;

String inputValue = '';

// Fonction pour récupérer la valeur saisie dans le TextField
String getValueFromTextField(String value) {
  inputValue = value;
  //print(inputValue);

  return inputValue;
}

/* void onPressedButton() async {
  final inputHashCode = getValueFromTextField(inputValue);
  final hashCodeExists = await saveUidIfHashCodeExists(inputHashCode, user.uid);

  if (hashCodeExists) {
    print('Le hashCode existe dans Firebase.');
    // Effectuez ici les actions à réaliser lorsque le hashCode existe
  } else {
    print('Le hashCode n\'existe pas dans Firebase.');
    // Effectuez ici les actions à réaliser lorsque le hashCode n'existe pas
  }
} */

void onPressedButton() async {
  final inputHashCode = getValueFromTextField(
      inputValue); // Récupère la valeur saisie dans le TextField
  final hashCodeExists = await saveUidIfHashCodeExists(
      inputHashCode, user.uid); // Vérifie si le hashCode existe dans Firebase

  if (hashCodeExists != null) {
    // Enregistre l'uid si le hashCode existe
    await saveUidIfHashCodeExists(inputHashCode, user.uid);
    print('Le hashCode existe dans Firebase et l\'UID a été enregistré.');
    // Effectuez ici les actions à réaliser lorsque le hashCode existe et que l'UID a été enregistré
  } else {
    print('Le hashCode n\'existe pas dans Firebase.');
    // Effectuez ici les actions à réaliser lorsque le hashCode n'existe pas
  }
}

void openModal(BuildContext context) {
  TextEditingController codeController = TextEditingController();

  bool isEditable = true;

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
                          // Action à effectuer lors de la pression sur le bouton
                          // Appeler la fonction de recherche
                          onPressedButton();
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
                      setState(() {
                        hashCode = generateHashCode();
                        isEditable = false;
                      });
                      saveHashCode(hashCode, user.uid);
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
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
