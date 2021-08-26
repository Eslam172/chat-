import 'package:chat_pract/AppProvider/AppProvider.dart';
import 'package:chat_pract/dataBase/DataBaseHelper.dart';
import 'package:chat_pract/main.dart';
import 'package:chat_pract/models/Message.dart';
import 'package:chat_pract/models/Room.dart';
import 'package:chat_pract/roomDetails/MessageWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDetailsScreen extends StatefulWidget {
  static const String routeName='room details';

  @override
  _RoomDetailsScreenState createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  late Room room;

  String typedMessage='';

  late CollectionReference <Message> messageRef;
  late TextEditingController messageController;

  late AppProvider provider;
  @override
  void initState() {
    // TODO: implement initState
     messageController = TextEditingController(text: typedMessage);
  }

  @override
  Widget build(BuildContext context) {


    provider =Provider.of<AppProvider>(context);
    double size = MediaQuery.of(context).size.width;
    final args = ModalRoute.of(context)?.settings.arguments as RoomDetailsArgs;
    room =args.room;
    messageRef = getMessagesCollectionWithConverter(room.id);
    final Stream <QuerySnapshot<Message>> messageStream = messageRef
        .orderBy('time')
        .snapshots();
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
            title: Text(room.name),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(vertical: 35,horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(4,8),
                  blurRadius: 10
                )
              ]
            ),
            child: Column(
              children: [
                Expanded(child: StreamBuilder(
                  stream: messageStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Message>> snapshot){
                    if(snapshot.hasError){
                      return Text((snapshot.error.toString()));
                    }else if(snapshot.hasData){
                      return ListView.builder(itemBuilder: (context,index){
                        return 
                            MessageWidget(snapshot.data?.docs[index]
                            .data()
                            );
                      },
                      itemCount: snapshot.data?.size??0,
                      );
                    }
                    return Center(child:
                    CircularProgressIndicator(color: MyThemeData.colorPrimary,),);
                  },
                )),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,

                        onChanged: (newText){
                          typedMessage=newText;

                        },
                        decoration: InputDecoration(

                          hintText: 'type a message...',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400
                          ),
                          fillColor: MyThemeData.colorPrimary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 4)
                        ),
                      ),
                    ),
                    SizedBox(width: size*.03,),
                    Container(
                      decoration: BoxDecoration(
                        color:  MyThemeData.colorPrimary,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13,horizontal: 22),
                      margin: EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: (){
                          sendMessage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Send',style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16
                            ),),
                            SizedBox(width: size*.03,),
                            Image.asset('assets/images/ic_send.png',width: 20,height: 20,)
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void sendMessage(){
    if(typedMessage.isEmpty)return;
    final newMessageObj=messageRef.doc();
    final message = Message(id: newMessageObj.id, content: typedMessage,
        time: DateTime.now().microsecondsSinceEpoch,
        senderName: provider.currentUser?.userName??'',
        senderId: provider.currentUser?.id??'');
    newMessageObj.set(message).then((value) {
      setState(() {
        messageController.clear();
      });
    });
  }
}

class RoomDetailsArgs{
  Room room;
  RoomDetailsArgs(this.room);
}
