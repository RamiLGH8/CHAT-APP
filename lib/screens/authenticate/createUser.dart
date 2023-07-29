import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app/screens/home/chat_screen.dart';
import '../widgets/styles.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../widgets/widgets.dart';
class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  
  TextEditingController birthDay = TextEditingController();
  final auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  XFile? _image;
  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Create Your Account',
                  style:
                      TextStyle(fontFamily: 'Rubik', fontSize: 45, color: blue),
                ),
              ),
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: _image != null
                        ? FileImage(File(_image!.path)) as ImageProvider<Object>
                        : AssetImage('images/avatar.png'),
                    radius: 64,
                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: pickImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                    bottom: -10,
                    left: 80,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      
                  Padding(
        padding: const EdgeInsets.all(16.0),
      child: TextField(
       controller: email,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          labelText: 'email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: pink,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: blue,
              width: 4,
            ),
          ),
        ),
      ),
    ),
      Padding(
        padding: const EdgeInsets.all(16.0),
      child: TextField(
       controller: password,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: pink,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: blue,
              width: 4,
            ),
          ),
        ),
      ),
    ),
                      SizedBox(height: 20),
                      Builder(builder: (BuildContext context) {
                        return ElevatedButton(
                          onPressed: () async {
                            try {
                              var userCreate =
                                  await auth.createUserWithEmailAndPassword(
                                      email: email.text, password: password.text);
                              var userSignIn =
                                  await auth.signInWithEmailAndPassword(
                                      email: email.text, password: password.text);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => chat_screen(),
                                ),
                              );
                              uploadAvatar();
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 100,
                            ),
                            child: Text(
                              'Create Account',
                              style: TextStyle(fontFamily: 'Rubik'),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: pink,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pickImage() async {
    var img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _image = img;
    });
  }

  uploadAvatar() async {
    final path = 'avatars/${email.text.split('@')[0]}';
    final file = File(_image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }

  addBirthday() async {}
}
