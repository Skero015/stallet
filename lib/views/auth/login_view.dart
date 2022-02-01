import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/model/Institution.dart';
import 'package:stallet/notifiers/institution_notifier.dart';
import 'package:stallet/reusables/custom_raised_button.dart';
import 'package:stallet/reusables/custom_snackBar.dart';
import 'package:stallet/services/auth_services.dart';
import 'package:stallet/views/auth/register_view.dart';
import 'package:stallet/views/home_view.dart';

import 'biometric_login.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyLogin = new GlobalKey<ScaffoldState>(debugLabel: '_LoginScreenState');

  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>(debugLabel: '_LoginScreenState');

  final GlobalKey _safeArea = GlobalKey();

  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  late FocusNode myFocusNode;

  late List<DropdownMenuItem<String>> institutionList;
  String selectedInstitution = 'Select your institution';
  late InstitutionNotifier institutionNotifier;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    institutionNotifier = Provider.of<InstitutionNotifier>(context, listen: false);

    getInstitution();

  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
  }

  void getInstitution () async{

    await getInstitutionList(institutionNotifier);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyLogin,
      body: Form(
        key: _formKeyLogin,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: ProgressHUD(
              child: SafeArea(
                child: Padding(
                  key: _safeArea,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10 * SizeConfig.heightMultiplier,),
                      Text('Welcome,', style: AppTheme.mainBoldHeader,),
                      Text('Sign in to continue.', style: AppTheme.regularText,),
                      SizedBox(height: 5 * SizeConfig.heightMultiplier,),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            hintText: 'Email address',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _password,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.2 * SizeConfig.heightMultiplier,),
                      GestureDetector(
                        child: Text('Forgot Password ?', style: AppTheme.outlierTextBold,),
                        onTap: () {
                          /*Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) => new ForgotPasswordScreen()));*/
                        },
                      ),
                      SizedBox(height: 8 * SizeConfig.heightMultiplier,),
                      CustomRaisedButton(
                        onPressed: () async {

                          SystemChannels.textInput.invokeMethod('TextInput.hide');

                          try{
                            final progress = ProgressHUD.of(_safeArea.currentContext!);
                            progress!.show();

                            dynamic result = await Auth().signIn(_email.text.trim(), _password.text.trim());

                            if(result != null){

                              Preferences.uid = FirebaseAuth.instance.currentUser!.uid;
                              progress.dismiss();

                              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  new BiometricLogin()));

                            }else{
                              progress.dismiss();

                              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Colors.black54, Colors.blueAccent[100], 'Email or password is incorrect.', 'OK', (){}));

                            }

                          }catch (e){
                            print(e);
                          }

                        },
                        buttonText: 'Login',
                        shadowColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                      ),
                      SizedBox(height: 6 * SizeConfig.heightMultiplier,),
                      Row(
                        children: [
                          Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                              child: Divider(
                                color: Colors.black,
                                height: 36,
                              ),
                            ),
                          ),
                          Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                              child: Divider(
                                color: Colors.black,
                                height: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account? ', style: AppTheme.secondaryText,),
                            Text('Sign up', style: AppTheme.outlierText,),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterView()));
                        },
                      ),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp(String name,
      String phoneNumber,
      String email,
      String password,
      String surname,
      bool isSignUpComplete) async {

    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      //await _changeLoadingVisible();
      //need await so it has chance to go through error if found.
      print('moving to auth.signUp');
      //dynamic result = await Auth().signUp(name,surname, email, password, phoneNumber, isPhotographer, isSignUpComplete, context);


    } catch (e) {

      print(e);

      /*_changeLoadingVisible();
      String exception = Auth.getExceptionText(e);
      _scaffoldKey3.currentState.showSnackBar(SnackBar(
        content: new Text(exception),
        duration: new Duration(seconds: 5),
      ));*/

    }
  }

}