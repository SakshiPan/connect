import 'package:flutter/material.dart';

class CustomAppBarChatScreen extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget leading;
  final Widget title;
  final bool centerTitle;

  const CustomAppBarChatScreen({
    required this.title,
    required this.leading,
    required this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue,
      ),
      child: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        centerTitle: centerTitle,
        leading: leading,
        title: title,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}
