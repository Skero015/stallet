
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/notifiers/expense_notifier.dart';

class ExpenseHistory{

  late String id;
  late double amount;
  late Timestamp date;
  late String shopName;
  late String walletName;
  late String walletId;

  ExpenseHistory();

  ExpenseHistory.fromMap(Map<String, dynamic>? data){
    this.amount = data!['amount'];
    this.id = data!['id'];
    this.date = data!['date'];
    this.shopName = data!['store_name'];
    this.walletName = data!['walletName'];
    this.walletId = data!['walletId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'id': id,
      'date': date,
      'store_name': shopName,
      'walletName': walletName,
      'walletId': walletId,
    };
  }
}

Future<List> getExpenseHistory(ExpenseNotifier expenseNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(Preferences.uid)
      .collection('Expenditure History')
      .get();

  List<ExpenseHistory> expenseHistoryList = [];

  snapshot.docs.forEach((element) {
    ExpenseHistory expenseHistory = ExpenseHistory.fromMap(element.data() as Map<String, dynamic>);
    expenseHistoryList.add(expenseHistory);
  });

  expenseNotifier.expenseList = expenseHistoryList;
  return expenseHistoryList;
}