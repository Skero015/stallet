

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stallet/notifiers/subWallet_notifier.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';

class SubWallet {

  late String walletId;
  late String userId;
  late String name;
  late double expectedAmount;
  late double totalPaid;
  late double totalUsed;
  late double remainingAmount;
  late double currentPaid;

  SubWallet();

  SubWallet.fromMap(Map<String, dynamic>? data){
    this.walletId = data!['walletId'];
    this.userId = data['userId'];
    this.name = data['name'];
    this.expectedAmount = data['expected_amount'];
    this.totalPaid = data['total_paid'];
    this.totalUsed = data['total_used'];
    this.remainingAmount = data['remaining_amount'];
    this.currentPaid = data['current_paid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'walletId': walletId,
      'userId': userId,
      'name': name,
      'expected_amount': expectedAmount,
      'total_paid': totalPaid,
      'total_used': totalUsed,
      'remaining_amount': remainingAmount,
      'current_paid': currentPaid,
    };
  }

}


Future<List<SubWallet>> getInnerWallets(String uid, SubwalletNotifier walletNotifier) async {

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Wallet')
      .doc(uid)
      .collection('SubWallet')
      .get();

  List<SubWallet> walletList = [];

  snapshot.docs.forEach((element) {

    SubWallet wallet = SubWallet.fromMap(element.data() as Map<String, dynamic>);
    walletList.add(wallet);

  });

  walletNotifier.subwalletList = walletList;
  return walletList;
}