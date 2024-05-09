import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Ui_Helper/Edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MY PROFILE'),),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Profile").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 178.0),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            height: 300,
                            width: 350,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(snapshot.data!.docs[index]['Gender']),

                                Text(snapshot.data!.docs[index]['Email']),

                                Text(snapshot.data!.docs[index]['Name']),

                                Text(snapshot.data!.docs[index]['Password']),

                                SizedBox(height: 20,),

                                ElevatedButton(onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProfile(Gender:snapshot.data!.docs[index]['Gender'], password:snapshot.data!.docs[index]['Password'], id: snapshot
    .data!.docs[index].id,)));
                                }, child: Text('Edit Profile'))



                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasData) {
              return Center(
                child: Text(snapshot.hasError.toString()),
              );
            } else {
              return Center(
                child: Text('No Data Found'),
              );
            }
          }),
    );
  }
}
