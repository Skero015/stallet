
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/notifiers/request_notifier.dart';

class Request {

  late String requestId;
  late String uid;
  late String type;
  late bool isSorted;

  Request();

  Request.fromMap(Map<String, dynamic>? data){
    this.requestId = data!['requestId'];
    this.uid = data!['uid'];
    this.type = data!['type'];
    this.isSorted = data!['isSorted'];
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'uid': uid,
      'type': type,
      'isSorted': isSorted,
    };
  }
}

Future<List> getPaymentRequests(RequestNotifier requestNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Request')
      .get();

  List<Request> requestList = [];

  snapshot.docs.forEach((element) {
    Request request = Request.fromMap(element.data() as Map<String, dynamic>);
    requestList.add(request);
  });

  requestNotifier.requestList = requestList;
  return requestList;
}