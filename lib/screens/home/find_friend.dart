import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FindFriend extends StatefulWidget {
  const FindFriend({Key? key}) : super(key: key);

  @override
  _FindFriendState createState() => _FindFriendState();
}

class _FindFriendState extends State<FindFriend> {
  TextEditingController controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final sendButton = Icon(Icons.send);
  final friend = Icon(Icons.check_circle);
  String searchName = "";
  String? senderName;
  Future<bool> doesDocumentExist(String documentId) async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('User data')
          .doc(_auth.currentUser!.email)
          .collection('friends')
          .doc(documentId)
          .get();
      return documentSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

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
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Find New Friends Now!',
                    style: TextStyle(
                        fontFamily: 'Rubik', fontSize: 30, color: Colors.grey),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: Icon(Icons.search),
                          labelText: 'Find your friend',
                        ),
                        controller: controller,
                        onChanged: (value) {
                          setState(() {
                            searchName = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('User data')
                            .where('user name',
                                isGreaterThanOrEqualTo: searchName)
                            .where('user name', isLessThan: searchName + 'z')
                            .orderBy('user name')
                            .snapshots(),
                        builder: (context, snapshot) {

                          if (snapshot.hasData) {
                            final users = snapshot.data!.docs;

                            List<Widget> userWidgets = [];
                            
                            for (var user in users) {                           
                              if (user['email'] == _auth.currentUser!.email) {
                                senderName = user['user name'];
                              }
                              if (user['email'] != _auth.currentUser!.email) {
                                final userName = user['user name'];
                                final userEmail = user['email'];

                                userWidgets.add(
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/avatar.png'),
                                    ),
                                    title: Text(userName),
                                    subtitle: Text(userEmail),
                                    onTap: () async {
                                      bool userExists =
                                          await doesDocumentExist(userEmail);

                                      if (!userExists) {
                                        Map<String, dynamic> friendRequest = {
                                          'accepted': false,
                                          'sender email':
                                              _auth.currentUser!.email,
                                          'sender name': senderName!,
                                        };
                                        await _firestore
                                            .collection('Friends Requests')
                                            .doc(userEmail)
                                            .set(friendRequest);
                                      }
                                    },
                                    trailing: StreamBuilder<bool>(
                                      stream: doesDocumentExist(userEmail)
                                          .asStream(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data == true) {
                                          return friend;
                                        } else {
                                          return sendButton;
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.pink, Colors.pinkAccent],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                width: width,
                                height: height * 0.75,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ListView(
                                    children: userWidgets,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
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
