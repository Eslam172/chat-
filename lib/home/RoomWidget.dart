import 'package:chat_pract/models/Room.dart';
import 'package:chat_pract/roomDetails/RoomDetailsScreen.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {
  Room room;
  RoomWidget(this.room);
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(RoomDetailsScreen.routeName,
            arguments: RoomDetailsArgs(room));
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black12,offset: Offset(4,8),blurRadius: 20,spreadRadius: 10)
          ]
        ),
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/${room.category}.png'),
            height: size*.13,
            fit: BoxFit.fitHeight,
            ),
            Text(room.name,style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600
            ),)
          ],
        ),
      ),
    );
  }
}
