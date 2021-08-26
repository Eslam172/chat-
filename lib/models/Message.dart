import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Message {
  static const COLLECTION_NAME = 'message';
  String id;
  String content;
  int time;
  String senderName;
  String senderId;

  Message({required this.id, required this.content,
    required this.time,required this.senderName,required this.senderId
  });

  Message.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    content: json['content']! as String,
    time: json['time']! as int,
    senderName: json['senderName']! as String,
    senderId: json['senderId']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'content': content,
      'time': time,
      'senderName': senderName,
      'senderId': senderId,
    };
  }

  String getDateFormatted(){

    var outFormat = DateFormat('HH:mm a');

    return outFormat.format(DateTime.fromMicrosecondsSinceEpoch(time));
  }
}
