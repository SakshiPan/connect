import 'package:connect/Firebase/Firebase_utility_methods.dart';
import 'package:connect/Models/messages.dart';
import 'package:connect/Models/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  FirebaseMethods firebaseMethods = FirebaseMethods();

  User? getCurrentUser() => firebaseMethods.getCurrentUser();

  Future<UserCredential> signInWithGoogle() =>
      firebaseMethods.signInWithGoogle();

  Future<void> addDataToDb(User currentUser) =>
      firebaseMethods.addDataToDb(currentUser);

  Future<bool> authenticateUser(User user) =>
      firebaseMethods.authenticateUser(user);

  Future<void> signOut() => firebaseMethods.signOut();

  Future<List<UserDetails>> fetchAllUsers(User currentUser) =>
      firebaseMethods.fetchAllUsers(currentUser);

  Future<void> addMessagetoDb(Message message) =>
      firebaseMethods.addMessagetoDb(message);
}
