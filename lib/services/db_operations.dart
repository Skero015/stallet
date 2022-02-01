import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stallet/model/SubWallet.dart';
import 'package:stallet/model/Wallet.dart';
import 'package:stallet/notifiers/subWallet_notifier.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';

class DBOperations {

  BuildContext context;
  final String uid;
  DBOperations({required this.uid, required this.context});

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('Users');

  final CollectionReference walletCollection =
  FirebaseFirestore.instance.collection('Wallet');

  final CollectionReference expenditureHistoryCollection =
  FirebaseFirestore.instance.collection('Expenditure History');

  final CollectionReference requestCollection =
  FirebaseFirestore.instance.collection('Request');

  Future addUserData(String name, String phoneNumber ,String email, String studentNumber, String institution, bool isSignUpComplete) async {
    return await userCollection.doc(uid).set({
      'uid' : uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'isSignUpComplete': isSignUpComplete,
      'institution': institution,
      'score': 0.001,
      'studentNumber': studentNumber,
      'isAccountVerified': false,
      'isAdmin': false,
      'budgetLimit':
          {
            'is_set': false,
            'date_set': DateTime.now(),
            'amount': 0.0001,

          },
      'autoPayment':
          {
            'is_set': false,
            'pay_date': DateTime.now(),
            'amount': 0.0001,
          },
    });
  }

  Future updateVerification(bool isBlocked) async {
    return await userCollection.doc(uid).update({
      'isAccountVerified': isBlocked,
    });
  }

  Future updateExpenditureHistory(String walletId, String subwalletName, String storeName, DateTime dateTime, double amount) async {
    return await userCollection.doc(uid).collection('Expenditure History').add({
      'walletId': walletId,
      'walletName': subwalletName,
      'store_name': storeName,
      'date': dateTime,
      'amount': amount,
    });
  }
  
  Future updateBudgetLimit(double amount, DateTime dateSet) async {
    return await userCollection.doc(uid).update({
      'budgetLimit':
      {
        'is_set': true,
        'date_set': dateSet,
        'amount': amount,
      }
    });
  }

  Future updateAutoPayment(double amount, DateTime dateSet) async {
    return await userCollection.doc(uid).update({
      'autoPayment':
      {
        'is_set': true,
        'pay_date': Timestamp.fromDate(dateSet),
        'amount': amount,
      }
    });
  }

  Future addRequest(String requestType) async {
    String requestId = Random.secure().nextInt(1000000).toString();
    return await requestCollection.doc(requestId).set({
      'isSorted': false,
      'requestId': requestId,
      'type': requestType,
      'uid': uid,
    });
  }

  Future updateRequest(bool isSorted, String requestId) async {
    return await requestCollection.doc(requestId).update({
      'isSorted': isSorted,
    }).whenComplete(() async {
      requestCollection.doc(requestId).delete();
    });
  }

  Future createWallet() async {
    return await walletCollection.doc(uid).set({
      'walletId': Random.secure().nextInt(10000).toString(),
      'userId': uid,
      'expected_amount': 0.0001,
      'total_paid': 0.0001,
      'total_used': 0.0001,
      'remaining_amount': 0.0001,
      'current_paid': 0.0001,
      
    }).then((value) async {

      List<String> walletNames = ['Allowance','Books','Rent'];

      int counter = 0;

      while(counter < walletNames.length){
        await walletCollection.doc(uid).collection('SubWallet').doc(walletNames[counter]).set({
          'walletId': Random.secure().nextInt(10000).toString(),
          'userId': uid,
          'expected_amount': 0.0001,
          'total_paid': 0.0001,
          'total_used': 0.0001,
          'remaining_amount': 0.0001,
          'current_paid': 0.0001,
          'name': walletNames[counter],
        });
        counter++;
      }

    });
  }

  Future updateWallet(Wallet wallet, SubWallet subwallet, double amount) async {
    return await walletCollection.doc(uid).update({
      'total_used': wallet.totalUsed + amount,
      'remaining_amount': wallet.remainingAmount - amount,
    }).whenComplete(() async {
      return await walletCollection.doc(uid).collection('SubWallet').doc(subwallet.name).update({
        'total_used': wallet.totalUsed + amount,
        'remaining_amount': wallet.remainingAmount - amount,
      });
    });
  }

  Future updateWalletFromRequest(Wallet wallet, SubWallet subwallet, double amount) async {
    return await walletCollection.doc(uid).update({
      'current_paid': wallet.totalUsed + amount,
      'total_paid': wallet.totalUsed + amount,
      'remaining_amount': wallet.remainingAmount + amount,
    }).whenComplete(() async {
      return await walletCollection.doc(uid).collection('SubWallet').doc(subwallet.name).update({
        'current_paid': wallet.totalUsed + amount,
        'total_paid': wallet.totalUsed + amount,
        'remaining_amount': wallet.remainingAmount + amount,
      });
    });
  }

}