import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/custom_card.dart';
import 'package:flutter_application_2/models/user_model.dart';
import 'package:flutter_application_2/page/home_page.dart';
import 'package:flutter_application_2/page/started_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_application_2/utils/firebase.dart';
import 'package:url_launcher/url_launcher.dart';


//File? _image;
final picker = ImagePicker();

class AccountPage extends StatefulWidget {
  String? userId;
  AccountPage({Key? key, this.userId}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with RouteAware {
  /// Subscribe to RouteObserver
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    // routeObserver.unsubscribe(this);
    // super.dispose();
    var user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StartedPage()),
        );

      
      } else {
        print('User is signed in!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  @override
  void didPush() {
    setVisuals("profile");
  }

  @override
  void didPop() {
    setVisuals("first");
  }

  void setVisuals(String screen) {
    var visual = "{\"screen\":\"$screen\"}";
    //AlanVoice.setVisualState(visual);
  }

  currentUserId() {
    print("${firebaseAuth.currentUser?.uid}");
    return firebaseAuth.currentUser?.uid;
  }

  final _db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  String profilePicLink = "";
  var name;
  var pic;
  var loc;
  var blood;
  var pnum;
  String? fullname = "";
  String? location = "";
  String? bloodType = "";
  String? photoUrl = "";

  void pickUploadProfilePic({String? userId}) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${widget.userId}/images")
        .child("post_$postID");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      loggedInUser.photoURL = value.toString();
      await _db.collection("users").doc("${widget.userId}").update({
        'photoURL': loggedInUser.photoURL,
        // SetOptions(
        //   merge: true,
        // ),
      });
      setState(() {
        profilePicLink = value;
        loggedInUser.photoURL = value.toString();
      });
    });
    print(profilePicLink);
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      //print('hi user');
      if (value.exists) {
        setState(() {
          fullname = value.data()!["fullname"];
          location = value.data()!["location"];
          photoUrl = value.data()!["photoURL"];
          bloodType = value.data()!["bloodType"];
        });
      }
    });
  }

  openwhatsapp() async {
    var whatsapp = "+256";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatappURL_ios =
        "https://wa.me/$whatsapp?text=${Uri.parse("Hi download the JOB link app to get a job.")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp not installed")));
      }
    }
  }


  _onShareWithEmptyFields(BuildContext context) async {
    await Share.share("text");
  }

  @override
  Widget build(BuildContext context) {
    var g = currentUserId();
    
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              // Navigator.pop(context);
            },
            child: Icon(
              Icons.navigate_before_sharp,
              color: Colors.black,
              size: 24.0,
            ),
          ),
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.edit_note_sharp,
                color: Colors.black,
              ),
              onPressed: () {
                // Navigator.pop(context);
              },
            )
          ],
         
        ), // body is the majority of the screen.
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 34,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    /*1*/
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),

                  /*1*/
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: Container(
                  height: 60,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Color.fromARGB(255, 142, 30, 233),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        /*1*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Available for a Job',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      /*3*/
                      Icon(
                        Icons.toggle_on,
                        color: Color.fromARGB(255, 142, 30, 233),
                        size: 50,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Card(
                child: GestureDetector(
                  onTap: () {
                    Share.share(
                        'Download the UG blood donate app: https://ug-blood-donate.github.io/',
                        subject: 'lets save life.');
                    // share();
                    //openwhatsapp();
                  },
                  child: Container(
                    height: 60,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.messenger,
                            color: Color.fromARGB(255, 142, 30, 233)),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Invite a friend",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Card(
                child: GestureDetector(
                  onTap: () {
                    openwhatsapp();
                  },
                  child: Container(
                    height: 60,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.info,
                            color: Color.fromARGB(255, 142, 30, 233)),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Get help",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Card(
                child: Container(
                  height: 60,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.logout_rounded,
                          color: Color.fromARGB(255, 142, 30, 233)),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomCard(
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text('Log out'),
                                  content: Text('Murife dont run dooont run?'),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('No')),
                                    TextButton(
                                      onPressed: () {
                                        firebaseAuth.signOut();
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (_) => StartedPage()));
                                      },
                                      child: Text('Yes'),
                                    )
                                  ],
                                );
                              });
                        },
                        child: const Text(
                          "Sign Out",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));

   
  }
}

_launchURLApp() async {
  var url = Uri.parse("https://paystack.com/pay/ugblooddonate");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

//Making a phonecall
_makingPhoneCall() async {
  var url = Uri.parse("tel:9776765434");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
