import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Ui_Helper/Edit_task.dart';
import 'Login.dart';
import 'Profile.dart';
import 'Task.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localstoredata();
  }

  String MyImage = "";

  localstoredata() async {
    final pref = await SharedPreferences.getInstance();
    final storedEmail = pref.getString('Email');
    if (storedEmail != null && storedEmail.isNotEmpty) {
      setState(() {
        MyImage = storedEmail;
      });
    } else {
      // Handle the case where the 'Email' key is not found or is empty
    }
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TO DO LIST',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade400,
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 38.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Images")
                        .doc(MyImage)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(snapshot.data!["Image Url"]),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
                SizedBox(
                  height: 19,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context as BuildContext,
                          MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: Text(
                      'My Profile',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    )),
                TextButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Login()));
                      } catch (e) {
                        print("Error logging out: $e");
                      }
                    },
                    child: Text('Logout',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)))
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Task").snapshots(),
                builder: (BuildContext context, snapshot) {
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5.0),
                          child: Card(
                            elevation: 2,
                            child: Row(
                              children: [
                                Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    }),
                                SizedBox(
                                  width: 6,
                                ),
                                Column(children: [
                                  Text(snapshot.data!.docs[index]['Title']),
                                  Text(snapshot.data!.docs[index]
                                      ['Description']),
                                ]),
                                SizedBox(
                                  width: 170,
                                ),
                                Flexible(
                                  child: PopupMenuButton(
                                      onSelected: (value) {
                                        if (value == 1) {
                                          FirebaseFirestore.instance
                                              .collection("Task")
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .delete();
                                        }

                                        if (value == 0) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditTask(
                                                          id: snapshot.data!
                                                              .docs[index].id,
                                                          title: snapshot.data!
                                                                  .docs[index]
                                                              ['Title'],
                                                          description: snapshot
                                                                  .data!
                                                                  .docs[index][
                                                              'Description'])));
                                        }
                                      },
                                      icon: Icon(Icons.more_vert),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 0,
                                              child: ListTile(
                                                leading: Icon(Icons.edit),
                                                title: Text('Edit'),
                                              ),
                                            ),
                                            PopupMenuItem(
                                                value: 1,
                                                child: ListTile(
                                                  leading: Icon(Icons.delete),
                                                  title: Text('delete'),
                                                ))
                                          ]),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ToDo()));
        },
      ),
    );
  }
}
