import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/user_model.dart';
import 'package:flutter_application_2/page/sign_in_page.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  late User currentUser;
  Future<UserModel?> register(
      String email, String password, String text, String goal) async {
    String one = email;
    String two = password;
    String name = text;
    String three = goal;

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: one, password: two)
          .then((user) {
        FirebaseFirestore.instance.collection('users').add({
          'id': user,
          'email': one,
          'name': name,
          'goal': three,
          'password': password,
        }).then((document) {
          print('Successfully added user information to Firestore: $document');
          FirebaseFirestore.instance
              .collection('users')
              .doc('users')
              .get()
              .then((DocumentSnapshot ds) {
            // use ds as a snapshot
            return UserModel.fromMap(ds.data());
          });
          // currentUser = user;
          print("user in");
        }).catchError((error) {
          print('Error adding user information to Firestore: $error');
        });
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //Fluttertoast.showToast(msg: 'Logged in Successfully');
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          print("no user in");
        } else {
          FirebaseFirestore.instance
              .collection('users')
              .doc('users')
              .get()
              .then((DocumentSnapshot ds) {
            // use ds as a snapshot
            return UserModel.fromMap(ds.data());
          });
          currentUser = user;
          print("user in");
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Fluttertoast.showToast(msg: 'No user found for that email');
      } else if (e.code == 'wrong-password') {
        //Fluttertoast.showToast(msg: 'Incorrect password for that email');
      }
    }

    // Future<UserModel?> login(String email, String password) async {

    // }

//       String email, String password, String name, String goal) async {
//     try {
//       var body = {
//         'email': email,
//         'password': password,
//         'name': name,
//         'goal': goal,
//       };

//       var response = await http.post(
//         Uri.parse('https://bwa-jobs.herokuapp.com/register'),
//         body: body,
//       );

//       print('cek Status Code Register :${response.statusCode}');
//       print(response.body);

//       //NOTE: KEMBANGKAN STATUS BODY MESSAGE ERROR
//       if (response.statusCode == 200) {
//         return UserModel.fromJson(jsonDecode(response.body));
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print(e);
//       return null;
//     }
  }

  //   signUp(String email, String password) async {

  //     UserCredential userCredential = (await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //           email: email,
  //           password: password,
  //         )
  //         .then((value) => {postDetailsToFirestore()})
  //         .catchError((e) {
  //       Fluttertoast.showToast(msg: e!.message);
  //     })) as UserCredential;

  // }

  // postDetailsToFirestore(
  //     String email, String password, String name, String goal) async {
  //   // if (_image != null) {
  //     String email = 'user@example.com';
  //   String password = 'password';
  //    String name ='your name';
  //    String goal ='your goal';
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   User? user = _auth.currentUser;

  //   UserModel userModel = UserModel(e);

  //   userModel.email = user!.email;
  //   userModel.uid = user.uid;
  //   userModel.fullname = name.text;
  //   userModel.phonenumber = telno.text;
  //   userModel.bloodType = bloodtype.text;
  //   userModel.location = location.text;
  //   userModel.photoURL = null;
  //   userModel.groups = [];

  //   await firebaseFirestore
  //       .collection("users")
  //       .doc(user.uid)
  //       .set(userModel.toMap());
  //   Fluttertoast.showToast(msg: "Account created successfully");
  //   await DataBaseService(uid: user.uid).updateUserRepost(
  //       'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty');
  //   await DatabaseService(uid: user.uid).getUserGroups();
  //   await DataBaseService(uid: user.uid)
  //       .updateDonorHistory('0', '0', '0', '0', '0', '0');
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) =>  SignInPage(),
  //     ),
  //   );
  // } else {
  //   Fluttertoast.showToast(msg: "Add profile pic:");
  // }

  // Future<UserModel?> login(String email, String password) async {
  //   try {
  //     var body = {
  //       'email': email,
  //       'password': password,
  //     };

  //     var response = await http.post(
  //       Uri.parse('https://bwa-jobs.herokuapp.com/login'),
  //       body: body,
  //     );

  //     print('cek Status Code Login :${response.statusCode}');
  //     print(response.body);

  //     //NOTE: KEMBANGKAN STATUS BODY MESSAGE ERROR
  //     if (response.statusCode == 200) {
  //       return UserModel.fromJson(jsonDecode(response.body));
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
// }
}
