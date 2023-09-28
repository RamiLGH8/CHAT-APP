import 'package:chat_app/screens/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageFriends extends StatefulWidget {
  const ManageFriends({super.key});

  @override
  State<ManageFriends> createState() => _ManageFriendsState();
}

class _ManageFriendsState extends State<ManageFriends> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: pink,
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Friends Requests'),
                  SingleChildScrollView(
                    child: StreamBuilder(
                        stream: _firestore
                            .collection('Friends Requests')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final friendsRequests = snapshot.data!.docs;
                            List<Widget> friendsRequestsWidgets = [];
                            for (var friendRequest in friendsRequests) {
                              final senderEmail =
                                  friendRequest.get('sender email');
                              final senderName =
                                  friendRequest.get('sender name');
                              if (friendRequest.id == _auth.currentUser!.email)
                                friendsRequestsWidgets.add(ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/avatar.png'),
                                    ),
                                    title: Text(senderName.toString()),
                                    subtitle: Text(senderEmail),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await _firestore
                                                .collection('User data')
                                                .doc(_auth.currentUser!.email)
                                                .collection('friends')
                                                .doc(senderEmail)
                                                .set({
                                              'user name': senderName,
                                            });
                                            await _firestore
                                                .collection('User data')
                                                .doc(senderEmail)
                                                .collection('friends')
                                                .doc(_auth.currentUser!.email)
                                                .set({
                                              'user name':
                                                  _auth.currentUser!.email,
                                            });
                                            await _firestore
                                                .collection('User data')
                                                .doc(_auth.currentUser!.email)
                                                .collection('friends')
                                                .doc(senderEmail)
                                                .collection('messages');
                                            await _firestore
                                                .collection('Friends Requests')
                                                .doc(_auth.currentUser!.email)
                                                .delete();
                                    
                                          },
                                          icon: Icon(Icons.check),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await _firestore
                                                .collection('Friends Requests')
                                                .doc(_auth.currentUser!.email)
                                                .delete();
                                          },
                                          icon: Icon(Icons.close),
                                        ),
                                      ],
                                    )));
                            }
                            return ListView(
                              shrinkWrap: true,
                              children: friendsRequestsWidgets.length == 0
                                  ? [
                                      Center(
                                        child: Text('No friends requests'),
                                      )
                                    ]
                                  : friendsRequestsWidgets,
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
