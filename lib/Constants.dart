import 'package:flutter/material.dart';

const kLabelFontSize = 10;
const kWelcomeImageSize = 280.0;
const kEmptyChatSearchImageSize = 360.0;
const kUsersDatabase = 'users';
const kContactsDatabase = 'contacts';
const kMessageDatabase = 'messages';
const kLogoutDialogText = 'Sure, you want to logout?';
const kInternalErrorText = 'Some Internal Error Occured';
const kRegistrationVerificationText =
    'Verification email is being sent to you , kindly click on to verify';
const kForgotPasswordDialogText =
    'Password reset email is being sent to you , kindly click on the link to reset your password then login again.';
const kEmptyChatSearchText = 'Find your Friend here...';
const kinputTextDecoration = InputDecoration(
  hintText: 'Enter a Value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kchatInputTextDecoration = InputDecoration(
  hintText: 'Type your message',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
