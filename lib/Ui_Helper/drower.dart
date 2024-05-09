import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:to_do/Screens/Login.dart';

import '../Screens/Profile.dart';

class drawer {
  static Costum_Drower(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 38.0),
        child: SingleChildScrollView(
          // Wrap the Column with SingleChildScrollView
          child: Column(
            children: [
              // Expanded(child: StreamBuilder(
              //     stream: FirebaseFirestore.instance.doc('Images').snapshots(),
              //
              //     builder: (context , snapshot){
              //       return CircleAvatar(
              //         radius: 50,
              //         backgroundImage: NetworkImage(snapshot.data!['Image Url'],)
              //       );
              //     })),

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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  )),
              TextButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => Login()));
                    } catch (e) {
                      print("Error logging out: $e");
                    }
                  },
                  child: Text('Logout',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24)))
            ],
          ),
        ),
      ),
    );
  }
}
