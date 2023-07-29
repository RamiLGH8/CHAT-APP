import 'package:chat_app/screens/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class friend_chat_screen extends StatefulWidget {
  const friend_chat_screen({super.key});

  @override
  State<friend_chat_screen> createState() => _friend_chat_screenState();
}

class _friend_chat_screenState extends State<friend_chat_screen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea
      (child: Scaffold(appBar: AppBar(backgroundColor: pink,
      actions: [
             Row(
              children: [
                Image(image: AssetImage('images/avatar.png'))
              ],
             )
      ], 
      
      ),

      )
      ),
    );
  }
}