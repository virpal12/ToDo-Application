import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/Ui_Helper/Snackbar.dart';

import '../Ui_Helper/Textfields.dart';
import 'Home.dart';
import 'Sign_Up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade200,
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: SingleChildScrollView(
            physics:
                ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Costum.textField('Enter your email', email,
                          TextInputType.emailAddress),
                      SizedBox(
                        height: 10,
                      ),
                      Costum.textField('Enter your password', password,
                          TextInputType.visiblePassword),
                      SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          LoginUser();
                        },
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(300, 50)),
                      ),
                      SizedBox(
                        height: 42,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Are you not Registered ?',
                            style: TextStyle(fontSize: 17),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SignUP()));
                              },
                              child: Text(
                                'Register here',
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ))
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  LoginUser() async {
    if (email == "" && password == "") {
      return snackbar.snack_bar(
          context, 'Ohhh!!!', 'Enter Required Details', ContentType.warning);
    } else {
      UserCredential? usercredential;
      try {
        usercredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.text, password: password.text)
            .then(
              (value) => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => HomeScreen())),
            );
        final pref = await SharedPreferences.getInstance();
        pref.setString('Email', email.text.toString());
        snackbar.snack_bar(
            context, 'Create your Task', 'Welcome to APP', ContentType.success);
      } on FirebaseAuthException catch (ex) {
        return snackbar.snack_bar(context, 'Sorry Dear',
            'First Register Yourself ', ContentType.warning);
      }
    }
  }
}
