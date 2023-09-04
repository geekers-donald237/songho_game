import 'package:firebase_core/firebase_core.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:songhogame/controller/auth_controller.dart';
import 'package:songhogame/views/Start.dart';

void main() async {
  /* WidgetsBinding widgetsBinding=*/
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  await Firebase.initializeApp().then(
    (value) {
      Get.put(AuthController());
    },
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //final bool isLooked;

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Songho game',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      //  home: isLooked ? Start() : Regle(),
      routes: {
        '/home': (context) => Start(),
      },
      builder: EasyLoading.init(),
      home: Start(),
    );
  }
}
