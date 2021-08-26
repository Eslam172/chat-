import 'package:chat_pract/AppProvider/AppProvider.dart';
import 'package:chat_pract/auth/register/RegisterScreen.dart';
import 'package:chat_pract/dataBase/DataBaseHelper.dart';
import 'package:chat_pract/home/HomeScreen.dart';
import 'package:chat_pract/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  late AppProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    double size = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Image(
            image: AssetImage('assets/images/top_bg.png'),
            width: double.infinity,
            fit: BoxFit.fill,
            height: double.infinity,
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Login',style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: size * .02,
                ),
                Form(
                    key: _loginKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            onChanged: (newText) {
                             email=newText;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'E-mail',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please enter E-mail Address';
                              } else if (value.contains('.com') == false) {
                                return ' E-mail Address badly written';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                              onChanged: (newText) {
                                password=newText;
                              },
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  suffix: Icon(
                                    Icons.remove_red_eye,
                                    color: MyThemeData.colorPrimary,

                                  )),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ('Please enter Password');
                                } else if (value.length < 6) {
                                  return 'Password is too short';
                                }
                                return null;
                              }),
                          SizedBox(
                            height: size * .01,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forget password?',style: TextStyle(
                              color: MyThemeData.colorPrimary
                            ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child:
                            isLoading? Center(child: CircularProgressIndicator(),)
                            :
                            ElevatedButton(
                                onPressed: () {
                                  loginAccount();

                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(MyThemeData.colorPrimary)
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Login',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: size * .2,
                                      ),
                                      Icon(Icons.arrow_forward)
                                    ],
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: size * .01,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(RegisterScreen.routeName);
                              },
                              child: Text(
                                'Or Create My Account',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 16,
                                color: MyThemeData.colorPrimary
                                ),
                              )),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }
  bool isLoading = false;

  void loginAccount() {
    if (_loginKey.currentState?.validate() == true) {
      loginUser();
    }
  }
  final auth =FirebaseAuth.instance;
  void loginUser()async{
    setState(() {
      isLoading=true;
    });
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,

      );
      if(userCredential.user==null){
        showMessage('something went wrong');
      }else {
         getUsersCollectionWithConverter().doc(userCredential.user!.uid)
            .get().then((retUser) {
              provider.updateUser(retUser.data());
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);

        });
      }
      showMessage('user login successfully');
    } on FirebaseAuthException catch (e) {

      showMessage(e.message??'something went wrong');
      // if (e.code == 'user-not-found') {
      //   print('No user found for that email.');
      // } else if (e.code == 'wrong-password') {
      //   print('Wrong password provided for that user.');
      // }
    }
    setState(() {
      isLoading=false;
    });
  }
  void showMessage(String message){
    showDialog(context: context,
        builder: (buildContext){
      return AlertDialog(
        content: Text(message),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          },
              child: Text('ok'))
        ],
      );
        });
  }
}
