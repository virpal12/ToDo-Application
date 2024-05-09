import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Screens/Home.dart';
import 'package:to_do/Ui_Helper/Textfields.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Costum.textField('Title', title, TextInputType.text),
            SizedBox(
              height: 15,
            ),
            Costum.textField('Description', desc, TextInputType.text),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () {
                  Task(title.text.toString(), desc.text.toString());
                },
                child: Text('Add Task'))
          ],
        ),
      ),
    );
  }

  Task(String title, String desc) async {
    if (title == "" && desc == "") {
      log("message");
    } else {
      FirebaseFirestore.instance.collection("Task").doc(title).set({
        "Title": title,
        "Description": desc,
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }
}
