import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/config/validators.dart';
import 'package:stallet/notifiers/user_notifier.dart';
import 'package:stallet/reusables/custom_raised_button.dart';
import 'package:stallet/reusables/dialogs.dart';
import 'package:stallet/services/db_operations.dart';
import 'package:stallet/views/menu_view.dart';

class SetAutoPayments extends StatefulWidget {
  const SetAutoPayments({Key? key}) : super(key: key);

  @override
  _SetAutoPaymentsState createState() => _SetAutoPaymentsState();
}

class _SetAutoPaymentsState extends State<SetAutoPayments> {

  final GlobalKey<ScaffoldState> _scaffoldKeySetAutoPay = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeySetAutoPay');

  final GlobalKey _safeArea = GlobalKey();

  final GlobalKey<FormState> _formKeyAutoPay = GlobalKey<FormState>(debugLabel: '_RegisterScreenState');

  late FocusNode myFocusNode;

  final TextEditingController _amount = new TextEditingController();

  late DateTime _selectedDate;

  late UserNotifier userNotifier;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    userNotifier = Provider.of<UserNotifier>(context, listen: false);


  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKeySetAutoPay,
        backgroundColor: Colors.white,
        body: Form(
          key: _formKeyAutoPay,
          child: ProgressHUD(
            child: SafeArea(
              key: _safeArea,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:  10.0),
                    child: Column(
                      children: [
                        SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.arrow_back_ios, size: 25, color: Colors.black87,),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuView()));

                                }
                            ),
                            SizedBox(width: 10 * SizeConfig.widthMultiplier,),
                            Center(child: Text('Automatic Payments', style: AppTheme.boldText,)),
                          ],
                        ),
                        SizedBox(height: 9 * SizeConfig.heightMultiplier,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text('Set an automatic payment for when your rent is due.',
                              style: AppTheme.regularText, overflow: TextOverflow.visible),
                        ),
                        SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                        Center(
                          child: Container(
                            height: 7.5 * SizeConfig.heightMultiplier,
                            width: 15 * SizeConfig.widthMultiplier,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
                            decoration: BoxDecoration(
                              color: Color(0xFFFCC459),
                              borderRadius: BorderRadius.all(Radius.circular(15),),
                            ),
                            child: Image.asset(Images.rentImage, height: 5.5 * SizeConfig.imageSizeMultiplier, width: 5.5 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
                          ),
                        ),
                        SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            validator: Validator.validateJustNumber,
                            controller: _amount,
                            decoration: InputDecoration(
                              hintText: 'Enter rental amount',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6 * SizeConfig.heightMultiplier,),
                        Container(
                          height: 3.5 * SizeConfig.heightMultiplier,
                          width: 70 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Padding(
                              padding: EdgeInsets.only(left: 6 * SizeConfig.widthMultiplier, right: 3 * SizeConfig.widthMultiplier),
                              child: dropDownButton([], ''),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    right: 10,
                    left: 10,
                    child: CustomRaisedButton(
                      onPressed: () async{

                        final progress = ProgressHUD.of(_safeArea.currentContext!);
                        progress!.show();

                        if(_formKeyAutoPay.currentState!.validate()){

                          await DBOperations(uid: Preferences.uid, context: context).updateAutoPayment(double.parse(_amount.text.trim()), _selectedDate).whenComplete(() async {

                            progress.dismiss();

                            await showDialog(context: context,
                                builder: (BuildContext context) {
                              return GeneralDialog(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuView()));

                                },
                                buttonText: 'Continue',
                                subtext: 'Your budget limit has been successfully set. You will be alerted whenever you are close to reaching your limit.',
                                title: 'Limit Set',
                              );
                            });
                          });


                        }else{

                        }

                      },
                      buttonText: 'Confirm Auto Payment',
                      shadowColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
        context: context,
        builder: (context) {
          late DateTime tempPickedDate;

          return Container(
            width: MediaQuery.of(context).size.width,
            height: 30 * SizeConfig.heightMultiplier,
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: Text('Done'),
                        onPressed: () {
                          Navigator.of(context).pop(tempPickedDate);
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: Container(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.dateAndTime,
                      onDateTimeChanged: (DateTime dateTime) {
                        tempPickedDate = dateTime;
                      },
                      maximumYear: DateTime.now().year,
                      minimumYear: DateTime.now().year,
                      maximumDate: DateTime(DateTime.now().year,DateTime.now().month + 6,DateTime.now().day),
                      minimumDate: DateTime.now(),
                      initialDateTime: DateTime.now(),
                      use24hFormat: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Widget dropDownButton(List<DropdownMenuItem<dynamic>>? items, String widget) {
    return GestureDetector(
      onTap: () {
        print(widget);
        _selectDate();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 3.5 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: EdgeInsets.only(left: 48 * SizeConfig.widthMultiplier,),
            child: DropdownButton<dynamic>(
              items: items,
              elevation: 0,
              dropdownColor: Colors.grey[400],
              iconSize: 25,
              onTap: (){
                setState(() {
                  _selectDate();
                });
              }, onChanged: (value) {  },
            ),
          ),
        ),
      ),
    );
  }
}
