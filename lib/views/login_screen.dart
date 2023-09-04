import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:songhogame/constants.dart';
import 'package:songhogame/views/signup_screen.dart';
import 'package:songhogame/widget/text_input_field.dart';

import '../controller/auth_controller.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});
  static AuthController authControllerInstance = Get.find();

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 119, 95, 86),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Songho Game',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 50),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Log In',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 40),
                ),
                const SizedBox(height: 30),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SvgPicture.asset(
                        'assets/images/game.svg', // Chemin vers votre fichier SVG
                        width: 150, // Largeur souhaitée de l'image
                        height: 150, // Hauteur souhaitée de l'image
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextInputFeild(
                  controller: _emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 15),
                buildPasswordField(),
                const SizedBox(height: 15),
                Container(
                  width: mediaQuery.width * 0.98,
                  height: mediaQuery.height * 0.08,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      color: Color.fromARGB(255, 218, 203, 162),
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () async {
                      EasyLoading.show(status: 'Connexion');
                      await Future.delayed(Duration(seconds: 2));

                      LogInScreen.authControllerInstance.login(
                          _emailController.text, _passwordController.text);

                      EasyLoading.showInfo('Connecté');
                    },
                    child: const Center(
                        child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700,),
                    )),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Get.to(() => SignUpScreen());
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: buttonColor, fontSize: 18),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelStyle: const TextStyle(fontSize: 20, color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        prefixIcon: Icon(
          Icons.password,
          color: Color.fromARGB(255, 218, 203, 162),
        ),
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility_off : Icons.visibility,
            color: Color.fromARGB(255, 218, 203, 162),
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
  }
}
