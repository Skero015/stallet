import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/config/validators.dart';
import 'package:stallet/model/Institution.dart';
import 'package:stallet/notifiers/institution_notifier.dart';
import 'package:stallet/reusables/custom_raised_button.dart';
import 'package:stallet/reusables/custom_snackBar.dart';
import 'package:stallet/services/auth_services.dart';
import 'package:stallet/views/auth/biometric_setup_view.dart';
import 'package:stallet/views/auth/login_view.dart';
import 'package:dropdown_below/dropdown_below.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyRegister = new GlobalKey<ScaffoldState>(debugLabel: '_RegisterScreenState');

  final GlobalKey<FormState> _formKeyRegister = GlobalKey<FormState>(debugLabel: '_RegisterScreenState');

  final GlobalKey _safeArea = GlobalKey();

  final TextEditingController _fullName = new TextEditingController();
  final TextEditingController _studentNumber = new TextEditingController();
  final TextEditingController _studentEmail = new TextEditingController();
  final TextEditingController _phoneNumber = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _confirmPassword = new TextEditingController();

  bool checkboxValue = false;

  List<DropdownMenuItem<String>> institutionList = [];
  bool doneAdding = false;

  late FocusNode myFocusNode;
  String selectedInstitution = 'CUT01';
  late InstitutionNotifier institutionNotifier;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    institutionNotifier = Provider.of<InstitutionNotifier>(context, listen: false);
    addInstitutionList();
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
  }

  void addInstitutionList() async{
    institutionList = [];
    
    institutionNotifier.institutionList.forEach((element) {
      
      institutionList.add(new DropdownMenuItem(child: Text(element.name), value: element.id));
      print(element.id + " added");
    });

    doneAdding = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyRegister,
      body: Form(
        key: _formKeyRegister,
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
                    SizedBox(height: 6 * SizeConfig.heightMultiplier,),
                    Text('Get started,', style: AppTheme.mainBoldHeader,),
                    Text(' Create an account', style: AppTheme.regularText,),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 5 * SizeConfig.heightMultiplier,),
                            Container(
                              height: 3.5 * SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 0.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 6 * SizeConfig.widthMultiplier, right: 3 * SizeConfig.widthMultiplier),
                                child: DropdownButtonHideUnderline(
                                  child: doneAdding ? DropdownButton(
                                    hint: Text('Choose your institution'),
                                    items: institutionList,
                                    elevation: 5,
                                    dropdownColor: Colors.grey[400],
                                    onChanged: (value){
                                      setState(() {

                                        selectedInstitution = value.toString();

                                      });
                                    },
                                  ) : Container(),
                                ),
                              ),
                            ),
                            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: TextFormField(
                                validator: Validator.validateName,
                                controller: _fullName,
                                decoration: InputDecoration(
                                  hintText: 'Full Name',
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
                                validator: Validator.validateNumber,
                                controller: _studentNumber,
                                decoration: InputDecoration(
                                  hintText: 'Student number',
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
                                validator: Validator.validateEmail,
                                controller: _studentEmail,
                                decoration: InputDecoration(
                                  hintText: 'Student email',
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
                                validator: Validator.validateNumber,
                                controller: _phoneNumber,
                                decoration: InputDecoration(
                                  hintText: 'Phone number',
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
                                validator: Validator.validatePassword,
                                controller: _password,
                                decoration: InputDecoration(
                                  hintText: 'Password',
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
                                validator: Validator.confirmPassword,
                                controller: _confirmPassword,
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5 * SizeConfig.heightMultiplier,),
                            Row(
                              children: [
                                Checkbox(
                                  value: checkboxValue,
                                  splashRadius: 5,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      checkboxValue = newValue as bool;
                                    });
                                  },
                                  activeColor: Color(0xFFEC7532),
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.all<Color>( checkboxValue ? Color(0xFFEC7532) : Color(0xFFEC7532)),
                                ),
                                Expanded(child: Text('Yes, I understand and agree to the Stallet Terms of Service, including the User Agreement and Privacy Policy.', style: AppTheme.regularText, softWrap: true, overflow: TextOverflow.visible,)),
                              ],
                            ),
                            SizedBox(height: 6 * SizeConfig.heightMultiplier,),
                            CustomRaisedButton(
                              onPressed: () async {


                                if(_formKeyRegister.currentState!.validate()){

                                  SystemChannels.textInput.invokeMethod('TextInput.hide');

                                  if(checkboxValue){
                                    final progress = ProgressHUD.of(_safeArea.currentContext!);
                                    progress!.show();

                                    await signUp(_fullName.text.trim(), _phoneNumber.text.trim(), _studentNumber.text.trim(), _studentEmail.text.trim(), _password.text.trim(), selectedInstitution, false).whenComplete(() async{

                                      //await Preferences.setSignUpProgressFlag("skills");

                                      progress.dismiss();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => BiometricSetupView()));
                                    });
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Colors.black54, Colors.blueAccent[100], 'Please accept the Stallet Terms & Conditions to continue.', 'OK', (){}));

                                  }

                                }else{

                                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Colors.black54, Colors.blueAccent[100], 'Complete all fields to continue', 'OK', (){}));
                                }

                              },
                              buttonText: 'Register',
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
                                  Text('Already have an account? ', style: AppTheme.secondaryText,),
                                  Text('Log in', style: AppTheme.outlierText,),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginView()));
                              },
                            ),
                            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                          ],
                        ),
                      ),
                    )
                  ],
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
      String studentNumber,
      String email,
      String password,
      String institution,
      bool isSignUpComplete) async {

    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      //await _changeLoadingVisible();
      //need await so it has chance to go through error if found.
      print('moving to auth.signUp');
      dynamic result = await Auth().signUp(name, email, studentNumber, password, phoneNumber, institution, isSignUpComplete, context);


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
