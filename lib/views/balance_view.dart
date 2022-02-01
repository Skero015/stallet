import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/notifiers/expense_notifier.dart';
import 'package:stallet/notifiers/subWallet_notifier.dart';
import 'package:stallet/views/home_view.dart';

class BalanceView extends StatefulWidget {

  String walletName;

  BalanceView({Key? key, required this.walletName}) : super(key: key);

  @override
  _BalanceViewState createState() => _BalanceViewState();
}

class _BalanceViewState extends State<BalanceView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyBalance = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyBalance');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  late ExpenseNotifier expenseNotifier;

  late SubwalletNotifier subwalletNotifier;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);

    subwalletNotifier = Provider.of<SubwalletNotifier>(context, listen: false);

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
      key: _scaffoldKeyBalance,
      backgroundColor: Color(0xFFEFEFEF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 40 * SizeConfig.heightMultiplier,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios, size: 25, color: Colors.black87,),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeView()));

                          }
                      ),
                      SizedBox(width: widget.walletName.contains("Allowance") ? 24 * SizeConfig.widthMultiplier : 30 * SizeConfig.widthMultiplier,),
                      Center(child: Text(widget.walletName, style: AppTheme.boldText,)),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Center(child: Text('Total Allowance Paid', style: AppTheme.regularText,)),
                  SizedBox(height: 1.2 * SizeConfig.heightMultiplier,),
                  Center(child: Text('R'+ subwalletNotifier.currentWallet.totalPaid.toStringAsFixed(2), style: AppTheme.mainBoldHeader,)),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                  Center(child: Text('Total Allowance Used', style: AppTheme.regularText,)),
                  SizedBox(height: 1.2 * SizeConfig.heightMultiplier,),
                  Center(child: Text('R'+ subwalletNotifier.currentWallet.totalUsed.toStringAsFixed(2), style: AppTheme.mainBoldHeader,)),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Center(child: Text('= R'+ subwalletNotifier.currentWallet.remainingAmount.toStringAsFixed(2) +' left', style: AppTheme.regularText,)),
                  SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 368,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(15),),
              ),
              child: Padding(
                key: _safeArea,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.5 * SizeConfig.heightMultiplier,),
                    Text('Transactions', style: AppTheme.regularText, overflow: TextOverflow.visible),
                    SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                    FadeInRight(
                      child: SizedBox(
                        height: 8 * SizeConfig.heightMultiplier,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: expenseNotifier.expenseList.isNotEmpty ? expenseNotifier.expenseList.length : 0,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: expenseNotifier.expenseList[index].walletName.toLowerCase().contains(widget.walletName.toLowerCase()) ? transaction(index) : Container(),
                              );
                            }
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * SizeConfig.heightMultiplier,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transaction(int index, ) {
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
            child: Image.asset(Images.booksImage, height: 5.5 * SizeConfig.imageSizeMultiplier, width: 5.5 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
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
                  Text(expenseNotifier.expenseList[index].shopName, style: AppTheme.regularTextBold, overflow: TextOverflow.visible),
                  SizedBox(width: 28 * SizeConfig.widthMultiplier,),
                  Text('R'+expenseNotifier.expenseList[index].amount.toStringAsFixed(2), style: AppTheme.regularTextBold, overflow: TextOverflow.visible, textAlign: TextAlign.end,),
                ],
              ),
              Text(expenseNotifier.expenseList[index].date.toDate().toString(), style: AppTheme.regularText, overflow: TextOverflow.visible),
            ],
          ),
        ],
      ),
    );
  }

}
