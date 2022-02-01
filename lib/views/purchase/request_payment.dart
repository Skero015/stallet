import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/preferences.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/notifiers/user_notifier.dart';
import 'package:stallet/reusables/dialogs.dart';
import 'package:stallet/services/db_operations.dart';
import 'package:stallet/views/home_view.dart';
import 'package:stallet/views/menu_view.dart';

class RequestPaymentView extends StatefulWidget {
  const RequestPaymentView({Key? key}) : super(key: key);

  @override
  _RequestPaymentViewState createState() => _RequestPaymentViewState();
}

class _RequestPaymentViewState extends State<RequestPaymentView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyRequest = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyRequest');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  //late MailgunMailer mailgun;

  late UserNotifier userNotifier;
  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    userNotifier = Provider.of<UserNotifier>(context, listen: false);

    //mailgun = MailgunMailer(domain: "sandbox34d37e7bfbd24187b015203924961775.mailgun.org", apiKey: "3b0190bdd2a5bb14a194d1884bdee0cb-4de08e90-c78c9fa0");
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
        key: _scaffoldKeyRequest,
        backgroundColor: Colors.white,
        body: ProgressHUD(
          child: SafeArea(
            child: Padding(
              key: _safeArea,
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
                      SizedBox(width: 12 * SizeConfig.widthMultiplier,),
                      Center(child: Text('Request Payment', style: AppTheme.boldText,)),
                    ],
                  ),
                  SizedBox(height: 9 * SizeConfig.heightMultiplier,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:  10.0),
                    child: Column(
                      children: [
                        Text('Did not receive payment?\nChoose the type of payment you are'
                            ' requesting below then confirm.',
                            style: AppTheme.regularText, overflow: TextOverflow.visible),
                        SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                        transaction('Monthly Allowance', Images.walletImage, Color(0xFF38AAFD)),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                        transaction('Book Allowance', Images.booksImage, Color(0xFFD255F1)),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                        transaction('Rent Allowance', Images.rentImage, Color(0xFFFCC459)),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget transaction(String title, String image, Color backgroundColor) {
    return GestureDetector(
      onTap: () async {

        final progress = ProgressHUD.of(_safeArea.currentContext!);
        progress!.show();

        if(title.toLowerCase().contains('monthly')){
          await DBOperations(uid: Preferences.uid, context: context).addRequest("Allowance").whenComplete(() {
            progress.dismiss();
            revealDialog(title);
          });

          // sendEmail('Monthly').whenComplete(() async {
          //   revealDialog(title);
          // });
        }else if(title.toLowerCase().contains('book')){
          await DBOperations(uid: Preferences.uid, context: context).addRequest("Books").whenComplete(() {
            progress.dismiss();
            revealDialog(title);
          });
          // sendEmail('Book').then((value) {
          //   revealDialog(title);
          // });
        }else{
          await DBOperations(uid: Preferences.uid, context: context).addRequest("Rent").whenComplete(() {
            progress.dismiss();
            revealDialog(title);
          });
          // sendEmail('Rent').then((value) {
          //   revealDialog(title);
          // });
        }

      },
      child: Row(
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
          Text(title, style: AppTheme.regularTextBold, overflow: TextOverflow.visible),
        ],
      ),
    );
  }

  Future<void> sendEmail(String title) async {

    const GMAIL_SCHEMA = 'com.google.android.gm';

    final bool gmailinstalled =  await DeviceApps.isAppInstalled(GMAIL_SCHEMA);

    // if(gmailinstalled) {
    //   final MailOptions mailOptions = MailOptions(
    //     body: 'Dear Finance, <br> I, ' + Preferences.currentUser.displayName! + ', have not received payment for the month.' +
    //                '. <br><br>'
    //                'Student number: ' + userNotifier.currentUser.studentNumber! +
    //                '<br>Score: ' + userNotifier.currentUser.score.toString() +
    //                '<br><br>Contact: ' + Preferences.currentUser.email!,
    //     subject: title + ' Allowance Request: ' + Preferences.currentUser.displayName!,
    //     recipients: ['seimakamogelo@gmail.com'],
    //     isHTML: true,
    //     appSchema: GMAIL_SCHEMA,
    //   );
    //   await FlutterMailer.send(mailOptions);
    // }

    // var response = await mailgun.send(
    //   from: Preferences.currentUser.displayName + ' <' + Preferences.currentUser.email + '>',
    //   to: ['seimakamogelo@gmail.com',],
    //   subject: title + ' Allowance Request: ' + Preferences.currentUser.displayName,
    //   html: 'Dear Finance, <br> I, ' + Preferences.currentUser.displayName + ', have not received payment for the month.' +
    //       '. <br><br>'
    //       'Student number: ' + userNotifier.currentUser.studentNumber! +
    //       '<br>Score: ' + userNotifier.currentUser.score.toString() +
    //       '<br><br>Contact: ' + Preferences.currentUser.email,);
    //
    // print(response.message);
    // print(response.status.toString());

    String username = 'seimakamogelo@gmail.com';
    String password = '';

    final smtpServer = gmailRelaySaslXoauth2(username, password);

    final message = Message()
      ..from = Address(username, 'Kamogelo Seima')
      ..recipients.add('seimakamogelo@gmail.com')
      ..subject = '$title Allowance Request From ${Preferences.currentUser.displayName}'
      ..text = 'Dear Finance, <br> I, ${Preferences.currentUser.displayName} have not received payment for the month.'
          '. <br><br>'
              'Student number: ${userNotifier.currentUser.studentNumber!} <br>Score: ${userNotifier.currentUser.score.toString()}'
          '<br><br>Contact: ${Preferences.currentUser.email}';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent: ' + e.message);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  void revealDialog(title) async{
    await showDialog(context: context,
        builder: (BuildContext context) {
      return GeneralDialog(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuView()));

        },
        buttonText: 'Continue',
        subtext: 'Your request for your ' + title +
            ' has been sent successfully. You will be contacted soon.',
        title: 'Request Sent',
      );
    });
  }
}
