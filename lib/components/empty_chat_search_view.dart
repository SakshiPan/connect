import 'package:flutter/material.dart';
import 'package:connect/Constants.dart';

class EmptyChatSearchView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'images/empty_view.jpg',
            height: kEmptyChatSearchImageSize,
            width: kEmptyChatSearchImageSize,
          ),
          Text(
            kEmptyChatSearchText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black26,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
