import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:new_minor/pages/SplashScreen.dart';
import 'package:new_minor/pages/income_saving_page.dart';
import 'package:new_minor/pages/otp_login_page.dart';
import 'package:new_minor/read_sms.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return SafeArea(
          child: child!,
        );
      },
      home: SplashScreen()
    );
  }
}
