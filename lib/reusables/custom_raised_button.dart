import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:flutter/material.dart';

class CustomRaisedButton extends StatefulWidget {

  VoidCallback? onPressed;
  MaterialStateProperty<Color> shadowColor;
  String buttonText;
  bool? isInRow;
  CustomRaisedButton({Key? key, @required this.onPressed, required this.buttonText, required this.shadowColor, this.isInRow} ) : super(key: key);

  @override
  _CustomRaisedButtonState createState() => _CustomRaisedButtonState();
}

class _CustomRaisedButtonState extends State<CustomRaisedButton> {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      child: Ink(//The Ink widget allowed us to decorate the button as we wish (we needed to use it for the color gradients) .
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[
                widget.buttonText.contains('Deny') ? Colors.redAccent[700]! : AppTheme.mainColorSecondaryBlue,
                widget.buttonText.contains('Deny') ? Colors.redAccent : AppTheme.mainColorSecondaryBlue,
                widget.buttonText.contains('Deny') ? Colors.redAccent[700]! : AppTheme.mainColorBlue,
              ]
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Container(
            width: widget.isInRow != null ? MediaQuery.of(context).size.width - (18 * SizeConfig.widthMultiplier) : MediaQuery.of(context).size.width - (5 * SizeConfig.widthMultiplier),
            constraints: const BoxConstraints(minWidth: 45.0, minHeight: 55),
            alignment: Alignment.center,
            child: Text(widget.buttonText,textAlign: TextAlign.center, style: AppTheme.regularTextWhite)),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        elevation: MaterialStateProperty.all<double>(9.0),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(0)),
        shadowColor: widget.shadowColor,
      ),
    );
  }
}