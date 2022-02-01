
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/model/ExpenseHistory.dart';
import 'package:stallet/model/SubWallet.dart';
import 'package:stallet/model/Wallet.dart';
import 'package:stallet/notifiers/expense_notifier.dart';
import 'package:stallet/notifiers/subWallet_notifier.dart';
import 'package:stallet/notifiers/user_notifier.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';
import 'package:stallet/reusables/custom_bottom_nav.dart';
import 'package:stallet/views/balance_view.dart';
import 'package:stallet/views/budget_limit_view.dart';
import 'package:animate_do/animate_do.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyHome = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyHome');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  late UserNotifier userNotifier;

  late ExpenseNotifier expenseNotifier;

  late SubwalletNotifier subwalletNotifier;

  late WalletNotifier walletNotifier;


  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    userNotifier = Provider.of<UserNotifier>(context, listen: false);

    expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);

    subwalletNotifier = Provider.of<SubwalletNotifier>(context, listen: false);

    walletNotifier = Provider.of<WalletNotifier>(context, listen: false);

    getWallet(userNotifier.currentUser.uid, walletNotifier).whenComplete(() {
      getInnerWallets(userNotifier.currentUser.uid, subwalletNotifier);
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
      key: _scaffoldKeyHome,
      backgroundColor: Color(0xFFEFEFEF),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: 5 * SizeConfig.heightMultiplier,),
                  FadeInDown(
                    child: Column(
                      children: [
                        SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                        Center(child: Text('Current balance', style: AppTheme.regularText,)),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                        Text("R"+walletNotifier.currentWallet.remainingAmount.toStringAsFixed(2), style: AppTheme.mainBoldHeader,),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        FutureBuilder(
                          future: getInnerWallets(Preferences.uid, subwalletNotifier),
                          builder: (context, snapshot) {

                            if(snapshot.connectionState == ConnectionState.done){
                              return FadeInRight(
                                child: SizedBox(
                                  height: 14.5 * SizeConfig.heightMultiplier,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                          child: walletCard(index, subwalletNotifier.subwalletList[index].name.trim()),
                                        );
                                      }
                                  ),
                                ),
                              );
                            }else{
                              return Container();
                            }

                          }
                        ),
                      ],
                    ),
                  ),
                  FadeInUp(
                    child: Column(
                      children: [
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        Container(
                          height: MediaQuery.of(context).size.height - 350,
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
                                FutureBuilder(
                                  initialData: expenseNotifier.expenseList.isEmpty ? [] : expenseNotifier.expenseList,
                                    future: expenseNotifier.expenseList.isEmpty ? getExpenseHistory(expenseNotifier) : null,
                                    builder: (context, AsyncSnapshot snapshot) {

                                      if(expenseNotifier.expenseList.isNotEmpty || snapshot.connectionState == ConnectionState.done){
                                        return FadeInRight(
                                          child: SizedBox(
                                            height: 8 * SizeConfig.heightMultiplier,
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount: expenseNotifier.expenseList.isNotEmpty ? expenseNotifier.expenseList.length : snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                    child: transaction(index),
                                                  );
                                                }
                                            ),
                                          ),
                                        );
                                      }else{
                                        return Container();
                                      }

                                    }
                                ),
                                SizedBox(height: 4.5 * SizeConfig.heightMultiplier,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavigation(context),
            ),
          ],
        )
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
            child: Image.asset(Images.tickImage, height: 5.5 * SizeConfig.imageSizeMultiplier, width: 5.5 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
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

  Widget walletCard(int index, String name) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {

            subwalletNotifier.currentWallet = subwalletNotifier.subwalletList[index];
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BalanceView(walletName: name,)));
          },
          child: Container(
            height: 8 * SizeConfig.heightMultiplier,
            width: 16 * SizeConfig.widthMultiplier,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
            decoration: BoxDecoration(
              color: name.toLowerCase().contains('allowance') ?
              Color(0xFF00C2FF) : name.toLowerCase().contains('book') ? Color(0xFFD255F1) : Color(0xFFF4BD51),
              borderRadius: BorderRadius.all(Radius.circular(15),),
            ),
            child: Image.asset(name.toLowerCase().contains('allowance') ?
            Images.walletImage : name.toLowerCase().contains('book') ? Images.booksImage : Images.rentImage, height: 5.5 * SizeConfig.imageSizeMultiplier, width: 5.5 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
          ),
        ),
        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
        Text(name, style: AppTheme.regularText, overflow: TextOverflow.visible),
      ],
    );
  }
}
