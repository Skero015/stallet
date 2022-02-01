
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/notifiers/expense_notifier.dart';
import 'package:stallet/notifiers/subWallet_notifier.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';

class ExpenseHistoryView extends StatefulWidget {
  const ExpenseHistoryView({Key? key}) : super(key: key);

  @override
  _ExpenseHistoryViewState createState() => _ExpenseHistoryViewState();
}

class _ExpenseHistoryViewState extends State<ExpenseHistoryView> {

  late WalletNotifier walletNotifier;
  late SubwalletNotifier subwalletNotifier;
  late ExpenseNotifier expenseNotifier;

  @override
  void initState() {
    super.initState();

    expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);

    walletNotifier = Provider.of<WalletNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios, size: 25,
                            color: Colors.black87,),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }
                      ),
                      SizedBox(width: 12 * SizeConfig.widthMultiplier,),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Expenditure History', style: AppTheme.boldText,),
                            Text(
                              'Wallet no: ' + walletNotifier.currentWallet.walletId, style: AppTheme.regularTextBold,),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5 * SizeConfig.heightMultiplier,),
                  expenseNotifier.expenseList.isNotEmpty ? FadeInRight(
                    child: SizedBox(
                      height: 8 * SizeConfig.heightMultiplier,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: expenseNotifier.expenseList.isNotEmpty ? expenseNotifier.expenseList.length : 0,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: transaction(index),
                            );
                          }
                      ),
                    ),
                  ) : Center(child: Text('No expenditure history to show'),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget transaction(int index,) {
    return GestureDetector(
      onTap: () {

      },
      child: Row(
        children: [
          Container(
            height: 7.5 * SizeConfig.heightMultiplier,
            width: 15 * SizeConfig.widthMultiplier,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
            decoration: BoxDecoration(
              color: Color(0xFFD255F1).withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(15),),
            ),
            child: Image.asset(
              Images.tickImage, height: 5.5 * SizeConfig.imageSizeMultiplier,
              width: 5.5 * SizeConfig.imageSizeMultiplier,
              fit: BoxFit.fill,),
          ),
          SizedBox(width: 5 * SizeConfig.widthMultiplier,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(expenseNotifier.expenseList[index].shopName,
                      style: AppTheme.regularTextBold,
                      overflow: TextOverflow.visible),
                  SizedBox(width: 28 * SizeConfig.widthMultiplier,),
                  Text('R' +
                      expenseNotifier.expenseList[index].amount.toStringAsFixed(
                          2), style: AppTheme.regularTextBold,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.end,),
                ],
              ),
              Text(expenseNotifier.expenseList[index].date.toDate().toString(),
                  style: AppTheme.regularText, overflow: TextOverflow.visible),
            ],
          ),
        ],
      ),
    );
  }
}
