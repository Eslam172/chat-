import 'package:chat_pract/dataBase/DataBaseHelper.dart';
import 'package:chat_pract/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppProvider extends ChangeNotifier{
  Users? currentUser;

  bool checkLoggedIn(){
    final fireBaseUser=FirebaseAuth.instance.currentUser;
    if(fireBaseUser!=null){
       getUsersCollectionWithConverter().doc(fireBaseUser.uid).get()
      .then((retUser) {
        if(retUser.data()!=null){
          currentUser=retUser.data();
        }
      });
    }
    return fireBaseUser!=null;
  }
  void updateUser(Users? user){
    currentUser=user;
    notifyListeners();
  }
}