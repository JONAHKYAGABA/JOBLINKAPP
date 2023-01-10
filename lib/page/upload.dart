// ignore_for_file: library_prefixes

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_sentiment/dart_sentiment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/models/user_model.dart';
import 'package:flutter_application_2/utils/firebase.dart';
import 'package:flutter_application_2/widgets/indicators.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:ug_blood_donate/home.dart';
// import 'package:ug_blood_donate/models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;
//import 'package:ug_blood_donate/widgets/indicators.dart';

// Future<Placemark> getloca() async {
//   // await Geolocator.openAppSettings();
//   // await Geolocator.openLocationSettings();
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
//   List<Placemark> placemarks =
//       await placemarkFromCoordinates(position.latitude, position.longitude);
//   return placemarks[0];
// }

class Upload extends StatefulWidget {
  User currentUser;
  Upload({super.key, required this.currentUser});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final storageRef = FirebaseStorage.instance.ref();

  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? file;
  bool isUploading = false;
  String postId = const Uuid().v4();
  var analysis = 0;
  final sentiment = Sentiment();
  var string = 'Write a Caption';

  File? image;
  String? fullname = "";
  String? location = "";
  String? bloodType = "";
  String? photoUrl = "";

  handleChooseFromGalley() async {
    // Navigator.pop(context);
    // var image = await _picker.pickImage(
    //   source: ImageSource.gallery,
    //   maxHeight: 675,
    //   maxWidth: 960,
    // );
    // if (mounted) {
    //   setState(() {});
    // }
    // file = File(image!.path);
    try {
      var image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 675,
        maxWidth: 960,
      );
      if (image == null) return;
      file = File(image.path);
      setState(() {});
    } on PlatformException catch (e) {}
  }

  handleTakePhoto() async {
    //Navigator.pop(context);
    try {
      var image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 675,
        maxWidth: 960,
      );
      if (image == null) return;
      file = File(image.path);
      setState(() {});
    } on PlatformException catch (e) {}
  }

  selectImage(parentcontext) {
    return showDialog(
        context: parentcontext,
        builder: ((context) {
          return SimpleDialog(
            title: const Text('Create post'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: handleTakePhoto(),
                child: const Text('Photo with camera'),
              ),
              SimpleDialogOption(
                onPressed: handleChooseFromGalley(),
                child: const Text('Photo with Gallery'),
              ),
              SimpleDialogOption(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }));
  }

  Container buildSplashScreen() {
    return Container(
      color: Colors.pinkAccent,
      child: Column(children: [
        Image.asset(
          'assets/images/camera.png',
          height: 260.0,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ElevatedButton(
            onPressed: () => handleTakePhoto(), //selectImage(context),
            child: const Text('Uplode image from camera'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ElevatedButton(
            onPressed: () => handleChooseFromGalley(), //selectImage(context),
            child: const Text('Uplode image from galley'),
          ),
        ),
      ]),
    );
  }

  var my_analysis = 2;

  @override
  Widget build(BuildContext context) {
    return file != null ? buildUploadScreen() : buildSplashScreen();
    //return buildUploadScreen();
  }

  Scaffold buildUploadScreen() {
    var image_path;
    if (file != null) {
      image_path = file;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => clearImage(),
        ),
        title: const Text(
          'Create post',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          my_analysis == 0
              ? ElevatedButton(
                  onPressed: isUploading ? null : () => handleSubmit(),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Center(
                  child: Text(
                  'analyiz post',
                  style: TextStyle(color: Colors.blueAccent),
                )),
        ],
      ),
      body: ListView(children: <Widget>[
        isUploading ? linearProgress(context) : const Text(''),
        Container(
          height: 220.0,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(image: FileImage(image_path))),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                'assets/images/no_img.png'), //widget.currentUser.photoURL!
          ),
          title: Container(
            width: 250,
            child: TextField(
              controller: captionController,
              decoration: const InputDecoration(
                hintText: "Write a Caption....",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.pin_drop, color: Colors.orange, size: 35.0),
          title: Container(
            width: 250.0,
            child: TextField(
              controller: locationController,
              decoration: const InputDecoration(
                hintText: 'Location',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        // Container(
        //   width: 100.0,
        //   height: 100.0,
        //   alignment: Alignment.center,
        //   child: ElevatedButton.icon(
        //     onPressed: () => getUserLocation(),
        //     icon: const Icon(Icons.my_location),
        //     label: const Text(
        //       'get current loc',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        // ),

        Container(
          width: 100.0,
          height: 100.0,
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                string = captionController.text;
                my_analysis = 0;
              });
            },
            icon: const Icon(Icons.my_location),
            label: const Text(
              'analysis caption',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),

        Text(
          'Modify caption if the score is less than 1 : ${sentiment.analysis(string)}',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.blue,
          ),
        ),
      ]),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    // int rand = new Math.Random().nextInt(10000);
    Im.Image? imageFile = Im.decodeImage(file!.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
    setState(() {
      file = compressedImageFile;
    }); // choose the size here, it will maintain aspect ratio
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text,
    );
    captionController.clear();
    locationController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = const Uuid().v4();
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    return imageUrl.toString();
    // UploadTask uploadTask =
    //     storageRef.child("post_$postId.jpg").putFile(imageFile);
    // TaskSnapshot storageSnap = await uploadTask.onComplete;
    // String downloadUrl = await storageSnap.ref.getDownloadURL();
    // return downloadUrl;
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

  createPostInFirestore(
      {required String mediaUrl,
      required String location,
      required String description}) {
    postRef
        .doc(widget.currentUser.uid)
        .collection("userPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": widget.currentUser.uid,
      "username": fullname,
      "profilepic": photoUrl,
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      'createdOn': DateTime.now().millisecondsSinceEpoch.toString(),
      "likes": {},
    });
  }

  // Future<dynamic> getUserLocation() async {
  //   Placemark placemark = await getloca();
  //   String completeAddress =
  //       '${placemark.subThoroughfare} ${placemark.administrativeArea} ${placemark.country} ${placemark.postalCode} ${placemark.subLocality}';
  //   String formattedAddress = "${placemark.locality}, ${placemark.country}";
  //   locationController.text = formattedAddress;
  //   setState(() {
  //     locationController.text = formattedAddress;
  //   });
  // }
}
