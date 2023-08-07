import 'package:chat_app/screens/home/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../home/friend_chat_screen.dart';
import '../widgets/widgets.dart';
import '../widgets/styles.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);
  
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Add a listener to the animation to trigger a loop when it completes.
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    // Start the animation.
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToChatScreen() async {
    // Simulate a delay for demonstration purposes.
    await Future.delayed(Duration(seconds: 3));
                        
    Navigator.push(
      context,
      
      MaterialPageRoute(
          builder: (context) => chat_screen(
                
              )),
    );
                         
  }

  Widget _buildDefaultUI(double width) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        
      ),
      home: SafeArea(
        child: Scaffold(
          body: Container(
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, pink],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 18,
                  ),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (BuildContext context, Widget? child) {
                      return Opacity(
                        opacity: _animation.value,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 60,
                                    color: blue,
                                  ),
                                ),
                                Icon(
                                  Icons.login,
                                  size: 100,
                                  color: blue,
                                )
                              ],
                            ),
                            Image(
                              image: AssetImage('images/using_phone.png'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: textField(icon: Icon(Icons.email), controller: email, label: 'email')
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: textField(icon: Icon(Icons.lock), controller: password, label: 'password')
                        ),
                        Builder(builder: (BuildContext context) {
                          return ElevatedButton(
                            onPressed: () async {
                              try {
                                var user = await _auth.signInWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                                setState(() {
                                  _isLoading = true;
                                });
                              
                                await _navigateToChatScreen();
                                  
                              } catch (e) {
    
                                print(e);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 100,
                              ),
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(fontFamily: 'Rubik'),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: blue,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width_device = ui.window.physicalSize.width;
    return _isLoading
        ? LoadingPage()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: _buildDefaultUI(width_device),
          );
  }
}
