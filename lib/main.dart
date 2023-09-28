import 'package:chat_app/screens/authenticate/createUser.dart';
import 'package:chat_app/screens/authenticate/signIn.dart';
import 'package:chat_app/screens/home/find_friend.dart';
import 'package:chat_app/screens/home/manage_friends.dart';
import 'package:chat_app/screens/home/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/screens/home/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      // Check if the user is already authenticated and set the initial route accordingly
      initialRoute: _auth.currentUser != null ? '/chat' : '/welcomeScreen',
      routes: {
        '/welcomeScreen': (context) => welcome(),
        '/chat': (context) => ChatScreen(),
      },
      debugShowCheckedModeBanner: false, // set to false to remove debug banner
     
    );
  }
}
