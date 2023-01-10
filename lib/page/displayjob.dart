import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/posted_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class jobdetails extends StatefulWidget {
  @override
  _jobdetailsState createState() => _jobdetailsState();
}

class _jobdetailsState extends State<jobdetails> {
  // String? note;
  // String? contact;
  // String? pic;
  String? jobtitle;
  String? company;
  String? location;
  String? applicationdeadline;
  String? QualificationsandDetials;
  String? contacts;
  String? email;

  final Stream<QuerySnapshot> _notificationStream = FirebaseFirestore.instance
      .collection("create_event")
      .snapshots(includeMetadataChanges: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.navigate_before_sharp,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: const Text(
          "Jobs",
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
        //foregroundColor: Colors.black,
        //backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: _notificationStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return PostedCard(
                  data['jobName'],
                  data['company'],
                  data['about'],
                  data['location'],
                  data['Qualifications'],
                  data['Reponsibilities']);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget listOfTweets(contact, note, location, param3) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tweetAvatar(),
          tweetBody(note, location),
        ],
      ),
    );
  }

  Widget tweetAvatar() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(contacts!),
        ));
  }

  Widget tweetBody(String description, location) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tweetHeader(location),
          tweetText(description),
          SizedBox(height: 25),
          tweetButtons(),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget tweetHeader(username) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5.0),
          child: Text(
            "UG Blood Donate",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
        ),
        Text(
          '@ ',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Text(
          username,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Text(
          ' ·5m ',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.angleDown,
            size: 14.0,
            color: Colors.grey,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget tweetText(String description) {
    return Text(
      description,
      overflow: TextOverflow.clip,
    );
  }

  Widget tweetButtons() {
    return Text(
      "",
      overflow: TextOverflow.clip,
    );
  }
}
