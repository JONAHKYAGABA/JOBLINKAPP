// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/page/ForgotPassword.dart';
import 'package:flutter_application_2/page/home_page.dart';
import 'package:flutter_application_2/page/main_page.dart';
import 'package:flutter_application_2/page/sign_up_page.dart';
import 'package:flutter_application_2/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:ug_blood_donate/components/buttom_navigation_left_button.dart';
//import 'package:ug_blood_donate/screens/first_screens/ForgotPassword.dart';
//import '../../home.dart';
//import 'register.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool showProgress = false;

  bool _isObscure3 = true;

  bool visible = false;
  final _auth = FirebaseAuth.instance;
  late User currentUser;
  final _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void initState() {
    // var user = FirebaseAuth.instance.authStateChanges().listen((user) {
    // //   if (user == null) {
    // //     print('User is currently signed out!');
    // //   } else {
    // //     print('User is signed in!');

    // //     Navigator.pushReplacement(
    // //       context,
    // //       MaterialPageRoute(
    // //         builder: (context) => Home(
    // //           currentUser: user,
    // //         ),
    // //       ),
    // //     );
    // //   }
    // //   ;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for
    // the major Material Components.
    return MaterialApp(
        title: 'ug_donate_blood',
        home: SafeArea(
          child: Scaffold(
              appBar: null,
              backgroundColor: mainColor,
              // body is the majority of the screen.
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 34,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 100,
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              prefixIcon: const Icon(
                                Icons.mail_outlined,
                                color: Colors.black,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Color(0xff272C2F)),
                                  borderRadius: BorderRadius.circular(9.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Color(0xff272C2F)),
                                  borderRadius: BorderRadius.circular(9.0)),
                              hintText: 'Email'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          controller: password,
                          obscureText: _isObscure3,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              suffixIcon: IconButton(
                                  color: Colors.black,
                                  icon: Icon(_isObscure3
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure3 = !_isObscure3;
                                    });
                                  }),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Color(0xff272C2F)),
                                  borderRadius: BorderRadius.circular(9.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Color(0xff272C2F)),
                                  borderRadius: BorderRadius.circular(9.0)),
                              hintText: 'Password'),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  const CircularProgressIndicator(
                                    color: Colors.white,
                                  );
                                  setState(() {
                                    showProgress = true;
                                  });
                                  Future.delayed(const Duration(seconds: 3),
                                      (() {
                                    setState(() {
                                      showProgress = false;
                                    });
                                  }));
                                  signIn(
                                    email.text,
                                    password.text,
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                                child: showProgress
                                    ? const CircularProgressIndicator(
                                        color: Colors.black,
                                      )
                                    : const Text(
                                        'LOG IN',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return const ForgotPassword();
                                  }),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.grey[70],
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return const SignUpPage();
                                  }),
                                );
                              },
                              child: const Text(
                                'Register Now.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ));
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Fluttertoast.showToast(msg: 'Logged in Successfully');
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user == null) {
            print("no user in");
          } else {
            currentUser = user;
            print("user in");
          }
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(msg: 'No user found for that email');
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(msg: 'Incorrect password for that email');
        }
      }
    }
  }
}
