import 'package:connect/Models/messages.dart';
import 'package:connect/Models/user_details.dart';
import 'package:connect/Utilities/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Constants.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Utils utils = Utils();
  GoogleSignIn _googleSignIn = GoogleSignIn();

  User? getCurrentUser() {
    User? currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await _googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<void> addDataToDb(User currentUser) async {
    String username = utils.getUserName(currentUser.email!);

    UserDetails user = UserDetails(
      uid: currentUser.uid,
      email: currentUser.email,
      username: username,
      profilePhoto: currentUser.photoURL,
    );

    await firestore
        .collection(kUsersDatabase)
        .doc(user.uid)
        .set(user.toMap(user));
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection(kUsersDatabase)
        .where('email', isEqualTo: user.email)
        .get();
    final List<DocumentSnapshot> docs = result.docs;
    return docs.length == 0 ? true : false;
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<List<UserDetails>> fetchAllUsers(User currentUser) async {
    List<UserDetails> userList = <UserDetails>[];
    await firestore.collection(kUsersDatabase).get().then((value) {
      value.docs.forEach((element) {
        if (element.id != currentUser.uid)
          userList.add(UserDetails.fromMap(element.data()));
      });
    });
    return userList;
  }

  Future<void> addMessagetoDb(Message message) async {
    await firestore
        .collection(kMessageDatabase)
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(message.toMap());

    await firestore
        .collection(kMessageDatabase)
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(message.toMap());

    return;
  }
}
