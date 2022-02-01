import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stallet/notifiers/institution_notifier.dart';

class Institution {

  late String id;
  late String name;
  late String email;
  late String campus;

  Institution();

  Institution.fromMap(Map<String, dynamic>? data){
    this.name = data!['name'];
    this.id = data!['id'];
    this.email = data!['email'];
    this.campus = data!['campus'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'campus': campus,
    };
  }
}

Future<List> getInstitutionList(InstitutionNotifier institutionNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Institution')
      .get();

  List<Institution> institutionList = [];

  snapshot.docs.forEach((element) {
    Institution institution = Institution.fromMap(element.data() as Map<String, dynamic>);
    institutionList.add(institution);
  });

  institutionNotifier.institutionList = institutionList;
  return institutionList;
}