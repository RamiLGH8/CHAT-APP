import 'package:chat_app/screens/home/chat_screen.dart';
import 'package:chat_app/screens/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui; // import dart:ui with a prefix
import '../widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  bool _saving = false;
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    
  }

 


  @override
  void dispose() {
    
    didChangeDependencies();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width_device = ui.window.physicalSize.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: _saving,
            child: Container(
              width: width_device,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, pink],
              )),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
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
                                        color: blue),
                                  ),
                                  Icon(
                                    Icons.login,
                                    size: 100,
                                    color: blue,
                                  )
                                ],
                              ),
                              Image(image: AssetImage('images/using_phone.png'))
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
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: email,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: 'email',
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              obscureText: true,
                              controller: password,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                labelText: 'password',
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
                          ),
                          Builder(builder: (BuildContext context) {
                            return ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _saving = true;
                                });
                                try {
                                  var user =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email.text,
                                          password: password.text);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => chat_screen()),
                                  );
                                  setState(() {
                                    _saving = false;
                                  });
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
      ),
    );
  }
}
