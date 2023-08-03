import 'package:chat_app/screens/home/chat_screen.dart';
import 'package:chat_app/screens/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui; // import dart:ui with a prefix
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/widgets.dart';

class friend_chat_screen extends StatefulWidget {
  const friend_chat_screen({super.key});

  @override
  State<friend_chat_screen> createState() => _friend_chat_screenState();
}

class _friend_chat_screenState extends State<friend_chat_screen> {
  @override
  Widget build(BuildContext context) {
    final height_device = ui.window.physicalSize.height;
    final width_device = ui.window.physicalSize.width;
    late User signedUser;
    String? message;
    final _auth = FirebaseAuth.instance;
    final _firestore = FirebaseFirestore.instance;
    void getCurrentUser() {
      try {
        final user = _auth.currentUser;
        if (user != null) signedUser = user;
        print(signedUser.email);
      } catch (e) {
        print(e);
      }
    }

    void messageStream() async {
      await for (var snapshots
          in _firestore.collection('messages').snapshots()) {
        for (var messages in snapshots.docs) {
          print(messages.data());
        }
      }
    }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      getCurrentUser();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: pink,
          title: Text('Name'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => chat_screen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.clear,
                  color: blue,
                ))
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('messages').snapshots(),
                  builder: (context, snapshot) {
                    List<Text> messageWidgets = [];
                    if (snapshot.hasData) {
                      final messages = snapshot.data!.docs!;
                      for (var message in messages) {
                        final messageText = message.get('message');
                        final messageSender = message.get('sender');
                        final messageWidget =
                            Text(messageText + ' ' + messageSender);
                        messageWidgets.add(messageWidget);
                      }
                    } 
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          children: messageWidgets,
                        ),
                      ),
                    );
                  }),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                    color: pink,
                    width: 2,
                  )),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          message = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Write your message here...',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        getCurrentUser();
                        _firestore.collection('messages').add({
                          'message': message,
                          'sender': signedUser.email,
                        });
                      },
                      child: Text('send'),
                      style: TextButton.styleFrom(),
                    )
                  ],
                ),
              ),
            ]),
      )),
    );
  }
}
