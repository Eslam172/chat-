import 'package:chat_pract/AppProvider/AppProvider.dart';
import 'package:chat_pract/main.dart';
import 'package:chat_pract/models/Message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  Message? message;
  MessageWidget(this.message);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return message==null?Container():
    (
    message?.senderId==provider.currentUser?.id?
        SentMessage(message):
        RecivedMessage(message)
    );
  }

}
class SentMessage extends StatelessWidget{
  Message? message;
  SentMessage(this.message);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(message?.getDateFormatted()??''),
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: MyThemeData.colorPrimary,
              borderRadius: BorderRadius.only(topRight: Radius.circular(12)
                  ,bottomRight: Radius.circular(12)
                  ,bottomLeft: Radius.circular(12))
          ),
          child: Text(message?.content??'',style: TextStyle(
            color: Colors.white,
            fontSize: 14
          ),),
        )
      ],
    );
  }
}

class RecivedMessage extends StatelessWidget{
  Message? message;
  RecivedMessage(this.message);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message?.senderName??''),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xffF8F8F8),
                borderRadius:  BorderRadius.only(topRight: Radius.circular(12)
                    ,bottomRight: Radius.circular(12)
                    ,bottomLeft: Radius.circular(12))
              ),
              child: Text(message?.content??'',style: TextStyle(
                color: Color(0xff787993),
                fontSize: 14
              ),),
            ),
            Text(message?.getDateFormatted()??'')
          ],
        )
      ],
    );
  }
}
