import 'dart:ffi';
import 'package:chat_app/screens/home/friend_chat_screen.dart';
import 'package:chat_app/screens/widgets/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/screens/authenticate/createUser.dart' as CreateUser;
import '../widgets/styles.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui; // import dart:ui with a prefix
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chat_screen extends StatefulWidget {
  const chat_screen({Key? key});

  @override
  State<chat_screen> createState() => _chat_screenState();
}

class _chat_screenState extends State<chat_screen> {
  final _auth = FirebaseAuth.instance;
  late User signedUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) signedUser = user;
      print(signedUser.email);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // set to false to remove debug banner
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(title: Text('Chat'), actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Logout"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              print("logout is selected.");
              _auth.signOut();
              Navigator.pop(context);
            }
          }),
        ]),
        body: Column(children: [
          Builder(builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => friend_chat_screen(),
                ),
              ),
              child: friendCard(
                  name: 'Micheal Joshua',
                  lastMessage: 'Just reached my new location mate',
                  lastHour: '14:59'),
            );
          }),
        ]),
      )),
    );
  }
}
