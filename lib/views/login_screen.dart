import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:songhogame/constants.dart';
import 'package:songhogame/views/signup_screen.dart';
import 'package:songhogame/widget/text_input_field.dart';

import '../controller/auth_controller.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static AuthController authControllerInstance = Get.find();

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
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
                      color: buttonColor,
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
                TextInputFeild(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.password,
                  isObscure: true,
                ),
                const SizedBox(height: 15),
                Container(
                  width: mediaQuery.width * 0.98,
                  height: mediaQuery.height * 0.08,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () => authControllerInstance.login(
                        _emailController.text, _passwordController.text),
                    child: const Center(
                        child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    )),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontSize: 18),
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
}
