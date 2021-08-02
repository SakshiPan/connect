import 'package:connect/Screens/login_screen.dart';
import 'package:connect/Screens/forgot_password_screen.dart';
import 'package:connect/Screens/registration_screen.dart';
import 'package:connect/Screens/registration_verification_screen.dart';
import 'package:connect/Screens/search_screen.dart';
import 'package:connect/Screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.lightBlue, // status bar color
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: email == null ? WelcomeScreen() : SearchScreen(),
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        RegistrationVerificationScreen.id: (context) =>
            RegistrationVerificationScreen(),
        ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
        SearchScreen.id: (context) => SearchScreen(),
      }));
}
