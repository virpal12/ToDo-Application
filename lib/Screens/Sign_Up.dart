import 'dart:developer';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/Ui_Helper/Snackbar.dart';

import '../Ui_Helper/Textfields.dart';
import 'Login.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  File? pickedImage;

  String? selectedGender;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  Signup() async {
    if (email == "" && pass == "") {
      return snackbar.snack_bar(
          context, 'Ohhh!!!', 'Enter Required Details', ContentType.warning);
    } else {
      UserCredential? usercredential;
      try {
        usercredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text, password: pass.text)
            .then((value) => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Login())));

        final pref = await SharedPreferences.getInstance();
        pref.setString('Email', email.text.toString());
      } on FirebaseAuthException catch (ex) {
        return ex.code.toString();
      }
    }
  }

  addUser(String selectedGender, String name, String email, String pass) async {
    if (name == "" && email == "" && pass == "") {
      log("message");
    } else {
      FirebaseFirestore.instance.collection("Profile").doc().set({
        "Name": name.toString(),
        "Email": email.toString(),
        "Password": pass.toString(),
        "Gender": selectedGender.toString(),
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Data();
  }

  String MyImage = "";

  Data() async {
    final pref = await SharedPreferences.getInstance();
    MyImage = pref.getString('Email')!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(60),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      pickedImage ?? File(""),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextButton(
                onPressed: () {
                  Show();
                  auth();
                },
                child: const Text(
                  'Upload Image',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Costum.textField('Enter Your Name', name, TextInputType.name),
              const SizedBox(
                height: 10,
              ),
              Costum.textField(
                  'Enter Your EMAIL ', email, TextInputType.emailAddress),
              const SizedBox(
                height: 10,
              ),
              Costum.textField(
                  'Enter Your Password', pass, TextInputType.visiblePassword),
              const SizedBox(height: 20),
              const Text(
                'Gender',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                    value: 'male',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value.toString();
                      });
                    },
                  ),
                  const Text('Male'),
                  Radio(
                    value: 'female',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value.toString();
                      });
                    },
                  ),
                  const Text('Female'),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  Signup();
                  addUser(selectedGender!, name.text, email.text, pass.text);
                },
                child: const Text(
                  'SignUP',
                  style: TextStyle(fontSize: 23),
                ),
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(300, 50)),
              ),
              const SizedBox(
                height: 42,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Already Login ?',
                    style: TextStyle(fontSize: 17),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const Login()));
                      },
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  auth() {
    if (pickedImage == null) {
      return const Text('Image not Uploded');
    } else {
      return uploadImage();
    }
  }

  Show() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick Image From'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  title: const Text('Camera'),
                  leading: const Icon(Icons.camera_alt),
                ),
                ListTile(
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  title: const Text('Gallery'),
                  leading: const Icon(Icons.image),
                ),
              ],
            ),
          );
        });
  }

  pickImage(ImageSource imageSource) async {
    final photo = await ImagePicker().pickImage(source: imageSource);

    try {
      if (photo == null) return;
      final tempImage = File(photo.path);

      setState(() {
        pickedImage = tempImage;
        uploadImage();
      });
    } catch (ex) {
      return ex.toString();
    }
  }

  Future uploadImage() async {
    final Reference storageRef = FirebaseStorage.instance.ref();

    final imagesRef = storageRef.child("images/$MyImage");

    String name = pickedImage!.path.split("/").last;

    await imagesRef.child(name).putFile(File(pickedImage!.path));

    String imageURL = await imagesRef.child(name).getDownloadURL();

    FirebaseFirestore.instance
        .collection("Images")
        .doc(MyImage)
        .set({"Name": name, "Image Url": imageURL}).then(
            (value) => const Text('Image Uploaded'));
    return imageURL;
  }
}
