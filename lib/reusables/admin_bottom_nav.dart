
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/views/admin/requests_view.dart';
import 'package:stallet/views/admin/search_view.dart';
import 'package:stallet/views/home_view.dart';
import 'package:stallet/views/menu_view.dart';
import 'package:stallet/views/purchase/make_payment.dart';
import 'package:stallet/views/settings_view.dart';

bool isHomeSearchClicked = true, isRequestsClicked = false, isSettingsClicked = false;

class AdminBottomNavigation extends StatefulWidget {

  BuildContext context;
  AdminBottomNavigation(this.context);

  @override
  _AdminBottomNavigationState createState() => _AdminBottomNavigationState();
}

class _AdminBottomNavigationState extends State<AdminBottomNavigation> {

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
                  icon: isHomeSearchClicked? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100),),
                        border: Border.all(color: Colors.grey.shade800)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(Images.searchImage, height: 7 * SizeConfig.imageSizeMultiplier, width: 7 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ) : Image.asset(Images.searchImage, height: 7 * SizeConfig.imageSizeMultiplier, width: 7 * SizeConfig.imageSizeMultiplier,),
                  onPressed: () {
                    // check if all others are clicked, if none of them are clicked, don't change icon.
                    setState(() {
                      isHomeSearchClicked = true;
                      isRequestsClicked = false;
                      isSettingsClicked = false;
                    });

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchView(),
                    ));
                  }
              ),
              IconButton(
                  icon: isRequestsClicked ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100),),
                        border: Border.all(color: Colors.grey.shade800)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(Images.articleBlackImage, height: 7 * SizeConfig.imageSizeMultiplier, width: 7 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ) : Image.asset(Images.articleBlackImage, height: 6.5 * SizeConfig.imageSizeMultiplier, width: 6.5 * SizeConfig.imageSizeMultiplier,),
                  onPressed: () {

                    setState(() {
                      isHomeSearchClicked = false;
                      isRequestsClicked = true;
                      isSettingsClicked = false;
                    });

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminRequestsView()));

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
                      isHomeSearchClicked = false;
                      isRequestsClicked = false;
                      isSettingsClicked = true;
                    });

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsView(page: 'admin',),));

                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}