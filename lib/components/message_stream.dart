import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';
import 'package:connect/Constants.dart';

class MessageStream extends StatelessWidget {
  MessageStream(
      {required this.currentUserId,
      required this.receiverUserId,
      required this.scrollController});

  final String currentUserId;
  final String receiverUserId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(kMessageDatabase)
          .doc(currentUserId)
          .collection(receiverUserId)
          .orderBy('timeStamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['message'];

          final messageSender = message['senderId'];

          final messageBubble = MessageBubble(
            text: messageText,
            isMe: currentUserId == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return ListView(
          reverse: false,
          controller: scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
          children: messageBubbles,
        );
      },
    );
  }
}
