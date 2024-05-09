import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Textfields.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(
      {super.key,
      required this.Gender,
      required this.password,
      required this.id});
  final id;
  final Gender;
  final password;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController editGender = TextEditingController();
  TextEditingController editpassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {});
    editGender.text = widget.Gender;
    editpassword.text = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EDIT PROFILE',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Costum.textField(
                widget.Gender.toString(), editGender, TextInputType.text),
            Costum.textField(
                widget.password.toString(), editpassword, TextInputType.text),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("Profile")
                      .doc(widget.id)
                      .update({
                    "Gender": editGender.text.toString(),
                    "Password": editpassword.text.toString(),
                  });
                  Navigator.pop(context);
                },
                child: Text('Update'))
          ]),
    );
  }
}
