import 'dart:async';
import 'package:connect/Firebase/Firebase_repository.dart';
import 'package:connect/Screens/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connect/components/error_dialog.dart';
import 'package:connect/Constants.dart';

class RegistrationVerificationScreen extends StatefulWidget {
  static const String id = 'RegistrationVerificationScreen';

  @override
  _RegistrationVerificationScreenState createState() =>
      _RegistrationVerificationScreenState();
}

class _RegistrationVerificationScreenState
    extends State<RegistrationVerificationScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  final _auth = FirebaseAuth.instance;
  late User _user;
  late Timer _timer;
  String? errorMessage;

  @override
  void initState() {
    _user = _auth.currentUser!;
    try {
      if (_user != null) {
        _user.sendEmailVerification();
        _timer = Timer.periodic(Duration(seconds: 3), (timer) {
          checkemailverified().whenComplete(() {
            setState(() {});
          });
        });
      }
    } on FirebaseAuthException catch (error) {
      errorMessage = error.message;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(errorMessage);
          });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  void dispose() async {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.mail,
              size: 200,
              color: Colors.blueAccent,
            ),
            Text(
              kRegistrationVerificationText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkemailverified() async {
    try {
      _user = _auth.currentUser!;
      await _user.reload();
      if (_user.emailVerified) {
        _timer.cancel();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _user.email!);
        await _repository.addDataToDb(_auth.currentUser!);
        Navigator.of(context).pushNamedAndRemoveUntil(
            SearchScreen.id, (Route<dynamic> route) => false);
      }
    } on FirebaseAuthException catch (error) {
      errorMessage = error.message;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(errorMessage);
          });
    } catch (e) {
      print(e);
    }
  }
}
