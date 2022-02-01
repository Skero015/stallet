import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/config/validators.dart';
import 'package:stallet/notifiers/expense_notifier.dart';
import 'package:stallet/notifiers/user_notifier.dart';
import 'package:stallet/reusables/custom_raised_button.dart';
import 'package:stallet/reusables/dialogs.dart';
import 'package:stallet/services/db_operations.dart';
import 'package:stallet/views/home_view.dart';
import 'package:stallet/views/menu_view.dart';

class BudgetLimitView extends StatefulWidget {
  const BudgetLimitView({Key? key}) : super(key: key);

  @override
  _BudgetLimitViewState createState() => _BudgetLimitViewState();
}

class _BudgetLimitViewState extends State<BudgetLimitView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyBudgetLimit = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyBudgetLimit');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  final TextEditingController _limitAmount = new TextEditingController();

  late UserNotifier userNotifier;

  late ExpenseNotifier expenseNotifier;

  double totalSpent = 0;

  double budgetLimit = 0;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    userNotifier = Provider.of<UserNotifier>(context, listen: false);

    expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);

    expenseNotifier.expenseList.forEach((expense) {

      totalSpent += expense.amount;
    });

    budgetLimit = userNotifier.currentUser.budgetLimit['amount'];
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
      key: _scaffoldKeyBudgetLimit,
      backgroundColor: Colors.white,
      body: SafeArea(
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
                      SizedBox(width: 15 * SizeConfig.widthMultiplier,),
                      Center(child: Text('Set Budget Limit', style: AppTheme.boldText,)),
                    ],
                  ),
                  SizedBox(height: 9 * SizeConfig.heightMultiplier,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text('Set a budget limit for your account. You will be notified whenever you are close to reaching'
                        'your budget limit.',
                        style: AppTheme.regularText, overflow: TextOverflow.visible),
                  ),
                  SizedBox(height: 5 * SizeConfig.heightMultiplier,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text('Your current budget limit is set at: R${budgetLimit.toStringAsFixed(2)}',
                        style: AppTheme.regularText, overflow: TextOverflow.visible),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text('Your spend for the month is at: R$totalSpent',
                        style: AppTheme.regularText, overflow: TextOverflow.visible),
                  ),
                  SizedBox(height: 8 * SizeConfig.heightMultiplier,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      validator: Validator.validateNumber,
                      controller: _limitAmount,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter budget limit amount',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
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
                onPressed: () async {

                  await DBOperations(uid: Preferences.uid, context: context).updateBudgetLimit(double.parse(_limitAmount.text.trim()), DateTime.now()).whenComplete(() async {

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

                },
                buttonText: 'Confirm',
                shadowColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
