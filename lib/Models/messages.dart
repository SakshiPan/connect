import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String receiverId;
  String senderId;
  String message;
  String? photoUrl;
  FieldValue timestamp;

  Message({
    required this.message,
    required this.receiverId,
    required this.senderId,
    required this.timestamp,
  });

  Message.imageMessage(
      {required this.timestamp,
      required this.senderId,
      required this.receiverId,
      required this.message,
      this.photoUrl});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['message'] = this.message;
    map['timeStamp'] = this.timestamp;
    return map;
  }

  Message fromMap(Map<String, dynamic> map) {
    Message _message = Message(
        senderId: map['senderId'],
        receiverId: map['receiverId'],
        message: map['message'],
        timestamp: map['timeStamp']);
    return _message;
  }
}
