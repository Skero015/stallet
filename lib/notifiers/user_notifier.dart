import 'dart:collection';
import 'package:stallet/model/User.dart';
import 'package:flutter/cupertino.dart';

class UserNotifier with ChangeNotifier {

  late UserModel _currentUser;
  bool isListenersNotified = false;

  //gets the institution that has been selected, this data can be used anywhere in the app
  UserModel get currentUser => _currentUser;

  set currentUser(UserModel user) {
    _currentUser = user;

    notifyListeners();
  }

}
