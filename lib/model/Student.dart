
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stallet/notifiers/students_notifier.dart';

class Student {

  late String uid;
  late String? name;
  late String? surname;
  late String? phoneNum;
  late String? email;
  late String? studentNumber;
  late double score;
  late String institution;
  late bool isAccountVerified;
  late bool isSignUpComplete;
  late String status;
  late bool isAdmin;

  late Map<String, dynamic> autoPay;
  late Map<String, dynamic> budgetLimit;

  Student({required this.uid,required this.name,required this.email,required this.phoneNum});

  Student.fromMap(Map<String, dynamic>? data){
    this.uid = data!['uid'];
    this.name = data['name'];
    this.surname = data['surname'];
    this.phoneNum = data['phoneNumber'];
    this.email = data['email'];
    this.studentNumber = data['studentNumber'];
    this.institution = data['institution'];
    this.score = data['score'];
    this.isAccountVerified = data['isAccountVerified'];
    this.isSignUpComplete = data['isSignUpComplete'];
    this.status = data['status'];
    this.autoPay = data['autoPay'];
    this.budgetLimit = data['budgetLimit'];
    this.isAdmin = data['isAdmin'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'surname' : surname,
      'phoneNumber': phoneNum,
      'studentNumber': studentNumber,
      'email': email,
      'institution': institution,
      'score': score,
      'isAccountVerified': isAccountVerified,
      'isSignUpComplete': isSignUpComplete,
      'status': status,
      'autoPay': autoPay,
      'budgetLimit': budgetLimit,
      'isAdmin': isAdmin,
    };
  }
}

Future<List<Student>> getStudents(StudentNotifier studentNotifier) async {

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .get();

  List<Student> studentList = [];

  snapshot.docs.forEach((element) {

    Student student = Student.fromMap(element.data() as Map<String, dynamic>);
    studentList.add(student);

  });

  studentNotifier.studentList = studentList;
  return studentList;
}