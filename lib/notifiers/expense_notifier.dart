import 'dart:collection';
import 'package:stallet/model/ExpenseHistory.dart';
import 'package:stallet/model/Institution.dart';
import 'package:flutter/cupertino.dart';

class ExpenseNotifier with ChangeNotifier {
  List<ExpenseHistory> _expenseList = [];
  late ExpenseHistory _currentExpense;
  bool isListenersNotified = false;

  UnmodifiableListView<ExpenseHistory> get expenseList => UnmodifiableListView(_expenseList);

  //gets the institution that has been selected, this data can be used anywhere in the app
  ExpenseHistory get currentExpense => _currentExpense;

  set expenseList(List<ExpenseHistory> expenseHistoryList) {
    _expenseList = expenseHistoryList;

    notifyListeners();
  }

  set currentExpense(ExpenseHistory expenseHistory) {
    _currentExpense = expenseHistory;

    notifyListeners();
  }

}