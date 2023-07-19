import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:songhogame/onboarding/Regle.dart';
import 'package:songhogame/views/Start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLooked = prefs.getBool('isLooked') ?? false;

  runApp(MyApp(isLooked: isLooked));
}

class MyApp extends StatelessWidget {
  final bool isLooked;

  const MyApp({Key? key, required this.isLooked}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
       home: isLooked ? Start() : Regle(),
    );
  }
}


