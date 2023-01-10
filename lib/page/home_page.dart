import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/job.dart';
import 'package:flutter_application_2/models/posted.dart';
import 'package:flutter_application_2/page/account_page.dart';
import 'package:flutter_application_2/page/create_job.dart';
import 'package:flutter_application_2/page/displayjob.dart';
import 'package:flutter_application_2/providers/category_provider.dart';
// import 'package:flutter_application_2/providers/user_provider.dart';
import 'package:flutter_application_2/providers/posted_provider.dart';
import 'package:flutter_application_2/theme.dart';
import 'package:flutter_application_2/widgets/categories_card.dart';
import 'package:flutter_application_2/widgets/posted_card.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      //print('hi user');
      if (value.exists) {
        setState(() {
          var fullname = value.data()!["name"];
        });
      }
    });
    final Stream<QuerySnapshot> _notificationStream = FirebaseFirestore.instance
        .collection("create_event")
        .snapshots(includeMetadataChanges: true);
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _notificationStream = FirebaseFirestore.instance
        .collection("create_event")
        .snapshots(includeMetadataChanges: true);
    final storageRef = FirebaseStorage.instance.ref();
    //var userProvider = Provider.of<UserProvider>(context);
    var categoryProvider = Provider.of<CategoryProvider>(context);
    var postedProvider = Provider.of<PostedProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(children: [
          SizedBox(
            height: 30,
          ),

          //NOTE : PROFILE
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 20,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greetingMessage(),
                      style: lightTextStyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Hello',
                      //userProvider.user.name,
                      style: blackTextStyle.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return AccountPage();
                      }),
                    );
                  },
                  child: Image.asset(
                    'assets/images/user_pic_signup.png',
                    height: 58,
                    width: 58,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          //NOTE: HOT CATEGORIES

          SizedBox(
            height: 30,
          ),
          //NOTE: POSTED
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(left: edge),
              child: Container(
                height: 20,
                width: 20,
                child: Text(
                  'Job Link unvieling new opportunities',
                  style: blackTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 26,
          ),
          Row(
            children: [
              mycard(
                  cardChild:
                      icondata(label: 'OFFERS', icon: Icons.search_sharp),
                  page: jobdetails()),
              // mycard(
              //     cardChild: icondata(label: 'ADD JOB', icon: Icons.add_box),
              //     page: createjob())
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return createjob();
                }),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(left: edge),
              child: Text(
                '',
                style: blackTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

String greetingMessage() {
  var timeNow = DateTime.now().hour;

  if (timeNow <= 11.59) {
    return 'Good Morning';
  } else if (timeNow > 12 && timeNow <= 16) {
    return 'Good Afternoon';
  } else if (timeNow > 16 && timeNow < 20) {
    return 'Good Evening';
  } else {
    return 'Good Night';
  }
}

class mycard extends StatelessWidget {
  final Widget cardChild;
  final Widget page;

  mycard({super.key, required this.cardChild, required this.page});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(15),
        height: 180,
        width: 130,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 248, 247),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: cardChild,
      ),
    );
  }
}

class icondata extends StatelessWidget {
  final String label;
  final IconData icon;

  const icondata({super.key, required this.label, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 40,
          color: Color.fromARGB(234, 105, 52, 239),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
