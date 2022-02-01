
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:stallet/model/Request.dart';

class RequestNotifier with ChangeNotifier {
  List<Request> _requestList = [];
  late Request _currentRequest;
  bool isListenersNotified = false;

  UnmodifiableListView<Request> get requestList => UnmodifiableListView(_requestList);

  //gets the institution that has been selected, this data can be used anywhere in the app
  Request get currentRequest => _currentRequest;

  set requestList(List<Request> requestList) {
    _requestList = requestList;

    notifyListeners();
  }

  set currentRequest(Request request) {
    _currentRequest = request;

    notifyListeners();
  }

}