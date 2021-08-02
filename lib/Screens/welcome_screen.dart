import 'package:connect/Firebase/Firebase_repository.dart';
import 'package:connect/Screens/login_screen.dart';
import 'package:connect/Screens/registration_screen.dart';
import 'package:connect/Screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect/components/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connect/components/error_dialog.dart';
import 'package:connect/Constants.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  bool showSpinner = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'images/logo-connect.jpg',
                height: kWelcomeImageSize,
                width: kWelcomeImageSize,
              ),
              RoundedButton(
                title: 'Log In',
                color: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              RoundedButton(
                title: 'Register',
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
              RoundedButton(
                title: 'Google Sign In',
                color: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });

                  try {
                    UserCredential _userCredential =
                        await _repository.signInWithGoogle();

                    if (_userCredential.user != null) {
                      bool res = await _repository
                          .authenticateUser(_userCredential.user!);

                      if (res) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('email', _userCredential.user!.email!);

                        await _repository.addDataToDb(_userCredential.user!);

                        Navigator.of(context).pushNamedAndRemoveUntil(
                            SearchScreen.id, (Route<dynamic> route) => false);

                        setState(() {
                          showSpinner = false;
                        });
                      } else {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('email', _userCredential.user!.email!);

                        Navigator.of(context).pushNamedAndRemoveUntil(
                            SearchScreen.id, (Route<dynamic> route) => false);

                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }
                  } on FirebaseAuthException catch (error) {
                    setState(() {
                      showSpinner = false;
                    });
                    errorMessage = error.message;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(errorMessage);
                        });
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(kInternalErrorText);
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
