// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:mak_past_papers/model/college_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_2/page/viewpdf.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:mak_past_papers/model/pdf_provider.dart';
// import 'package:mak_past_papers/screens/pdfstore.dart';
// import 'package:mak_past_papers/screens/viewpdf.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

final picker = ImagePicker();

class Apply extends StatefulWidget {
  final String company;

  const Apply({required this.company});
  //const Apply({Key? key}) : super(key: key);
  @override
  _ApplyState createState() => _ApplyState();
}

class _ApplyState extends State<Apply> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late Future<ListResult> futureFiles;
  //final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController Name = TextEditingController();
  TextEditingController Gender = TextEditingController();
  TextEditingController AGE = TextEditingController();
  TextEditingController EMAIL = TextEditingController();
  TextEditingController ADDRESS = TextEditingController();
  CollectionReference application =
      FirebaseFirestore.instance.collection('application');
  var storage = FirebaseStorage.instance;
  FilePickerResult? result;
  String name = '';
//late var pdfProvider = Provider.of<pdfprovider>(context,listen: false);
  String pdfurl =
      'https://firebasestorage.googleapis.com/v0/b/papers-1ddd0.appspot.com/o/COCIS%2FComputer%20Science(BCSC)%2FMathematics%20for%20Computer%20Science%2FMPP_Research%20Methodology_Test%20I.pdf?alt=media&token=d5b99e15-1fef-4343-bd5a-5566a57775c0';
//late Future<String> pdfpaths;
  String? changedString;
  late String pdfName;
//late final pdfProvider = Provider.of<pdfprovider>(context,listen: false);
//String paperpath = 'COCIS/Computer Science(BCSC)/'+widget.courseunitname;
  var file;
  //var measure;
  pickpapers() async {
    result = (await FilePicker.platform.pickFiles(
      withReadStream: true,
      allowMultiple: true,
    ))!;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No paper has been selected')));
    }

    file = result!.files.first;
    final path = result!.files.single.path!;
    final fileName = result!.files.single.name;

    uploadfile(path, fileName);
    // loadselectedfiles(result!.files);
    setState(() {
      name = fileName;
    });
  }

  Future<void> uploadfile(String filepath, String fileName) async {
    File file = File(filepath);

    try {
      var snapshot = await storage.ref().putFile(file).whenComplete(() {
        print('==============file uploaded successful=============');
      });
      UploadTask uploadTask =
          (await storage.ref('').putFile(file)) as UploadTask;
      String url = await (snapshot).ref.getDownloadURL();
      application.add({}).then((value) =>
          Fluttertoast.showToast(msg: "Application Submitted").catchError((e) {
            print("Application not sent!!!");
          }));
      print(url);
    } catch (e) {
      print(e);
    }
  }

  void _submit() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('Your event has been created'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset('assets/successful.png'),
                const SizedBox(
                  height: 10,
                ),
                const Text('Your request has been sent'),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Image.asset('assets/back_arr.png'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getImage(Image) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      // maxHeight: 512,
      // maxWidth: 512,
      imageQuality: 90,
    );
    setState(() {
      Image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference create_event =
        FirebaseFirestore.instance.collection('create_event');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              size: 32.0, color: Color(0xff4141A4)),
          onPressed: () => Navigator.pop(context, true),
        ),
        backgroundColor: const Color.fromARGB(255, 254, 255, 255),
        title: const Text(
          "        APPLY HERE",
          style: TextStyle(
            color: Color(0xff4141A4),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextFormField(
                      controller: Name,
                      decoration: const InputDecoration(
                          labelText: 'Name',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          return 'location must contain at least 3 characters';
                        } else if (value
                            .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                          return 'Category TITLE cannot contain special characters';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: Gender,
                      decoration: const InputDecoration(
                          labelText: 'Gender',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          return 'location must contain at least 3 characters';
                        } else if (value
                            .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                          return 'Category TITLE cannot contain special characters';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: EMAIL,
                        decoration: const InputDecoration(
                            labelText: 'Email ',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        //hintText: 'Email',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email cannot be empty";
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please enter a valid email");
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: ADDRESS,
                      decoration: const InputDecoration(
                          labelText: 'ADDRESS',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          return 'location must contain at least 3 characters';
                        } else if (value
                            .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                          return 'Category TITLE cannot contain special characters';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      //color: Color.fromARGB(234, 239, 52, 83),
                      onPressed: () {
                        const CircularProgressIndicator(
                          color: Colors.white,
                        );
                        String company = widget.company;
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          pickpapers();
                        }
                      },
                      child: const Center(child: Text("ATTACH CV")),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 113, 73, 225)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    Center(child: Text("$name")),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      //color: Color.fromARGB(234, 239, 52, 83),

                      child: const Center(child: Text("APPLY")),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 225, 73, 73)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      onPressed: () {
                        onPressed:
                        () {
                          const CircularProgressIndicator(
                            color: Colors.white,
                          );
                          String company = widget.company;
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate() && name != '') {
                            application.add({
                              'Name': Name.text,
                              'Gender': Gender.text,
                              'AGE': AGE.text,
                              'EMAIL': EMAIL.text,
                              'ADDRESS': ADDRESS.text,
                              //'cv': file,
                              // 'note': note.text
                            }).then((value) => Fluttertoast.showToast(
                                        msg:
                                            "Application submitted successfully")
                                    .catchError((e) {
                                  print("Application not");
                                }));
                          }
                        };
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
