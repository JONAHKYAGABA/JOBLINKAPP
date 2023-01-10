import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/user_model.dart';
import 'package:flutter_application_2/page/sign_in_page.dart';
import 'package:flutter_application_2/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  File? _image;
  final picker = ImagePicker();
  bool showProgress = false;
  bool _isObscure = true;
  bool _isObscure2 = true;
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController telno = TextEditingController();
  TextEditingController bloodtype = TextEditingController();
  TextEditingController location = TextEditingController();

  String? _currentSugars;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'JOB LINK',
        home: Scaffold(
            appBar: null,
            backgroundColor: mainColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: mainColor,
                    ),
                  ),
                  Column(
                    children: [
                      Form(
                        key: _formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 34,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 94,
                                ),
                                Image.asset(
                                  'assets/images/logo.png',
                                  width: 100,
                                  height: 100,
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: name,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.black),
                                      borderRadius: BorderRadius.circular(9.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.black),
                                      borderRadius: BorderRadius.circular(9.0)),
                                  hintText: 'FullName'),
                              keyboardType: TextInputType.name,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.black),
                                      borderRadius: BorderRadius.circular(9.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.black),
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
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: password,
                              obscureText: true,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  suffixIcon: IconButton(
                                      color: Colors.black,
                                      icon: Icon(_isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      }),
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.black),
                                      borderRadius: BorderRadius.circular(9.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.black),
                                      borderRadius: BorderRadius.circular(9.0)),
                                  hintText: 'Password'),
                              validator: (value) {
                                RegExp regex = RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return "Password cannot be empty";
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("please enter valid password min. 6 character");
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: confirmpassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  suffixIcon: IconButton(
                                      color: Colors.black,
                                      icon: Icon(_isObscure2
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure2 = !_isObscure2;
                                        });
                                      }),
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.black),
                                      borderRadius: BorderRadius.circular(9.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.black),
                                      borderRadius: BorderRadius.circular(9.0)),
                                  hintText: 'Confirm password'),
                              validator: (value) {
                                if (password.text != confirmpassword.text) {
                                  return "Password did not match";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(height: 10),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 300,
                                    height: 50,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            showProgress = true;
                                          });
                                          Future.delayed(
                                              const Duration(seconds: 10), (() {
                                            setState(() {
                                              showProgress = false;
                                            });
                                          }));

                                          signUp(
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
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                        ),
                                        child: showProgress
                                            ? const CircularProgressIndicator(
                                                color: Colors.black,
                                              )
                                            : const Text(
                                                'REGISTER',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              )))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return const SignInPage();
                                      }),
                                    );
                                  },
                                  child: const Text(
                                    'Log In.',
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
                    ],
                  ),
                ]),
              ),
            )));
  }

  signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      UserCredential userCredential = (await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => {
                postDetailsToFirestore(),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                )
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      })) as UserCredential;
    }
  }

  postDetailsToFirestore() async {
    // if (_image != null) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = name.text;

    userModel.photoURL = null;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInPage(),
      ),
    );
  }
}
