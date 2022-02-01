
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildUserAccOps {

  BuildContext context;
  final String uid;
  BuildUserAccOps({required this.uid, required this.context});

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('Users');

  Future addSkills(List<String> chosenSkills) async {

    await userCollection.doc(uid).get().then((userDocSnapshot) async {


    });


  }

}