import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/screens/authenticate/signIn.dart';
import 'package:chat_app/screens/widgets/widgets.dart';
import '../widgets/styles.dart';

String? friendMessage;
late User signedUser;

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int selectedPage = 0;

  void getCurrentFriend(String friendName) {
    try {
      friendMessage = friendName;
      print(friendMessage);
    } catch (e) {
      print(e);
    }
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
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: pink,
            title: Text(
              'Chat',
              style: TextStyle(fontFamily: 'Rubik'),
            ),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text(
                        "Logout",
                        style: TextStyle(color: blue, fontFamily: 'Rubik'),
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    print("logout is selected.");
                    _auth.signOut();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignIn(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          bottomNavigationBar: bottomNavBar(selectedPage: selectedPage, context: context),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _firestore
                .collection('User data')
                .doc(_auth.currentUser!.email)
                .collection('friends')
                .orderBy('user name')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final friendsIdList = [];
              final friendNameList = [];
              if (snapshot.hasData) {
                getCurrentUser();
                final friends = snapshot.data!.docs;
                for (var friend in friends) {
                  final friendId = friend.id;
                  friendsIdList.add(friendId);
                  final friendName = friend.get('user name');
                  friendNameList.add(friendName);
                }
              }

              return ListView.builder(
                itemCount: friendsIdList.length,
                itemBuilder: (context, index) {
                  final friendId = friendsIdList[index];
                  return StreamBuilder(
                    stream: _firestore
                        .collection('User data')
                        .doc(_auth.currentUser!.email)
                        .collection('friends')
                        .doc(friendId)
                        .collection('messages')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, messageSnapshots) {
                      if (messageSnapshots.connectionState ==
                          ConnectionState.waiting) {
                        return SizedBox.shrink();
                      }

                      List<Widget> friendsWidgets = [];
                      if (messageSnapshots.hasData) {
                        // Check if the 'messages' collection exists
                        if (messageSnapshots.data!.docs.isNotEmpty) {
                          final lastMessage = messageSnapshots.data!.docs.last;
                          final lastMessageValue = lastMessage.get('message');
                          final lastMessageSender = lastMessage.get('sender');
                          final lastMessageTime =
                              lastMessage.get('time') as Timestamp?;
                          final formattedTime = lastMessageTime != null
                              ? DateFormat.yMd()
                                  .add_jm()
                                  .format(lastMessageTime.toDate())
                              : "N/A";
                          final friendName = friendNameList[index];
                          final friendEmail = friendsIdList[index];

                          final friendWidget = friendCard(
                            friendName,
                            friendEmail,
                            lastMessageSender,
                            lastMessageValue,
                            formattedTime,
                            context,
                          );

                          friendsWidgets.add(friendWidget);
                        } else {
                          // Display a placeholder or a message for friends with no messages
                          final friendName = friendNameList[index];
                          final friendEmail = friendsIdList[index];

                          final friendWidget = friendCard(
                            friendName,
                            friendEmail,
                            null,
                            "No messages yet", // Placeholder message
                            "N/A",
                            context,
                          );

                          friendsWidgets.add(friendWidget);
                        }
                      } else {
                        // Handle the case where the 'messages' collection doesn't exist
                        final friendName = friendNameList[index];
                        final friendEmail = friendsIdList[index];

                        // Display a placeholder or a message for friends with no messages
                        final friendWidget = friendCard(
                          friendName,
                          friendEmail,
                          null,
                          "No messages yet", // Placeholder message
                          "N/A",
                          context,
                        );

                        friendsWidgets.add(friendWidget);
                      }
                      return Column(children: friendsWidgets);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
