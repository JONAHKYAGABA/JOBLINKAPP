import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/user_model.dart';

class UserProvider with ChangeNotifier {
  late UserModel _user;

  UserModel get user => _user;

  set user(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }
}
