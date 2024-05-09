
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Home.dart';
import 'Login.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  Widget build(BuildContext context) {
    return Currentuser();
  }

  Currentuser(){
    final user =  FirebaseAuth.instance.currentUser;

    if(user!= null){
      return HomeScreen();
    }else{
      return Login();
    }

  }
}
