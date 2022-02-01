

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/model/User.dart';

import 'db_operations.dart';

class Auth {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Get current user
  Future<String?> currentUser() async {
    try {

      User? currentUser = FirebaseAuth.instance.currentUser!;

      return currentUser!.uid;
    } catch (e) {
      return null;
    }
  }

  Stream<UserModel>? get user {
    return _auth.authStateChanges().map(
            (User? firebaseUser) {

          if(firebaseUser != null){
            print("user not null");

            return UserModel(
                uid: firebaseUser.uid,
                name: firebaseUser.displayName,
                phoneNum: firebaseUser.phoneNumber,
                email: firebaseUser.email
            );

          }else{
            return null;
          }
        }
    ).handleError((onError) {print(onError);}) as Stream<UserModel>;
  }

  //Sign in
  Future signIn(String email, String password) async {

    try{

      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if(user.user != null){
        Preferences.uid = user.user!.uid;
        return UserModel(
            uid: user.user!.uid,
            name: user.user!.displayName,
            phoneNum: user.user!.phoneNumber,
            email: user.user!.email
        );
      }else{
        return null;
      }


      return UserModel;

    }catch(e) {
      print(e);
    }

  }

  Future signUp(String name, String email, String studentNumber, String password,String phoneNumber, String institution, bool isSignUpComplete, BuildContext context) async {

    UserCredential user;

    user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email.trim(), password: password.trim());

    user.user!.updateDisplayName(name);

    await user.user!.sendEmailVerification();

    //    Adding User to Database
    await DBOperations(uid: user.user!.uid, context: context).addUserData(name, phoneNumber,email, studentNumber, institution, isSignUpComplete);

    //adding Wallet to database collection
    await DBOperations(uid: user.user!.uid, context: context).createWallet();


  }

  Future<void> signOutUser() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  //Forgot password
  Future forgotPasswordEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }



}