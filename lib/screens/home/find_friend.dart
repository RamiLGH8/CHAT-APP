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
  final waitingResonse = Icon( Icons.timer, );
  String searchName = "";
  

Future<bool> doesDocumentExist(String collectionName, String documentId) async {
  try {
    final DocumentSnapshot documentSnapshot =
        await _firestore.collection('User data').doc(_auth.currentUser!.email).collection(collectionName).doc(documentId).get();
    return documentSnapshot.exists;
  } catch (e) {
    print('Error checking document existence: $e');
    return false;
  }
}

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
      // ... (your MaterialApp configuration)
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
                    child: TextField(
                      decoration: InputDecoration(
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
                                  trailing: IconButton(
                                      icon: doesDocumentExist('friends', userEmail)==false?sendButton:friend, onPressed: () {}),
                                  // Add functionality to add the user as a friend
                                  onTap: () {
                                    Map<String, dynamic> friendRequest = {
                                      'accepted': false,
                                      'sender': userEmail
                                    };
                                    _firestore
                                        .collection('Friends Requests')
                                        .doc(userEmail)
                                        .set(friendRequest);
                                  },
                                ),
                              );
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
                          return CircularProgressIndicator();
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
