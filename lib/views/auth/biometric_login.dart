import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/model/ExpenseHistory.dart';
import 'package:stallet/model/User.dart';
import 'package:stallet/model/Wallet.dart';
import 'package:stallet/notifiers/expense_notifier.dart';
import 'package:stallet/notifiers/user_notifier.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';
import 'package:stallet/reusables/custom_snackBar.dart';
import 'package:stallet/services/biometric_auth.dart';
import 'package:stallet/views/admin/search_view.dart';
import 'package:stallet/views/home_view.dart';

class BiometricLogin extends StatefulWidget {
  const BiometricLogin({Key? key}) : super(key: key);

  @override
  _BiometricLoginState createState() => _BiometricLoginState();
}

class _BiometricLoginState extends State<BiometricLogin> {

  final GlobalKey<ScaffoldState> _scaffoldKeyBiometricLogin = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyBiometricLogin');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  late bool canCheckBiometrics;

  final LocalAuthentication localAuthentication = LocalAuthentication();

  late UserNotifier userNotifier;

  late WalletNotifier walletNotifier;

  late ExpenseNotifier expenseNotifier;

  late List<BiometricType> biometricTypes;

  bool biometricAvailable = false;
  bool isAuthenticated = false;

  bool isAdmin = false;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    userNotifier = Provider.of<UserNotifier>(context, listen: false);

    walletNotifier = Provider.of<WalletNotifier>(context, listen: false);

    expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);

    getUserDetails(Preferences.uid,userNotifier).then((user) async {

      isAdmin = user.isAdmin;

      print('now working with biometrics');
      LocalBiometricAuth.checkBiometrics().then((value) async {

        biometricAvailable = value;

        print('checkBiometrics: ' + value.toString());
        if(value) {
          LocalBiometricAuth.localAuth.authenticate(localizedReason: 'Complete this step to login').then((value) {
            print('authenticate: ' + value.toString());

            LocalBiometricAuth.authenticated().then((value) async {
              print('authenticated: ' + value.toString());
              if(value){
                setState(() {
                  isAuthenticated = true;
                });

                if(user.isAdmin){


                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchView()));
                }else{

                  await getExpenseHistory(expenseNotifier).whenComplete(() async {
                    await getWallet(Preferences.uid, walletNotifier).whenComplete(() {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeView()));
                    });
                  });

                }

              }else{
                ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Colors.white, Colors.blueGrey[700], "Error authenticating biometric.", "OK", okPress));

              }

            });
          });

        }else{

          if(user.isAdmin){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchView()));
          }else{
            await getExpenseHistory(expenseNotifier).whenComplete(() async {
              await getWallet(Preferences.uid, walletNotifier).whenComplete(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeView()));
              });
            });
          }

        }

      });
    });


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
      key: _scaffoldKeyBiometricLogin,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            key: _safeArea,
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20 * SizeConfig.heightMultiplier,),
                Text('Place your \nfingerprint to login', style: AppTheme.mainBoldHeader,),
                SizedBox(height: 5 * SizeConfig.heightMultiplier,),
                Image.asset(Images.fingerprintImage, height: 100 * SizeConfig.imageSizeMultiplier, width: MediaQuery.of(context).size.width, fit: BoxFit.fill,),
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<bool> checkBiometrics() async {

    canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    if(canCheckBiometrics){
      biometricTypes = await localAuthentication.getAvailableBiometrics();

      if (biometricTypes.contains(BiometricType.fingerprint)) {
        // Touch ID.
      } else if (biometricTypes.contains(BiometricType.face)) {
        // Face ID.
      }

      return canCheckBiometrics;
    }else{
      return canCheckBiometrics;
    }

  }

  void okPress(){}

}
