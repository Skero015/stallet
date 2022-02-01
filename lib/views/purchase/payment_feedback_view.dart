import 'package:flutter/material.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/styleguide.dart';

import '../home_view.dart';

class PaymentFeebackView extends StatefulWidget {
  const PaymentFeebackView({Key? key}) : super(key: key);

  @override
  _PaymentFeebackViewState createState() => _PaymentFeebackViewState();
}

class _PaymentFeebackViewState extends State<PaymentFeebackView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyPayFeedback = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyPayFeedback');

  final GlobalKey _safeArea = GlobalKey();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 2000), () async {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) =>
          new HomeView()));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyPayFeedback,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            key: _safeArea,
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('Payment Successful', style: AppTheme.mainBoldHeader,)),
                Center(
                  child: Image(fit: BoxFit.fitWidth,
                    image: AssetImage(Images.tickImage),
                    height: MediaQuery.of(context).size.height -400,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
