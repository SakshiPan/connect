import 'package:flutter/material.dart';

class SearchedUserAvatar extends StatelessWidget {
  SearchedUserAvatar({this.profilePhoto});
  final String? profilePhoto;
  @override
  Widget build(BuildContext context) {
    if (profilePhoto == null) {
      return CircleAvatar(
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
      );
    } else {
      return CircleAvatar(
        backgroundImage: NetworkImage(profilePhoto!),
        backgroundColor: Colors.lightBlue,
      );
    }
  }
}
