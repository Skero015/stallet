
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/reusables/custom_bottom_nav.dart';
import 'package:stallet/views/balance_view.dart';
import 'package:stallet/views/budget_limit_view.dart';
import 'package:stallet/views/check_score_view.dart';
import 'package:stallet/views/purchase/make_payment.dart';
import 'package:stallet/views/purchase/request_payment.dart';
import 'package:stallet/views/purchase/set_auto_payment.dart';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyMenu = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyHome');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

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
      key: _scaffoldKeyMenu,
      backgroundColor: Color(0xFFEFEFEF),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                    Center(child: Text('Menu', style: AppTheme.boldText,)),
                    SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Shortcuts', style: AppTheme.regularText,),
                    ),
                    SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                    FadeInDown(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                            menu('Allowance Review', Images.walletImage, Color(0xFF38AAFD)),
                            menu('Book Allowance Review', Images.booksImage, Color(0xFFD255F1)),
                            menu('Rent Review', Images.rentImage, Color(0xFFFCC459)),
                            menu('Make Payment', Images.bankCardImage, Color(0xFFE4A5F4).withOpacity(0.5)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Other Menu', style: AppTheme.regularText,),
                    ),
                    SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                    FadeInUp(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                            menu('Request Payment', Images.articleImage, Color(0xFFFC5252)),
                            menu('Check Score', Images.articleImage, Color(0xFF885FFF)),
                            menu('Set Auto Payments', Images.tickImage, Color(0xFF06D133)),
                            menu('Set Budget Limit', Images.tickImage, Color(0xFF38AAFD)),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavigation(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget menu(String title, String image, Color backgroundColor) {
    return GestureDetector(
      onTap: () {
        if(title.toLowerCase().contains('book') || title.toLowerCase().contains('allowance') || title.toLowerCase().contains('rent')){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BalanceView(walletName: title,)));

        }else if(title.toLowerCase().contains('make')){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MakePaymentView()));

        }else if(title.toLowerCase().contains('request')){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestPaymentView()));

        }else if(title.toLowerCase().contains('score')){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CheckScoreView()));

        }else if(title.toLowerCase().contains('auto')){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetAutoPayments()));

        }else{
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BudgetLimitView()));

        }
      },
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 5.5 * SizeConfig.heightMultiplier,
                  width: 12 * SizeConfig.widthMultiplier,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(15),),
                  ),
                  child: Image.asset(image, height: 10 * SizeConfig.imageSizeMultiplier, width: 10 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
                ),
              ),
              SizedBox(width: 5 * SizeConfig.widthMultiplier,),
              Text(title, style: AppTheme.regularText, overflow: TextOverflow.visible),
            ],
          ),
          SizedBox(height: 1.15 * SizeConfig.heightMultiplier,),
          Divider(color: Colors.grey,),
        ],
      ),
    );
  }
}
