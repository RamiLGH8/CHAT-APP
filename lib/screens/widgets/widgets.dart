import 'package:flutter/material.dart';
import '../widgets/styles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class friendCard extends StatelessWidget {
  friendCard(
      {required this.name, required this.lastMessage, required this.lastHour});
  String name;
  String lastMessage;
  String lastHour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            color: pink,
            height: 70,
            child: Row(children: [
              SizedBox(
                width: 5,
              ),
              CircleAvatar(
                backgroundImage: AssetImage('images/avatar.png'),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    Text(lastMessage),
                  ]),
              SizedBox(
                width: 60,
              ),
              Text(lastHour),
            ])),
      ),
    );
  }
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
            color:Color.fromARGB(255, 247, 180, 202),
            size: 50.0,
          ),
        ),
      ),
    ));
  }
}
