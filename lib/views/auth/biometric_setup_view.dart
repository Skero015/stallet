import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/reusables/custom_raised_button.dart';
import 'package:stallet/services/biometric_auth.dart';
import 'package:stallet/views/auth/login_view.dart';

class BiometricSetupView extends StatefulWidget {
  const BiometricSetupView({Key? key}) : super(key: key);

  @override
  _BiometricSetupViewState createState() => _BiometricSetupViewState();
}

class _BiometricSetupViewState extends State<BiometricSetupView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyBiometricSetup = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyBiometricSetup');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  BiometricType biometricType = BiometricType.iris;

  late List<BiometricType> biometricTypes;

  bool isDeviceSupported = false;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    getBiometricTypes();

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
        key: _scaffoldKeyBiometricSetup,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              key: _safeArea,
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Stack(
                children: [
                  isDeviceSupported ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15 * SizeConfig.heightMultiplier,),
                      Text('Your biometric login', style: AppTheme.mainBoldHeader, overflow: TextOverflow.visible,),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(biometricType!=BiometricType.iris ? 'The below biometric will be used to sign in to your account.'
                            ' Click Continue to continue to log in.' :
                        'Biometric login keeps your account safe from fraudsters. '
                            'Set up a biometric method for logging in.',
                            style: AppTheme.regularText, overflow: TextOverflow.visible),
                      ),
                      SizedBox(height: 7 * SizeConfig.heightMultiplier,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          biometricType == BiometricType.fingerprint ? Column(
                            children: [
                              Container(
                                height: 10 * SizeConfig.heightMultiplier,
                                width: 20 * SizeConfig.widthMultiplier,
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(15),),
                                  border: Border.all(color: Colors.grey[800]!, style: BorderStyle.solid),
                                ),
                                child: Image.asset(Images.fingerprintImage, height: 5.5 * SizeConfig.imageSizeMultiplier, width: 5.5 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
                              ),
                              SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                              Text('Fingerprint', style: AppTheme.regularText, overflow: TextOverflow.visible),
                            ],
                          ) : Container(),
                          biometricType == BiometricType.face ? Column(
                            children: [
                              Container(
                                height: 10 * SizeConfig.heightMultiplier,
                                width: 20 * SizeConfig.widthMultiplier,
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(15),),
                                  border: Border.all(color: Colors.grey[800]!, style: BorderStyle.solid),
                                ),
                                child: Image.asset(Images.irisImage, height: 5.5 * SizeConfig.imageSizeMultiplier, width: 5.5 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
                              ),
                              SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                              Text('Face', style: AppTheme.regularText, overflow: TextOverflow.visible),

                            ],
                          ) : Container(),
                        ],
                      ),
                    ],
                  ): Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15 * SizeConfig.heightMultiplier,),
                      Text('Your biometric login', style: AppTheme.mainBoldHeader, overflow: TextOverflow.visible,),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text('Your device does not support biometric security. You will be required'
                            ' to login only using your email and password.',
                            style: AppTheme.regularText, overflow: TextOverflow.visible),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 40,
                    right: 0,
                    left: 0,
                    child: CustomRaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginView()));

                      },
                      buttonText: 'Continue',
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

  void getBiometricTypes() async {

    isDeviceSupported = await LocalBiometricAuth.checkBiometrics();

    if(isDeviceSupported) {

      biometricTypes = await LocalBiometricAuth.getBiometricTypes();

      if(biometricTypes.contains(BiometricType.fingerprint)) {
        setState(() {
          biometricType = BiometricType.fingerprint;
        });
      }else if(biometricTypes.contains(BiometricType.face)) {
        setState(() {
          biometricType = BiometricType.face;
        });
      }

    }else{

    }


  }

}
