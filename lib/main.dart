//@dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/notifiers/expense_notifier.dart';
import 'package:stallet/notifiers/institution_notifier.dart';
import 'package:stallet/notifiers/request_notifier.dart';
import 'package:stallet/notifiers/students_notifier.dart';
import 'package:stallet/notifiers/subWallet_notifier.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';
import 'package:stallet/views/auth/login_view.dart';
import 'package:stallet/views/splash.dart';

import 'notifiers/user_notifier.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Sizer(
            builder: (context, orientation, deviceType) {
              SizeConfig().init(constraints, orientation);
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => InstitutionNotifier(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => WalletNotifier(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => UserNotifier(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => ExpenseNotifier(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => SubwalletNotifier(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => StudentNotifier(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => RequestNotifier(),
                  ),
                ],
                child: MaterialApp(
                  title: 'Stallet',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: SplashView(),
                ),
              );
            }
        );
      },
    );
  }
}
