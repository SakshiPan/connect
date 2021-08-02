import 'package:connect/Models/user_details.dart';
import 'package:connect/Screens/chat_screen.dart';
import 'package:connect/Screens/welcome_screen.dart';
import 'package:connect/components/custom_tile.dart';
import 'package:connect/components/empty_chat_search_view.dart';
import 'package:connect/components/serched_user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:connect/Firebase/Firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connect/Constants.dart';

class SearchScreen extends StatefulWidget {
  static const String id = 'SearchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  late List<UserDetails> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();
  bool showSpinner = false;

  @override
  void initState() {
    User? user = _repository.getCurrentUser();
    _repository.fetchAllUsers(user!).then((List<UserDetails> list) {
      setState(() {
        userList = list;
      });
    });

    super.initState();
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      leading: Container(),
      leadingWidth: 0,
      backgroundColor: Colors.lightBlue,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: Colors.white,
            autofocus: false,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance!
                      .addPostFrameCallback((_) => searchController.clear());
                  setState(() {
                    query = "";
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(kLogoutDialogText),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                Navigator.pop(context);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('email');
                                _repository.signOut();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    WelcomeScreen.id,
                                    (Route<dynamic> route) => false);
                                setState(() {
                                  showSpinner = false;
                                });
                              },
                              child: Text('Confirm'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      });
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchAppBar(context),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
              (query == "") ? EmptyChatSearchView() : buildSuggestions(query),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<UserDetails> suggestionList = query.isEmpty
        ? []
        : userList.where((UserDetails user) {
            String _getUsername = user.username!.toLowerCase();
            String _query = query.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            return (matchesUsername);
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        UserDetails searchedUser = UserDetails(
            uid: suggestionList[index].uid,
            email: suggestionList[index].email,
            profilePhoto: suggestionList[index].profilePhoto,
            username: suggestionList[index].username);

        return CustomTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ChatScreen(
                    receiver: searchedUser,
                  );
                },
              ),
            );
          },
          leading: SearchedUserAvatar(profilePhoto: searchedUser.profilePhoto),
          title: Text(
            searchedUser.username!,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      }),
    );
  }
}
