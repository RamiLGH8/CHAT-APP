import 'dart:ffi';
import 'package:chat_app/screens/authenticate/createUser.dart';
import 'package:chat_app/screens/authenticate/signIn.dart';
import 'package:chat_app/screens/home/chat_screen.dart';
import '../widgets/styles.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui; // import dart:ui with a prefix
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'dart:async';

class welcome extends StatefulWidget {
  const welcome({Key? key});

  @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {
  @override
  Widget build(BuildContext context) {
    final height_device = ui.window.physicalSize.height;
    final width_device = ui.window.physicalSize.width;
    late String phone;
    late String password;
    
    return MaterialApp(
      debugShowCheckedModeBanner: false, // set to false to remove debug banner
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 233, 240, 247),
          body:  Column(
            children: [
              ClipPath(
                clipper: CustomClipper1(),
                child: Container(
                  height: 200,
                  color: pink,
                ),
              ),
              SizedBox(
                height: height_device / 25,
              ),
              Center(
                child: Text(
                  'CHAT APP',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 45,
                    color: blue,
                  ),
                ),
              ),
              Center(
                child: Icon(
                  Icons.message,
                  size: 100,
                  color: pink,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [ 
                      Builder(builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                              Navigator.push(
                               context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal:110 
                            ),
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(fontFamily: 'Rubik'),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: pink,
                          ),
                        );
                      }),
                      Builder(builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                             Navigator.push(
                               context,
                            MaterialPageRoute(builder: (context) => CreateUser()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical:5 ,
                              horizontal:100, 
                            ),
                            child: Text(
                              'REGISTER',
                              style: TextStyle(fontFamily: 'Rubik'),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: blue,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(ui.Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.0017857);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
      size.width * 0.7135417,
      size.height * 0.9901857,
      0,
      size.height,
    );
    path.quadraticBezierTo(
      size.width * 0.2435417,
      size.height * 0.9650000,
      size.width * 0.9741667,
      size.height * 0.8600000,
    );
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
