import 'package:flutter/material.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/views/menu_view.dart';

class CheckScoreView extends StatefulWidget {
  const CheckScoreView({Key? key}) : super(key: key);

  @override
  _CheckScoreViewState createState() => _CheckScoreViewState();
}

class _CheckScoreViewState extends State<CheckScoreView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyScore = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyScore');

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
        key: _scaffoldKeyScore,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    SizedBox(width: 20 * SizeConfig.widthMultiplier,),
                    Center(child: Text('Check Score', style: AppTheme.boldText,)),
                  ],
                ),
                SizedBox(height: 8 * SizeConfig.heightMultiplier,),
                Text('Your Current Score: 0%', style: AppTheme.boldText,),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Text('You currently do not have a score. '
                        'Make payments and budget well to receive a good score.',
                      style: AppTheme.outlierText,textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(height: 8 * SizeConfig.heightMultiplier,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:  10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total transactions',
                          style: AppTheme.regularText, overflow: TextOverflow.visible),
                      SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                      transaction('Store name', Images.walletImage, Color(0xFF38AAFD)),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      transaction('Store name', Images.booksImage, Color(0xFFD255F1)),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      transaction('Store name', Images.rentImage, Color(0xFFFCC459)),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget transaction(String title, String image, Color backgroundColor) {
    return Row(
      children: [
        Container(
          height: 7.5 * SizeConfig.heightMultiplier,
          width: 15 * SizeConfig.widthMultiplier,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(15),),
          ),
          child: Image.asset(image, height: 5.5 * SizeConfig.imageSizeMultiplier, width: 5.5 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
        ),
        SizedBox(width: 5 * SizeConfig.widthMultiplier,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTheme.regularTextBold, overflow: TextOverflow.visible),
            SizedBox(width: 32 * SizeConfig.widthMultiplier,),
            Text('0.0%', style: AppTheme.regularTextBold, overflow: TextOverflow.visible, textAlign: TextAlign.end,),
          ],
        ),
      ],
    );
  }
}
