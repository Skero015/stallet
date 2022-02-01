import 'package:flutter/material.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/reusables/custom_raised_button.dart';
import 'package:stallet/services/auth_services.dart';
import 'package:stallet/views/admin/search_view.dart';
import 'package:stallet/views/auth/login_view.dart';
import 'package:stallet/views/menu_view.dart';

class SettingsView extends StatefulWidget {

  String page;

  SettingsView({Key? key, required this.page}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  final GlobalKey<ScaffoldState> _scaffoldKeySettings = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeySettings');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  final TextEditingController _limitAmount = new TextEditingController();

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
      key: _scaffoldKeySettings,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios, size: 25, color: Colors.black87,),
                          onPressed: () {

                            if(widget.page.toLowerCase().contains('admin')){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchView()));

                            }else{

                            }

                          }
                      ),
                      SizedBox(width: 24 * SizeConfig.widthMultiplier,),
                      Center(child: Text('Settings', style: AppTheme.boldText,)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
            Center(child: Text('Settings', style: AppTheme.boldText,)),
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
            //turn notifications on and off
            //other settings
            Positioned(
              bottom: 40,
              right: 10,
              left: 10,
              child: CustomRaisedButton(
                onPressed: () async {
                  await Auth().signOutUser();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginView()));

                },
                buttonText: 'Sign Out',
                shadowColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
