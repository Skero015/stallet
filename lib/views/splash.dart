

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/model/ExpenseHistory.dart';
import 'package:stallet/model/Request.dart';
import 'package:stallet/model/Student.dart';
import 'package:stallet/model/User.dart';
import 'package:stallet/model/Wallet.dart';
import 'package:stallet/notifiers/expense_notifier.dart';
import 'package:stallet/notifiers/request_notifier.dart';
import 'package:stallet/notifiers/students_notifier.dart';
import 'package:stallet/notifiers/user_notifier.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';
import 'package:stallet/services/db_operations.dart';
import 'package:stallet/views/admin/search_view.dart';
import 'package:stallet/views/auth/biometric_login.dart';
import 'package:stallet/views/auth/login_view.dart';
import 'package:stallet/views/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {


  late UserNotifier userNotifier;

  late ExpenseNotifier expenseNotifier;

  late WalletNotifier walletNotifier;

  late StudentNotifier studentNotifier;

  late RequestNotifier requestNotifier;

  @override
  void initState() {
    super.initState();

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    userNotifier = Provider.of<UserNotifier>(context, listen: false);

    expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);

    walletNotifier = Provider.of<WalletNotifier>(context, listen: false);

    studentNotifier = Provider.of<StudentNotifier>(context, listen: false);

    Future.delayed(Duration(milliseconds: 4000), () async {

      if(FirebaseAuth.instance.currentUser == null){
        Navigator.of(context).pop();
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
            new LoginView()));
      }else{

        Preferences.currentUser = FirebaseAuth.instance.currentUser!;
        Preferences.uid = FirebaseAuth.instance.currentUser!.uid;

        await getUserDetails(Preferences.uid, userNotifier).then((user) {

          userNotifier.currentUser = user;

          getExpenseHistory(expenseNotifier).whenComplete(() async{

            if(user.isAdmin){

              await getStudents(studentNotifier).whenComplete(() async {

                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new BiometricLogin()));

              });

            }else{
              await getWallet(Preferences.uid, walletNotifier);

              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new BiometricLogin()));
            }

          });


        });


      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(fit: BoxFit.fitHeight,
              image: AssetImage(Images.stalletTwoImage),
              height: MediaQuery.of(context).size.height -400,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(height: 50,),
            Text('Stallet', style: AppTheme.logoBoldHeader,),
          ],
        ),
      ),
    );
  }
}
