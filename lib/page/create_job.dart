
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

final picker = ImagePicker();

class createjob extends StatefulWidget {
  const createjob({Key? key}) : super(key: key);
  @override
  _createjobState createState() => _createjobState();
}
class _createjobState extends State<createjob> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _auth = FirebaseAuth.instance;
  late User currentUser;
  TextEditingController jobName = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController Responsibilities = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController Qualifications = TextEditingController();
  TextEditingController contacts = TextEditingController();
  TextEditingController about = TextEditingController();
  int? createdAt;
  int? updatedAt;
  TextEditingController email = TextEditingController();
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
          "        POST A JOB",
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
                      controller: jobName,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.abc_rounded,
                            color: Color(0xff4141A4),
                          ),
                          labelText: 'JOB TITLE',
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
                          return 'JOB TITLE cannot contain special characters';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: category,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.abc_rounded,
                            color: Color(0xff4141A4),
                          ),
                          labelText: 'Category',
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
                      controller: location,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.location_on_rounded,
                            color: Color(0xff4141A4),
                          ),
                          labelText: 'location',
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
                          return 'Location must contain at least 3 characters';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: Qualifications,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.request_page,
                            color: Color(0xff4141A4),
                          ),
                          labelText: 'Qualifications',
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
                          return 'Details must contain at least 3 characters';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: company,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.view_compact_rounded,
                            color: Color(0xff4141A4),
                          ),
                          labelText: 'Company Name',
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
                          return 'Company name must contain at least 3 characters';
                        }
                      },
                    ),
                    TextFormField(
                      controller: Responsibilities,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.home_repair_service_outlined,
                            color: Color(0xff4141A4),
                          ),
                          labelText: 'Responsibilities',
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
                          return 'Details must contain at least 3 characters';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: about,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.add_business_outlined,
                            color: Color(0xff4141A4),
                          ),
                          labelText: 'About',
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
                          return 'Details must contain at least 3 characters';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: date,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.calendar_month,
                            color: Color(0xff4141A4),
                          ),
                          labelText: 'Date',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                          return 'Use only numbers!';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: contacts,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.phone,
                            color: Color(0xff4141A4),
                          ),
                          labelText: 'Contacts',
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
                            value.length < 10) {
                          return 'mobile numcer must contain at least 10 characters';
                        } else if (value.contains(RegExp(r'^[_\-=,\.;]$'))) {
                          return 'Description cannot contain special characters';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                            icon: Icon(
                              Icons.email_outlined,
                              color: Color(0xff4141A4),
                            ),
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
                    ElevatedButton(
                      //color: Color.fromARGB(234, 239, 52, 83),
                      onPressed: () {
                        const CircularProgressIndicator(
                          color: Colors.white,
                        );

                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          create_event.add({
                            'jobName': jobName.text,
                            'category': category.text,
                            'company': company.text,
                            'Reponsibilities': Responsibilities.text,
                            'Qualifications': Qualifications.text,
                            'location': location.text,
                            'email': email.text,
                            'contacts': contacts.text,
                            'about': about.text,
                            //'imageUrl': imageUrl,
                            //'companyLogo': companylogo,
                            'createdAt': DateTime.now().toString(),
                            'updatedAt': DateTime.now().toString(),
                            // 'note': note.text
                          }).then((value) => Fluttertoast.showToast(
                                      msg: "Job added successfully")
                                  .catchError((e) {
                                print("Job not creaetd");
                              }));
                          Navigator.pop(context, true
                              );
                        }
                      },
                      child: const Center(child: Text("ADD JOB")),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 225, 73, 73)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
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


