import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:songhogame/constants.dart';
import 'package:songhogame/controller/auth_controller.dart';
import 'package:songhogame/controller/auth_google.dart';
import 'package:songhogame/models/online_modal.dart';
import 'package:songhogame/views/login_screen.dart';
import 'package:songhogame/widget/text_input_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key, this.onTap});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Function()? onTap;

  static AuthController authControllerInstance = Get.find();

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.black,
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
                const Text(
                  'Create your account',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 32),
                ),
                const SizedBox(height: 15),
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
                  controller: _userNameController,
                  labelText: 'Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                TextInputFeild(
                  controller: _emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 10),
                TextInputFeild(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.password,
                  isObscure: true,
                ),
                const SizedBox(height: 18),
                Container(
                  width: mediaQuery.width * 0.98,
                  height: mediaQuery.height * 0.08,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () => authControllerInstance.register(
                      _userNameController.text,
                      _emailController.text,
                      _passwordController.text,
                    ),
                    child: const Center(
                        child: Text(
                      'Register',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Or continue with ',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: mediaQuery.width * 0.98,
                  height: mediaQuery.height * 0.08,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      AuthService().signInWithGoogle();
                      AuthService().saveGoogleUserInfoToFirestore(user);
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20, // taille de l'image en pixels
                            height: 20,
                            child: Image.asset('assets/images/google.png'),
                          ),
                          SizedBox(
                              width: 12), // espace entre l'image et le texte
                          Text(
                            'Sign Up with Google',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Get.to(() => LogInScreen());
                      },
                      child: Text(
                        'LogIn',
                        style: TextStyle(color: buttonColor, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
