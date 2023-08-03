import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songhogame/constants.dart';
import 'package:songhogame/models/user_model.dart';
import 'package:songhogame/onboarding/hashcode.dart';
import 'package:songhogame/widget/text_input_field.dart';

var user = FirebaseAuth.instance.currentUser!;
void openModal(BuildContext context) {
  TextEditingController inputController = TextEditingController();

  showModalBottomSheet(
    context: context,
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
                  TextInputFeild(
                    controller: inputController,
                    icon: Icons.password_outlined,
                    labelText: 'Saisissez le code de la partie',
                  ),
                  SizedBox(height: 50),
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
