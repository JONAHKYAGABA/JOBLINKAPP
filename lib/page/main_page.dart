import 'package:flutter/material.dart';
import 'package:flutter_application_2/page/account_page.dart';
import 'package:flutter_application_2/page/displayjob.dart';
import 'package:flutter_application_2/page/favorit_page.dart';
import 'package:flutter_application_2/page/home_page.dart';
import 'package:flutter_application_2/page/notification_page.dart';
import 'package:flutter_application_2/providers/page_provider.dart';
import 'package:flutter_application_2/theme.dart';
import 'package:flutter_application_2/widgets/custom_navigation_icon.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var pageProvider = Provider.of<PageProvider>(context);

    Widget contentSelected(int currentIndex) {
      switch (currentIndex) {
        case 0:
          return HomePage();
        case 1:
          return jobdetails();
        case 3:
          return FavoritPage();
        case 2:
          return AccountPage();
        default:
          return HomePage();
      }
    }

    Widget customButtonNavigation() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 84,
          width: double.infinity,
          color: greyColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomIconNavigation(
                index: 0,
                imgUrl: 'assets/images/icon_apps.png',
              ),
              CustomIconNavigation(
                index: 1,
                imgUrl: 'assets/images/icon_notification.png',
              ),
              CustomIconNavigation(
                index: 2,
                imgUrl: 'assets/images/icon_user.png',
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          contentSelected(pageProvider.number),
          customButtonNavigation(),
        ],
      ),
    );
  }
}
