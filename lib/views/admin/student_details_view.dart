
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/model/ExpenseHistory.dart';
import 'package:stallet/notifiers/expense_notifier.dart';
import 'package:stallet/notifiers/request_notifier.dart';
import 'package:stallet/notifiers/students_notifier.dart';
import 'package:stallet/notifiers/subWallet_notifier.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';
import 'package:stallet/reusables/custom_raised_button.dart';
import 'package:stallet/reusables/dialogs.dart';
import 'package:stallet/services/db_operations.dart';
import 'package:stallet/views/admin/expense_history_view.dart';
import 'package:stallet/views/admin/search_view.dart';
import 'package:currency_textfield/currency_textfield.dart';

class StudentDetailsView extends StatefulWidget {
  const StudentDetailsView({Key? key}) : super(key: key);

  @override
  _StudentDetailsViewState createState() => _StudentDetailsViewState();
}

class _StudentDetailsViewState extends State<StudentDetailsView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyStudent = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyStudent');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  late StudentNotifier studentNotifier;

  late RequestNotifier requestNotifier;

  late WalletNotifier walletNotifier;
  late SubwalletNotifier subwalletNotifier;
  late ExpenseNotifier expenseNotifier;

  final TextEditingController _controller = new TextEditingController();

  CurrencyTextFieldController controller = CurrencyTextFieldController();

  late bool isBlocked;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    var controller = CurrencyTextFieldController(rightSymbol: "RR", decimalSymbol: ".", thousandSymbol: ",");

    studentNotifier = Provider.of<StudentNotifier>(context, listen: false);

    requestNotifier = Provider.of<RequestNotifier>(context, listen: false);

    walletNotifier = Provider.of<WalletNotifier>(context, listen: false);

    subwalletNotifier = Provider.of<SubwalletNotifier>(context, listen: false);

    expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);

    isBlocked = studentNotifier.currentStudent.isAccountVerified;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.arrow_back_ios, size: 25, color: Colors.black87,),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchView()));

                              }
                          ),
                          SizedBox(width: 12 * SizeConfig.widthMultiplier,),
                          Center(child: Text(studentNotifier.currentStudent.name!, style: AppTheme.boldText,)),
                        ],
                      ),
                      SizedBox(height: 5 * SizeConfig.heightMultiplier,),
                      Text(requestNotifier.requestList.any((element) => element.uid == studentNotifier.currentStudent.uid) ? 'Student has a payment request.' : 'Student has no payment request.',
                          style: AppTheme.regularText, overflow: TextOverflow.visible),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                      Row(
                        children: [
                          Text('Student number: ', style: AppTheme.regularTextBold, overflow: TextOverflow.visible),
                          Text(studentNotifier.currentStudent.studentNumber!, style: AppTheme.regularTextBold, overflow: TextOverflow.visible),

                        ],
                      ),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      Row(
                        children: [
                          Text('Score: ', style: AppTheme.regularTextBold, overflow: TextOverflow.visible),
                          Text(studentNotifier.currentStudent.score.toStringAsFixed(2)!, style: AppTheme.regularTextBold, overflow: TextOverflow.visible),

                        ],
                      ),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      Row(
                        children: [
                          Text('Budget limit: ', style: AppTheme.regularTextBold, overflow: TextOverflow.visible),
                          Text("R" + studentNotifier.currentStudent.budgetLimit['amount'].toString()!, style: AppTheme.regularTextBold, overflow: TextOverflow.visible),

                        ],
                      ),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      Row(
                        children: [
                          Text('Auto payment: ', style: AppTheme.regularTextBold, overflow: TextOverflow.visible),
                          Text(studentNotifier.currentStudent.budgetLimit['is_set'].toString(), style: AppTheme.regularTextBold, overflow: TextOverflow.visible),

                        ],
                      ),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      Row(
                        children: [
                          Text('Status: ', style: AppTheme.regularTextBold, overflow: TextOverflow.visible),
                          Text(isBlocked? "Blocked" : "Active", style: AppTheme.regularTextBold, overflow: TextOverflow.visible),

                        ],
                      ),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      Row(
                        children: [
                          Text('Total paid: ', style: AppTheme.regularTextBold, overflow: TextOverflow.visible),
                          Text("R" + walletNotifier.currentWallet.totalPaid.toStringAsFixed(2)!, style: AppTheme.regularTextBold, overflow: TextOverflow.visible),

                        ],
                      ),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      Row(
                        children: [
                          Text('Total used: ', style: AppTheme.regularTextBold, overflow: TextOverflow.visible),
                          Text("R" + walletNotifier.currentWallet.totalUsed.toStringAsFixed(2)!, style: AppTheme.regularTextBold, overflow: TextOverflow.visible),

                        ],
                      ),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 90,
                  right: 10,
                  left: 10,
                  child: CustomRaisedButton(
                    onPressed: () async {
                      Preferences.uid = studentNotifier.currentStudent.uid;
                      await getExpenseHistory(expenseNotifier).whenComplete(() async {


                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpenseHistoryView()));

                      });


                    },
                    buttonText: 'View Expenditure History',
                    shadowColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                  ),
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Positioned(
                  bottom: 20,
                  right: 10,
                  left: 10,
                  child: CustomRaisedButton(
                    onPressed: () async {
                      await DBOperations(uid: studentNotifier.currentStudent.uid, context: context).updateVerification(!studentNotifier.currentStudent.isAccountVerified).whenComplete(() {

                        setState(() {
                          isBlocked = !studentNotifier.currentStudent.isAccountVerified;
                        });
                        //show dialog

                      });

                    },
                    buttonText: isBlocked ? 'Unblock Account' : 'Block Account',
                    shadowColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void revealDialog(title) async{
    await showDialog(context: context,
        builder: (BuildContext context) {
          return GeneralDialog(
            onPressed: () {
              Navigator.of(context).pop();

            },
            buttonText: 'Continue',
            subtext: isBlocked? 'You have blocked the account for ' + studentNotifier.currentStudent.name! + ' student number: ${studentNotifier.currentStudent.studentNumber}' : 'You have unblocked the account for ' + studentNotifier.currentStudent.name! + ' student number: ${studentNotifier.currentStudent.studentNumber}',
            title: isBlocked ? 'Account Blocked' : 'Account Unblocked',
          );
        });
  }
}
