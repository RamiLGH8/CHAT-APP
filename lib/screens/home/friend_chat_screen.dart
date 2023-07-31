import 'package:chat_app/screens/home/chat_screen.dart';
import 'package:chat_app/screens/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:ui' as ui; // import dart:ui with a prefix

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
                child: Icon(Icons.clear,
                    color: blue,
                ))
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(),
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
                        decoration: InputDecoration(
                          hintText: 'Write your message here...',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
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
