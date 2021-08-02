import 'package:connect/Screens/forgot_password_screen.dart';
import 'package:connect/Screens/search_screen.dart';
import 'package:connect/components/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:connect/components/rounded_button.dart';
import 'package:connect/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _textemail = TextEditingController();
  final _textpassword = TextEditingController();
  late String _email;
  late String _password;
  bool showSpinner = false;
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
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _email = value;
                },
                controller: _textemail,
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
                  color: Colors.lightBlueAccent,
                  title: 'Log In',
                  onPressed: () async {
                    setState(() {
                      if (_validateemail == false && _validatepassword == false)
                        showSpinner = true;
                    });

                    if (_validateemail == false && _validatepassword == false) {
                      try {
                        final userCredential =
                            await _auth.signInWithEmailAndPassword(
                                email: _email, password: _password);
                        if (userCredential.user != null) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('email', userCredential.user!.email!);

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              SearchScreen.id, (Route<dynamic> route) => false);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } on FirebaseAuthException catch (error) {
                        errorMessage = error.message;
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorDialog(errorMessage);
                            });

                        setState(() {
                          showSpinner = false;
                          FocusScope.of(context).unfocus();
                          _textpassword.clear();
                          _textemail.clear();
                          _validateemail = false;
                          _validatepassword = false;
                          errorTextField = null;
                        });
                      } catch (e) {
                        print(e);
                      }
                    }
                  }),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: MaterialButton(
                    elevation: 5.0,
                    minWidth: 100.0,
                    height: 42.0,
                    child: Text(
                      'Forgot Password',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, ForgotPasswordScreen.id);
                      setState(() {
                        showSpinner = false;
                        FocusScope.of(context).unfocus();
                        _textpassword.clear();
                        _textemail.clear();
                        _validateemail = false;
                        _validatepassword = false;
                        errorTextField = null;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
