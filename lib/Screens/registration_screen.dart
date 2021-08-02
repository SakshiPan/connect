import 'package:connect/Screens/registration_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:connect/components/rounded_button.dart';
import 'package:connect/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connect/components/error_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  final _textemail = TextEditingController();
  final _textpassword = TextEditingController();
  bool _validateemail = false;
  bool _validatepassword = false;
  String? errorMessage;
  String? errorTextField = 'value can\'t be empty';

  @override
  void initState() {
    super.initState();
    _textemail.addListener(() {
      setState(() {
        _textemail.text.isEmpty
            ? _validateemail = true
            : _validateemail = false;
      });
    });

    _textpassword.addListener(() {
      setState(() {
        _textpassword.text.isEmpty
            ? _validatepassword = true
            : _validatepassword = false;
      });
    });
  }

  @override
  void dispose() {
    _textemail.dispose();
    _textpassword.dispose();
    super.dispose();
  }

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
            children: <Widget>[
              TextField(
                controller: _textemail,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _email = value;
                },
                decoration: kinputTextDecoration.copyWith(
                  hintText: 'Enter your email',
                  errorText: _validateemail ? errorTextField : null,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _textpassword,
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  _password = value;
                },
                decoration: kinputTextDecoration.copyWith(
                  hintText: 'Enter your password',
                  errorText: _validatepassword ? errorTextField : null,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  color: Colors.blueAccent,
                  title: 'Register',
                  onPressed: () async {
                    setState(() {
                      if (_validateemail == false && _validatepassword == false)
                        showSpinner = true;
                    });
                    if (_validateemail == false && _validatepassword == false) {
                      try {
                        final userCredential =
                            await _auth.createUserWithEmailAndPassword(
                                email: _email, password: _password);
                        if (userCredential.user != null) {
                          Navigator.pushNamed(
                              context, RegistrationVerificationScreen.id);
                        }
                        setState(() {
                          showSpinner = false;
                          _textpassword.clear();
                          _textemail.clear();
                          FocusScope.of(context).unfocus();
                          _validateemail = false;
                          _validatepassword = false;
                          errorTextField = null;
                        });
                      } on FirebaseAuthException catch (error) {
                        setState(() {
                          showSpinner = false;
                          _textpassword.clear();
                          _textemail.clear();
                          FocusScope.of(context).unfocus();
                          _validateemail = false;
                          _validatepassword = false;
                          errorTextField = null;
                        });
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}
