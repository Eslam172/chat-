import 'package:chat_pract/AppProvider/AppProvider.dart';
import 'package:chat_pract/auth/login/LoginScreen.dart';
import 'package:chat_pract/dataBase/DataBaseHelper.dart';
import 'package:chat_pract/home/HomeScreen.dart';
import 'package:chat_pract/main.dart';
import 'package:chat_pract/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  String userName = '';

  String email = '';

  String password = '';

  late AppProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Image.asset(
            'assets/images/top_bg.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Create Account',style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
            )),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _registerFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          onChanged: (newText) {
                            userName = newText;
                          },
                          decoration: InputDecoration(
                            labelText: 'User Name',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ('Please enter User Name');
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          onChanged: (newText) {
                            email = newText;
                          },
                          decoration: InputDecoration(
                            labelText: 'E-mail Address',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ('Please enter E-mail Address');
                            } else if (
                                (value.contains('.com')) == false) {
                              return 'E-mail badly written';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          onChanged: (newText) {
                            password = newText;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Password',

                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              suffix: Icon(
                                Icons.remove_red_eye,
                                color: MyThemeData.colorPrimary,
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ('Please enter Password');
                            } else if (value.length < 6) {
                              return 'password is too short';
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  child:
                  isLoading?
                      Center(child: CircularProgressIndicator(),):
                  ElevatedButton(
                    onPressed: () {
                      return createAccount();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(MyThemeData.colorPrimary)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Create Account'),
                    ),
                  ),
                ),
                TextButton(onPressed: (){
                  Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                },
                    child: Text('Already have an account',style: TextStyle(
                      fontSize: 16,
                      color: MyThemeData.colorPrimary
                    ),))
              ],
            ),
          ),
        )
      ],
    );
  }
  final db = FirebaseFirestore.instance;

  bool isLoading =false;
  void createAccount() {
    if (_registerFormKey.currentState?.validate() == true) {
      registerUser();
    }
  }

  final auth = FirebaseAuth.instance;

  void registerUser() async {
    setState(() {
      isLoading=true;
    });
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final usersCollectionRef = getUsersCollectionWithConverter();
      final user = Users(id: userCredential.user!.uid,
          userName: userName, email: email);
      usersCollectionRef.doc(user.id).set(user)
          
          .then((value) {
        provider.updateUser(user);

        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      });

      showErrorMessage('user register successfully');
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message ?? 'something went wrong');
      // if (e.code == 'weak-password') {
      //   print('The password provided is too weak.');
      // } else if (e.code == 'email-already-in-use') {
      //   print('The account already exists for that email.');
      // }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading=false;
    });
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }
}
