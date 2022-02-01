

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';

class Wallet {

  late String walletId;
  late String userId;
  late double expectedAmount;
  late double totalPaid;
  late double totalUsed;
  late double remainingAmount;
  late double currentPaid;

  Wallet();

  Wallet.fromMap(Map<String, dynamic>? data){
    this.walletId = data!['walletId'];
    this.userId = data['userId'];
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
      'expected_amount': expectedAmount,
      'total_paid': totalPaid,
      'total_used': totalUsed,
      'remaining_amount': remainingAmount,
      'current_paid': currentPaid,
    };
  }

}

Future<Wallet> getWallet(String uid, WalletNotifier walletNotifier) async {

  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('Wallet')
      .doc(uid)
      .get();

  Wallet wallet = Wallet.fromMap(snapshot.data() as Map<String, dynamic>);

  walletNotifier.currentWallet = wallet;

  return wallet;
}
