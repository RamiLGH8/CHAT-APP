import 'package:chat_app/screens/authenticate/createUser.dart';
import 'package:chat_app/screens/authenticate/signIn.dart';
import 'package:chat_app/screens/home/friend_chat_screen.dart';
import 'package:chat_app/screens/widgets/styles.dart';
import 'package:chat_app/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/screens/home/chat_screen.dart';
import './screens/wrapper/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp ());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: pink,
        
      ),
      debugShowCheckedModeBanner: false, // set to false to remove debug banner
      home: wrapper(),
    );
  }
}
