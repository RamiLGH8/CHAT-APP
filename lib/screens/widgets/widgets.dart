import 'package:chat_app/screens/home/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../widgets/styles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../home/friend_chat_screen.dart';

Widget friendCard(String name, String email, String? lastMessageSender,
    String? lastMessage, String? lastMessageTime, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => friend_chat_screen(
                    friendName: name,
                    friendEmail: email,
                  )) // Use PascalCase for class names
          );
    },
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              color: pink,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('images/avatar.png'),
                ),
                title: Text(name),
                subtitle: lastMessage == 'No messages yet'
                    ? Text(lastMessage!)
                    : (name == lastMessageSender
                        ? Text('$lastMessageSender: $lastMessage')
                        : Text('You: $lastMessage')),
                trailing: Text(lastMessageTime == null ? '' : lastMessageTime),
              )),
        )),
  );
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            body: Center(
              child: SpinKitWave(
                color: Color.fromARGB(255, 247, 180, 202),
                size: 50.0,
              ),
            ),
          ),
        ));
  }
}

Widget messageLine(
    String message, String sender, String receiver, bool isSender) {
  return Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(isSender ? sender : receiver),
        Material(
          color: isSender ? pink : blue,
          elevation: 5,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
            topRight: isSender ? Radius.circular(0) : Radius.circular(30),
            topLeft: isSender ? Radius.circular(30) : Radius.circular(0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(message),
          ),
        )
      ],
    ),
  );
}

class textField extends StatelessWidget {
  textField({
    required this.icon,
    required this.controller,
    required this.label,
  });
  Icon icon;
  TextEditingController controller;
  String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: pink,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: blue,
              width: 4,
            ),
          ),
        ),
      ),
    );
  }
}

Widget bottomNavBar(
    {required int selectedPage, required BuildContext context}) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
        backgroundColor: Colors.white,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
        backgroundColor: Colors.white,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Requests',
        backgroundColor: Colors.white,
      ),
    ],
    selectedItemColor: blue,
    backgroundColor: pink,
    currentIndex: selectedPage,
    onTap: ((index) {
      selectedPage = index;
      switch (index) {
        case 0:
          // Navigator.popUntil(context, (route) => !route.isCurrent);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => const Home()));

          break;
        case 1:
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => const Home()));
          Navigator.pushNamed(context, '/chat');
          break;
        case 2:
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => const Home()));
          
          break;

        default:
      }
    }),
  );
}
