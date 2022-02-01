import 'dart:collection';
import 'package:stallet/model/Institution.dart';
import 'package:flutter/cupertino.dart';
import 'package:stallet/model/SubWallet.dart';

class SubwalletNotifier with ChangeNotifier {
  List<SubWallet> _subwalletList = [];
  late SubWallet _currentWallet;
  bool isListenersNotified = false;

  UnmodifiableListView<SubWallet> get subwalletList => UnmodifiableListView(_subwalletList);

  //gets the institution that has been selected, this data can be used anywhere in the app
  SubWallet get currentWallet => _currentWallet;

  set subwalletList(List<SubWallet> subwalletList) {
    _subwalletList = subwalletList;

    notifyListeners();
  }

  set currentWallet(SubWallet subWallet) {
    _currentWallet = subWallet;

    notifyListeners();
  }

}