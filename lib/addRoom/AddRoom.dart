import 'package:chat_pract/dataBase/DataBaseHelper.dart';
import 'package:chat_pract/main.dart';
import 'package:chat_pract/models/Room.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddRoom extends StatefulWidget {
  static const String routeName = 'add room';

  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  String roomName = '';

  String description = '';

  List<String> categories =['sports','music','movies'];
  String selectedCategory ='sports';

  final _addRoomFormKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
        Image(
          image: AssetImage('assets/images/top_bg.png'),
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'New Room',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(left: 15, right: 15, top: 35, bottom: 50),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(4, 8),
                        blurRadius: 4)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create New Room',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Image(image: AssetImage('assets/images/add_room_ic.png')),
                  Form(
                      key: _addRoomFormKey,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              onChanged: (newText) {
                                roomName = newText;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Enter Room Name',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Room Name';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                                onChanged: (newText) {
                                  description = newText;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Enter Room Description',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                ),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return ('Please enter Password');
                                  }
                                  return null;
                                }),
                          ],
                        ),
                      )),
                  DropdownButton(
                      value: selectedCategory,
                      iconSize: 24,
                      elevation: 16,
                      items: categories.map((name){
                    return DropdownMenuItem(
                      value: name,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                             Image(image: AssetImage('assets/images/$name.png'),
                             width: 24,
                               height: 24,
                             ) ,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(name),
                              )
                            ],
                          ),
                        ));
                  }).toList(),
                    onChanged: ( newSelected){
                        setState(() {
                          selectedCategory=newSelected.toString();
                        });
                    },

                  ),

                  SizedBox(
                    height: size * .1,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child:
                    isLoading? Center(child: CircularProgressIndicator(),)
                        :ElevatedButton(
                        onPressed: () {
                          if(_addRoomFormKey.currentState?.validate()==true){
                            addRoom();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: MyThemeData.colorPrimary,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child:
                        Text(
                          'Create',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        )),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
  void addRoom(){
    setState(() {
      isLoading=true;
    });
    final docRef = getRoomsCollectionWithConverter().doc();
    Room room = Room(id: docRef.id, name: roomName,
        description: description, category: selectedCategory);
    docRef.set(room).then((value) {
      setState(() {
        isLoading=false;
      });
       Fluttertoast.showToast(msg: 'Room Added Successfully',
          backgroundColor: MyThemeData.colorPrimary,toastLength: Toast.LENGTH_LONG,
           textColor: Colors.white,fontSize: 25);
      Navigator.pop(context);
    });
  }
}
