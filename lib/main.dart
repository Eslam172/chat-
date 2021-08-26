import 'package:chat_pract/AppProvider/AppProvider.dart';
import 'package:chat_pract/addRoom/AddRoom.dart';
import 'package:chat_pract/auth/login/LoginScreen.dart';
import 'package:chat_pract/auth/register/RegisterScreen.dart';
import 'package:chat_pract/home/HomeScreen.dart';
import 'package:chat_pract/roomDetails/RoomDetailsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyThemeData {
 static var colorPrimary  = Color.fromRGBO(53, 152, 219, 1.0);
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context)=> AppProvider(),
      builder: (context,widget){
        final provider = Provider.of<AppProvider>(context);
        final isLoggedIn = provider.checkLoggedIn();
        return MaterialApp(
          theme: ThemeData(
              primaryColor: MyThemeData.colorPrimary
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            RegisterScreen.routeName : (context)=> RegisterScreen(),
            LoginScreen.routeName : (context)=> LoginScreen(),
            HomeScreen.routeName : (context)=> HomeScreen(),
            AddRoom.routeName : (context)=> AddRoom(),
            RoomDetailsScreen.routeName : (context)=> RoomDetailsScreen(),
          },
          initialRoute:
          isLoggedIn?
          HomeScreen.routeName
              :LoginScreen.routeName
        );
      },
    );

// finish app
  }
}


