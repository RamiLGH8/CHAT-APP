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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // set to false to remove debug banner
      home: SafeArea(
          child: Scaffold(
        body: Column(children: [
          Text(
            'Chat',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 48,
              color: blue,
            ),
          ),
          GestureDetector(
            onTap:() =>  Navigator.push(context, MaterialPageRoute(builder: (context) =>friend_chat_screen())),
                            
            child: friendCard(name: 'Micheal Joshua', lastMessage: 'Just reached my new location mate', lastHour: '14:59'),
          ),
       
        ]),
      )),
    );
  }
}
