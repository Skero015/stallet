
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/model/ExpenseHistory.dart';
import 'package:stallet/model/Wallet.dart';
import 'package:stallet/notifiers/expense_notifier.dart';
import 'package:stallet/notifiers/subWallet_notifier.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';
import 'package:stallet/reusables/custom_snackBar.dart';
import 'package:stallet/services/biometric_auth.dart';
import 'package:stallet/services/db_operations.dart';
import 'package:stallet/views/purchase/payment_feedback_view.dart';

import '../home_view.dart';
import '../menu_view.dart';

class ConfirmPayView extends StatefulWidget {

  String shopName;
  double amount;

  ConfirmPayView({Key? key, required this.amount, required this.shopName}) : super(key: key);

  @override
  _ConfirmPayViewState createState() => _ConfirmPayViewState();
}

class _ConfirmPayViewState extends State<ConfirmPayView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyConfirmPay = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyConfirmPay');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  final LocalAuthentication localAuthentication = LocalAuthentication();

  late List<BiometricType> biometricTypes;

  bool biometricAvailable = false;
  bool isAuthenticated = false;

  late ExpenseNotifier expenseNotifier;
  late WalletNotifier walletNotifier;
  late SubwalletNotifier subwalletNotifier;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);

    walletNotifier = Provider.of<WalletNotifier>(context, listen: false);

    subwalletNotifier = Provider.of<SubwalletNotifier>(context, listen: false);

    subwalletNotifier.currentWallet = subwalletNotifier.subwalletList.firstWhere((element) => element.name.toLowerCase().contains('allowance'));

    LocalBiometricAuth.localAuth.authenticate(localizedReason: 'R${widget.amount.toStringAsFixed(2)} to ${widget.shopName.trim()}').whenComplete(() {
      LocalBiometricAuth.authenticated().then((value) async {

        if(value){
          setState(() {
            isAuthenticated = true;
          });
          final progress = ProgressHUD.of(_safeArea.currentContext!);
          progress!.show();
          await DBOperations(uid: Preferences.uid, context: context).updateExpenditureHistory(Preferences.uid,subwalletNotifier.currentWallet.name, widget.shopName, DateTime.now(), widget.amount).whenComplete(() async{

            await DBOperations(uid: Preferences.uid, context: context).updateWallet(walletNotifier.currentWallet, subwalletNotifier.currentWallet, widget.amount).whenComplete(() async {
              await getExpenseHistory(expenseNotifier).whenComplete(() async {
                await getWallet(Preferences.uid, walletNotifier);
                progress.dismiss();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentFeebackView()));
              });
            });


          });

        }else{
          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Colors.white, Colors.blueGrey[700], "Error authenticating biometric.", "OK", () {}));

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
        key: _scaffoldKeyConfirmPay,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: ProgressHUD(
            child: SafeArea(
              child: Padding(
                key: _safeArea,
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                    Container(
                      height: 7.5 * SizeConfig.heightMultiplier,
                      width: MediaQuery.of(context).size.width - 20,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
                      decoration: BoxDecoration(
                        color: Color(0xFF327FC7).withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(15),),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Total', style: AppTheme.boldText, textAlign: TextAlign.center,),
                          Text('R${widget.amount.toStringAsFixed(2)}', style: AppTheme.boldText, textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                    SizedBox(height: 5 * SizeConfig.heightMultiplier,),
                    Center(child: Text('Approve Payment', style: AppTheme.mainBoldHeader, textAlign: TextAlign.center,)),
                    Center(child: Text('R${widget.amount.toStringAsFixed(2)} to ${widget.shopName.trim()}', style: AppTheme.regularTextBold, textAlign: TextAlign.center,)),
                    SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                    Image.asset(Images.fingerprintImage, height: 90 * SizeConfig.imageSizeMultiplier, width: MediaQuery.of(context).size.width, fit: BoxFit.fill,),
                    SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                    Text('Touch the fingerprint sensor', style: AppTheme.regularText,),
                    SizedBox(height: 8 * SizeConfig.heightMultiplier,),
                    Container(
                      height: 7.5 * SizeConfig.heightMultiplier,
                      width: MediaQuery.of(context).size.width - 20,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
                      decoration: BoxDecoration(
                        color: Color(0xFF327FC7).withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(15),),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuView()));
                        },
                        child: Center(child: Text('Cancel', style: AppTheme.mainBoldHeader, textAlign: TextAlign.center,)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
