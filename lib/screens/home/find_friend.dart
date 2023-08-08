import 'package:chat_app/screens/widgets/styles.dart';
import 'package:chat_app/screens/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class findFriend extends StatefulWidget {
  const findFriend({Key? key}) : super(key: key);

  @override
  _findFriendState createState() => _findFriendState();
}

class _findFriendState extends State<findFriend> {
  TextEditingController controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Find New Friends Now!',
                    style: TextStyle(
                        fontFamily: 'Rubik', fontSize: 30, color: grey),
                  ),
                  Center(
                    child: textField(
                        icon: Icon(Icons.search),
                        controller: controller,
                        label: 'Find your friend'),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('User data')
                              .orderBy('email')
                              .snapshots(),
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.pink, pink],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                width: width,
                                height: height * 0.75,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: _firestore
                                          .collection('Friend Requests')
                                          .snapshots(),
                                      builder: (context, request) {
                                        List<friendInvitation>
                                            recommendedFriendsList = [];
                                        bool exist;
                                        bool? accepted;
                                        if (snapshot.hasData) {
                                          final recomendedFriends = snapshot
                                              .data!.docs!
                                              .where((element) => element
                                                  .get('user name')
                                                  .toLowerCase()
                                                  .contains(controller.text
                                                      .toLowerCase()));
                                          if (request.hasData) {
                                            final requests =
                                                request.data!.docs!;
                                            if (controller.text.isNotEmpty) {
                                              for (var recommendedFriend
                                                  in recomendedFriends) {
                                                final recommendedName =
                                                    recommendedFriend
                                                        .get('user name');
                                                if (requests.contains(
                                                    recommendedFriend.id)) {
                                                  exist = true;
                                                  final friendRequested =
                                                      (requests.where((element) =>
                                                              element.id ==
                                                              recommendedFriend
                                                                  .id))
                                                          .first
                                                          .get('accepted');
                                                  if (friendRequested == true) {
                                                    accepted = true;
                                                  } else {
                                                    accepted = false;
                                                  }
                                                } else {
                                                  exist = false;
                                                }
                                                final recommended =
                                                    friendInvitation(
                                                        userName:
                                                            recommendedName,
                                                        exist: exist,
                                                        accepted: accepted);
                                                recommendedFriendsList
                                                    .add(recommended);
                                              }
                                            }
                                          }
                                        }
                                        return ListView(
                                          children: recommendedFriendsList,
                                        );
                                      }),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
