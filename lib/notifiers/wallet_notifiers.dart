import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:stallet/model/Wallet.dart';

class WalletNotifier with ChangeNotifier {
  List<Wallet> _walletList = [];
  late Wallet _currentWallet;
  bool isListenersNotified = false;

  UnmodifiableListView<Wallet> get walletList => UnmodifiableListView(_walletList);

  //gets the event that has been selected, this data can be used anywhere in the app
  Wallet get currentWallet => _currentWallet;

  set walletList(List<Wallet> walletList) {
    _walletList = walletList;

    notifyListeners();
  }

  set currentWallet(Wallet wallet) {
    _currentWallet = wallet;

    notifyListeners();
  }

}

