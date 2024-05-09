import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Textfields.dart';

class EditTask extends StatefulWidget {
  const EditTask(
      {super.key,
      required this.title,
      required this.description,
      required this.id});
  final id;
  final title;
  final description;
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController editTitle = TextEditingController();
  TextEditingController editDesc = TextEditingController();

  @override
  void initState() {
    super.initState();
    editTitle.text = widget.title;
    editDesc.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Costum.textField(
                widget.title.toString(), editTitle, TextInputType.text),
            Costum.textField(
                widget.description.toString(), editDesc, TextInputType.text),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("Task")
                      .doc(widget.id)
                      .update({
                    "Description": editDesc.text.toString(),
                    "Title": editTitle.text.toString(),
                  });
                  Navigator.pop(context);
                },
                child: Text('Update'))
          ]),
    );
  }
}
