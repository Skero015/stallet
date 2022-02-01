import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/reusables/dialogs.dart';
import 'package:stallet/views/menu_view.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:stallet/views/purchase/confirm_payment_view.dart';

class MakePaymentView extends StatefulWidget {
  const MakePaymentView({Key? key}) : super(key: key);

  @override
  _MakePaymentViewState createState() => _MakePaymentViewState();
}

class _MakePaymentViewState extends State<MakePaymentView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyMakePayment = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyMakePayment');

  final GlobalKey _safeArea = GlobalKey();

  TextEditingController _textFieldController = TextEditingController();

  late FocusNode myFocusNode;

  late String _shopName;

  late bool hasScanned = false;

  late double amount;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    scanQR().then((value) => {

      if(_shopName != "-1"){

        _displayTextInputDialog(context).whenComplete(() {

          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfirmPayView(amount: amount, shopName: _shopName,)));
        })

      }else{
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuView()))
      }
      // _tagID != "-1" ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfirmPayView()))
      //   : Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuView()))

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
        key: _scaffoldKeyMakePayment,
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
                    SizedBox(width: 12 * SizeConfig.widthMultiplier,),
                    Center(child: Text('Make Payment', style: AppTheme.boldText,)),
                  ],
                ),
                SizedBox(height: 8 * SizeConfig.heightMultiplier,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Text('Select a payment method below.',
                      style: AppTheme.outlierText,textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(height: 6 * SizeConfig.heightMultiplier,),

              ],
            ),
          ),
        )
    );
  }

  Widget walletCard(int index, String name) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {


          },
          child: Container(
            height: 8 * SizeConfig.heightMultiplier,
            width: 16 * SizeConfig.widthMultiplier,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
            decoration: BoxDecoration(
              color: name.toLowerCase().contains('qr') ? Color(0xFFD255F1) : Color(0xFFF4BD51),
              borderRadius: BorderRadius.all(Radius.circular(15),),
            ),
            child: Image.asset(name.toLowerCase().contains('qr') ?
            Images.qrImage : Images.bankCardImage, height: 5.5 * SizeConfig.imageSizeMultiplier, width: 5.5 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
          ),
        ),
        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
        Text(name, style: AppTheme.regularText, overflow: TextOverflow.visible),
      ],
    );
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _shopName = barcodeScanRes;

      if(_shopName == "-1"){
        hasScanned = false;
      }
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pay ' + _shopName.trim()),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Amount in rands"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                amount = double.parse(_textFieldController.text.trim());
                print(_textFieldController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void revealDialog(title) async{
    await showDialog(context: context,
        builder: (BuildContext context) {
          return ImageDialog(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuView()));

            },
            buttonText: 'Continue',
            subtext: '$amount to $_shopName',
            title: 'Approve Payment',
          );
        });
  }
}
