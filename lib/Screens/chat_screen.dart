import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Models/messages.dart';
import 'package:connect/Models/user_details.dart';
import 'package:connect/components/custom_app_bar_chat_screen.dart';
import 'package:connect/components/message_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connect/Constants.dart';
import 'package:connect/Firebase/Firebase_repository.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'ChatScreeen';
  final UserDetails receiver;

  ChatScreen({required this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

final FirebaseRepository _repository = FirebaseRepository();

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  bool isWriting = false;
  late String currentUserId;
  late User? user;
  late UserDetails currentUserDetails;
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    user = _repository.getCurrentUser();
    setState(() {
      currentUserId = user!.uid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageStream(
              currentUserId: currentUserId,
              receiverUserId: widget.receiver.uid!,
              scrollController: _scrollController,
            ),
          ),
          chatControls(),
        ],
      ),
    );
  }

  sendMessage() {
    var text = textFieldController.text;

    Message _message = Message(
      receiverId: widget.receiver.uid!,
      senderId: currentUserId,
      message: text,
      timestamp: FieldValue.serverTimestamp(),
    );

    setState(() {
      isWriting = false;
    });

    _repository.addMessagetoDb(_message);
    textFieldController.clear();

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  CustomAppBarChatScreen customAppBar(context) {
    return CustomAppBarChatScreen(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.username!,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onTap: () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: textFieldController,
              style: TextStyle(
                color: Colors.black,
              ),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: kchatInputTextDecoration,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent, shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
