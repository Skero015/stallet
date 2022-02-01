
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/model/Request.dart';
import 'package:stallet/model/SubWallet.dart';
import 'package:stallet/model/Wallet.dart';
import 'package:stallet/notifiers/request_notifier.dart';
import 'package:stallet/notifiers/students_notifier.dart';
import 'package:stallet/notifiers/subWallet_notifier.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';
import 'package:stallet/reusables/custom_raised_button.dart';
import 'package:stallet/services/db_operations.dart';
import 'package:stallet/views/admin/requests_view.dart';

class RequestDetailsView extends StatefulWidget {
  const RequestDetailsView({Key? key}) : super(key: key);

  @override
  _RequestDetailsViewState createState() => _RequestDetailsViewState();
}

class _RequestDetailsViewState extends State<RequestDetailsView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyRequestDetails = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyRequestDetails');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  late StudentNotifier studentNotifier;

  late RequestNotifier requestNotifier;

  late WalletNotifier walletNotifier;

  late SubwalletNotifier subwalletNotifier;

  final TextEditingController _controller = new TextEditingController();

  late bool isSorted;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    studentNotifier = Provider.of<StudentNotifier>(context, listen: false);

    requestNotifier = Provider.of<RequestNotifier>(context, listen: false);

    walletNotifier = Provider.of<WalletNotifier>(context, listen: false);

    subwalletNotifier = Provider.of<SubwalletNotifier>(context, listen: false);

    studentNotifier.currentStudent = studentNotifier.studentList.firstWhere((element) => element.uid == requestNotifier.currentRequest.uid);

    getWallet(studentNotifier.currentStudent.uid, walletNotifier).whenComplete(() {
      getInnerWallets(studentNotifier.currentStudent.uid, subwalletNotifier);
    });

    if(requestNotifier.currentRequest.type.toLowerCase().contains('allowance')){
      subwalletNotifier.currentWallet = subwalletNotifier.subwalletList.firstWhere((element) => element.name.toLowerCase().contains('allowance') );
    }else if(requestNotifier.currentRequest.type.toLowerCase().contains('book')){
      subwalletNotifier.currentWallet = subwalletNotifier.subwalletList.firstWhere((element) => element.name.toLowerCase().contains('book') );
    }else{
      subwalletNotifier.currentWallet = subwalletNotifier.subwalletList.firstWhere((element) => element.name.toLowerCase().contains('rent') );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ProgressHUD(
          child: SafeArea(
            child: Padding(
              key: _safeArea,
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Column(
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
                          SizedBox(width: 15 * SizeConfig.widthMultiplier,),
                          Center(
                            child: Text('Request Details', style: AppTheme.boldText,),
                          ),
                        ],
                      ),
                      SizedBox(height: 6 * SizeConfig.heightMultiplier,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 7.5 * SizeConfig.heightMultiplier,
                          width: 15 * SizeConfig.widthMultiplier,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
                          decoration: BoxDecoration(
                            color: requestNotifier.currentRequest.type.toLowerCase().contains('allowance') ? Color(0xFF38AAFD) : requestNotifier.currentRequest.type.toLowerCase().contains('book') ? Color(0xFFD255F1) : Color(0xFFFCC459),
                            borderRadius: BorderRadius.all(Radius.circular(15),),
                          ),
                          child: Image.asset(requestNotifier.currentRequest.type.toLowerCase().contains('allowance') ? Images.walletImage : requestNotifier.currentRequest.type.toLowerCase().contains('book') ? Images.booksImage : Images.rentImage, height: 5.5 * SizeConfig.imageSizeMultiplier, width: 5.5 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 90,
                    right: 10,
                    left: 10,
                    child: CustomRaisedButton(
                      onPressed: () async {

                        final progress = ProgressHUD.of(_safeArea.currentContext!);
                        progress!.show();

                        isSorted = false;
                        await DBOperations(uid: studentNotifier.currentStudent.uid, context: context).updateRequest(isSorted, requestNotifier.currentRequest.requestId).whenComplete(() async {

                          await getPaymentRequests(requestNotifier).whenComplete(() {

                            progress.dismiss();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminRequestsView()));

                          });
                        });

                      },
                      buttonText: 'Deny Request',
                      shadowColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    left: 10,
                    child: CustomRaisedButton(
                      onPressed: () async {

                        final progress = ProgressHUD.of(_safeArea.currentContext!);
                        progress!.show();

                        isSorted = true;
                        await DBOperations(uid: studentNotifier.currentStudent.uid, context: context).updateRequest(isSorted, requestNotifier.currentRequest.requestId).whenComplete(() async {

                          await DBOperations(uid: studentNotifier.currentStudent.uid, context: context).updateWalletFromRequest(walletNotifier.currentWallet, subwalletNotifier.currentWallet, 1700.01).whenComplete(() async {

                            await getPaymentRequests(requestNotifier).whenComplete(() {

                              progress.dismiss();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminRequestsView()));

                            });
                          });
                        });
                      },
                      buttonText: 'Accept Request',
                      shadowColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
