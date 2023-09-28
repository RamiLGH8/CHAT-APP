import 'package:chat_app/screens/home/chat_screen.dart';
import 'package:chat_app/screens/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui; // import dart:ui with a prefix
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/widgets.dart';
import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';

class friend_chat_screen extends StatefulWidget {
  friend_chat_screen({required this.friendName, required this.friendEmail});
  String friendName;
  String friendEmail;
  @override
  State<friend_chat_screen> createState() => _friend_chat_screenState();
}

class _friend_chat_screenState extends State<friend_chat_screen> {
  @override
  Widget build(BuildContext context) {
    final height_device = ui.window.physicalSize.height;
    final width_device = ui.window.physicalSize.width;

    final _auth = FirebaseAuth.instance;
    TextEditingController message = TextEditingController();
    final senderSnapshots =
        FirebaseFirestore.instance.collection('User data').snapshots();

    final messagesSnapshots = FirebaseFirestore.instance
        .collection('User data')
        .doc(_auth.currentUser!.email)
        .collection('friends')
        .doc(widget.friendEmail)
        .collection('messages')
        .orderBy('time')
        .snapshots();
    final combinedSnapshots = Rx.combineLatest2(
      senderSnapshots,
      messagesSnapshots,
      (QuerySnapshot senderSnapshots, QuerySnapshot messagesSnapshots) {
        return {
          'senderData': senderSnapshots.docs,
          'messagesData': messagesSnapshots.docs,
        };
      },
    );

    void getCurrentUser() {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          print(user.email);
        }
      } catch (e) {
        print(e);
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
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: pink,
          title: Text(widget.friendName),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(),
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
              StreamBuilder<Map<String, List<QueryDocumentSnapshot>>>(
                  stream: combinedSnapshots,
                  builder: (context, snapshot) {
                    List<Widget> messageWidgets = [];
                    if (snapshot.hasData) {
                      getCurrentUser();
                      bool isSender;
                      final sender = snapshot.data!['senderData']!
                          .firstWhere(
                              (element) => element.id == signedUser.email)
                          .get('user name');
                      final messages = snapshot.data!['messagesData']!;
                      for (var message in messages) {
                        final messageText = message.get('message');
                        final currentUser = signedUser.email;
                        if (currentUser == message.get('sender')) {
                          isSender = true;
                        } else {
                          isSender = false;
                        }
                        final messageWidget = messageLine(
                            messageText, sender, widget.friendName, isSender);
                        messageWidgets.add(messageWidget);
                      }
                    } else {
                      return Center(
                        child: Center(
                            child: CircularProgressIndicator(
                                backgroundColor: pink)),
                      );
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
                        controller: message,
                        decoration: InputDecoration(
                          hintText: 'Write your message here...',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async{
                        getCurrentUser();
                       await FirebaseFirestore.instance
                            .collection('User data')
                            .doc(signedUser.email)
                            .collection('friends')
                            .doc(widget.friendEmail)
                            .collection('messages')
                            .add({
                          'message': message.text,
                          'receiver': widget.friendEmail,
                          'sender': signedUser.email,
                          'time': FieldValue.serverTimestamp()
                        });
                       await FirebaseFirestore.instance
                            .collection('User data')
                            .doc(widget.friendEmail)
                            .collection('friends')
                            .doc(signedUser.email)
                            .collection('messages')
                            .add({
                          'message': message.text,
                          'receiver': widget.friendEmail,
                          'sender': signedUser.email,
                          'time': FieldValue.serverTimestamp()
                        });
                        message.clear();
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
