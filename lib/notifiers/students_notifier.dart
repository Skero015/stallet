import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:stallet/model/Student.dart';

class StudentNotifier with ChangeNotifier {
  List<Student> _studentList = [];
  late Student _currentStudent;
  bool isListenersNotified = false;

  UnmodifiableListView<Student> get studentList => UnmodifiableListView(_studentList);

  //gets the institution that has been selected, this data can be used anywhere in the app
  Student get currentStudent => _currentStudent;

  set studentList(List<Student> studentList) {
    _studentList = studentList;

    notifyListeners();
  }

  set currentStudent(Student student) {
    _currentStudent = student;

    notifyListeners();
  }

}