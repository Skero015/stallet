
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/views/home_view.dart';
import 'package:stallet/views/menu_view.dart';
import 'package:stallet/views/purchase/make_payment.dart';
import 'package:stallet/views/settings_view.dart';

bool isHomeClicked = true, isMenuClicked = false, isPayClicked = false, isSettingsClicked = false;

class CustomBottomNavigation extends StatefulWidget {

  BuildContext context;
  CustomBottomNavigation(this.context);

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {

  @override
  Widget build(BuildContext context) {

    return Material(
      elevation: 8.0,
      child: Container(
        color: Colors.white,
        height: 7.8 * SizeConfig.heightMultiplier,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: isHomeClicked? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100),),
                      border: Border.all(color: Colors.grey.shade800)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(Images.homeImage, height: 7 * SizeConfig.imageSizeMultiplier, width: 7 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ) : Image.asset(Images.homeImage, height: 7 * SizeConfig.imageSizeMultiplier, width: 7 * SizeConfig.imageSizeMultiplier,),
                  onPressed: () {
                    // check if all others are clicked, if none of them are clicked, don't change icon.
                    setState(() {
                      isHomeClicked = true;
                      isMenuClicked = false;
                      isPayClicked = false;
                      isSettingsClicked = false;
                    });

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeView(),
                    ));
                  }
              ),
              IconButton(
                  icon: isMenuClicked ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100),),
                        border: Border.all(color: Colors.grey.shade800)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(Images.menuImage, height: 7 * SizeConfig.imageSizeMultiplier, width: 7 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ) : Image.asset(Images.menuImage, height: 6.5 * SizeConfig.imageSizeMultiplier, width: 6.5 * SizeConfig.imageSizeMultiplier,),
                  onPressed: () {

                    setState(() {
                      isHomeClicked = false;
                      isMenuClicked = true;
                      isPayClicked = false;
                      isSettingsClicked = false;
                    });

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuView()));

                  }
              ),
              IconButton(
                  icon: isPayClicked ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100),),
                        border: Border.all(color: Colors.grey.shade800)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(Images.bankCardImage, height: 7 * SizeConfig.imageSizeMultiplier, width: 7 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ) : Image.asset(Images.bankCardImage, height: 7 * SizeConfig.imageSizeMultiplier, width: 7 * SizeConfig.imageSizeMultiplier,),
                  onPressed: () {

                    setState(() {
                      isHomeClicked = false;
                      isMenuClicked = false;
                      isPayClicked = true;
                      isSettingsClicked = false;
                    });

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MakePaymentView()));

                  }
              ),
              IconButton(
                  icon: isSettingsClicked ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100),),
                        border: Border.all(color: Colors.grey.shade800)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(Images.settingsImage, height: 7 * SizeConfig.imageSizeMultiplier, width: 7 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ) : Image.asset(Images.settingsImage, height: 7 * SizeConfig.imageSizeMultiplier, width: 7 * SizeConfig.imageSizeMultiplier,),
                  onPressed: () {

                    setState(() {
                      isHomeClicked = false;
                      isMenuClicked = false;
                      isPayClicked = false;
                      isSettingsClicked = true;
                    });

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsView(page: 'student',),));

                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}