import 'package:flutter/material.dart';

class Validator {

  //This is for validating the Email
  static String? validateEmail(String? value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = new RegExp(pattern.toString());

    if(value!.trim().isEmpty){
      return 'This field cannot be left empty.';
    }else if (!regex.hasMatch(value.trim()))
      return 'Please enter a valid email address.';
    else
      return null;

  }

  static late String password;
//This is for validating the Password
  static String? validatePassword(String? value) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = new RegExp(pattern.toString());

    password = value!.trim();
    if(value!.trim().isEmpty){
      return 'This field cannot be left empty.';
    }else if (!regex.hasMatch(value!.trim()))
      return 'Password must be at least 6 characters.';
    else
      return null;

  }

  //This is for confirming the Password
  static String? confirmPassword(String? valueConfirmer) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = new RegExp(pattern.toString());

    if(password.trim().isEmpty){
      return 'This field cannot be left empty.';
    }else if (password.trim() != valueConfirmer!.trim()) {
      return 'Passwords do not match';
    } else {
      return null;
    }

  }

  //This is for validating the Name
  static String? validateName(String? value) {
    Pattern pattern = r"^[a-zA-Z]{4,}(?: [a-zA-Z]+){0,2}$";
    RegExp regex = new RegExp(pattern.toString());

    if (value!.trim().isEmpty){
      return 'Please enter a name.';
    }else if(!regex.hasMatch(value!.trim())){
      return 'Name must have 4 or more characters';
    } else{
      return null;
    }

  }

//This is for validating the Surname
  static String? validateSurname(String? value) {
    Pattern pattern = r"^[a-zA-Z]+[a-zA-Z]*$";
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value!.trim()))
      return 'Please enter a surname.';
    else
      return null;
  }

  //This is for validating other fields
  static String? validateField(String? value) {
    Pattern pattern = r"^[a-zA-Z]+[a-zA-Z]*$";
    RegExp regex = new RegExp(pattern.toString());
    if (value!.trim().isEmpty)
      return 'Field cannot be empty.';
    else
      return null;
  }

  //This is for validating the username
  static String? validateUsername(String? value) {
    Pattern pattern = r"^(?=.{3,15}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$";
    RegExp regex = new RegExp(pattern.toString());

    List<String> unwantedCharList = ['~','`','@','#','\$','%','^','&','*','(',')','-','+','=','{','}','[',']',':',';','"','\'','|','\\','<','>','?',',','/',];

    if(value!.trim().isEmpty){
      return 'This field cannot be left empty.';
    } else if(value!.trim().length < 3) {
      return 'Username must have 3 or more characters';
    } else if(value!.trim().startsWith('_') || value.trim().endsWith('_')) {
      return 'Username cannot start or end with underscore';
    } else if(value!.trim().startsWith('.') || value.trim().endsWith('.')) {
      return 'Username cannot start or end with period';
    } else if(unwantedCharList.contains(value.trim())) {
      return 'Username can only contain underscore and period as characters';
    } else if (!regex.hasMatch(value.trim()))
      return 'Please enter a proper username.';
    else
      return null;
  }

//This is for validating the phone number
  static String? validateNumber(String? value) {
    Pattern pattern = r'^(?:[0])?[0-9]{9}$';
    RegExp regex = new RegExp(pattern.toString());
    if(value!.trim().isEmpty){
      return 'This field cannot be left empty.';
    } else if (!regex.hasMatch(value.trim()))
      return 'Please enter a valid student number.';
    else
      return null;

  }

  //This is for validating the number
  static String? validateJustNumber(String? value) {
    if(value!.trim().isEmpty){
      return 'This field cannot be left empty.';
    } else
      return null;

  }

}