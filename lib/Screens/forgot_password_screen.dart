import 'package:connect/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Constants.dart';
import 'package:connect/Constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connect/components/error_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String id = 'LoginVerificationScreen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late String _email;
  final _auth = FirebaseAuth.instance;
  final _textemail = TextEditingController();
  bool _validateemail = false;
  bool showSpinner = false;
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
  }

  @override
  void dispose() {
    _textemail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              RoundedButton(
                  color: Colors.lightBlueAccent,
                  title: 'Send Request',
                  onPressed: () async {
                    setState(() {
                      if (_validateemail == false) showSpinner = true;
                    });
                    if (_validateemail == false) {
                      try {
                        await _auth
                            .sendPasswordResetEmail(email: _email)
                            .then((onValue) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(kForgotPasswordDialogText),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.pop(context);
                                        },
                                        child: Text('Okay'))
                                  ],
                                );
                              });

                          // Navigator.pop(context);
                          setState(() {
                            FocusScope.of(context).unfocus();
                            showSpinner = false;
                            _textemail.clear();
                            errorTextField = null;
                            _validateemail = false;
                          });
                        });
                      } on FirebaseAuthException catch (error) {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          showSpinner = false;
                          _textemail.clear();
                          errorTextField = null;
                          _validateemail = false;
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
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
