import 'package:chat_pract/addRoom/AddRoom.dart';
import 'package:chat_pract/dataBase/DataBaseHelper.dart';
import 'package:chat_pract/home/RoomWidget.dart';
import 'package:chat_pract/main.dart';
import 'package:chat_pract/models/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName='home';

  CollectionReference<Room> roomsCollectionRef= getRoomsCollectionWithConverter();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
        ),
        Image(image: AssetImage('assets/images/top_bg.png'),
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text('Chat App',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),),
            centerTitle: true,

          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushNamed(context, AddRoom.routeName);
            },
            child: Icon(Icons.add),
            backgroundColor: MyThemeData.colorPrimary,
          ),
          body: Container(
            margin: EdgeInsets.only(left: 12,right: 12,bottom: 30,top: 50),
            child: FutureBuilder<QuerySnapshot<Room>>(
              future: roomsCollectionRef.get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Room>> snapShot){
                if(snapShot.hasError){
                  return Text('something went wrong');
                }else if (snapShot.connectionState==ConnectionState.done){
                  final List<Room>roomsList = snapShot.data?.docs.map((singleDoc) =>singleDoc.data() )
                  .toList()??[];
                  return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 10
                  ),
                      itemBuilder: (context,index){
                    return RoomWidget(roomsList[index]);
                      },
                  itemCount: roomsList.length,
                  );
                }
                return Center(child: CircularProgressIndicator(),);
            },
            ),
          ),
        )
      ],
    );
  }
}
