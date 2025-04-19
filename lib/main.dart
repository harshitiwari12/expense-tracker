import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:new_minor/pages/SplashScreen.dart';
import 'package:new_minor/pages/registration_page.dart';
import 'package:new_minor/read_sms.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OTP Auth',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: RegistrationPage()
    );
  }
}
