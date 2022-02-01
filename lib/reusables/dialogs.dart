import 'package:stallet/config/images.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:flutter/material.dart';

class GeneralDialog extends StatefulWidget {

  final String title, subtext, buttonText;
  final VoidCallback onPressed;

  GeneralDialog({Key? key, required this.title, required this.subtext, required this.buttonText, required this.onPressed}) : super(key: key);

  @override
  _GeneralDialogState createState() => _GeneralDialogState();
}

class _GeneralDialogState extends State<GeneralDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.elasticInOut,
      child: Container(
        height: 30 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            gradient: LinearGradient(
                colors: <Color>[
                  Colors.grey[300]!,
                  Colors.white,
                  Colors.grey[300]!,
                ]
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.grey,offset: Offset(0,10),
                  blurRadius: 10
              ),
            ]
        ),
        child: Column(
          children: [
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
            Text(widget.title, style: AppTheme.boldText,),
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(widget.subtext, style: AppTheme.regularText,),
            ),
            SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
            TextButton(
              onPressed: widget.onPressed,
              child: Text(widget.buttonText, style: AppTheme.regularTextBold,),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageDialog extends StatefulWidget {

  final String title, subtext, buttonText;
  final VoidCallback onPressed;

  ImageDialog({Key? key, required this.title, required this.subtext, required this.buttonText, required this.onPressed}) : super(key: key);

  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.elasticInOut,
      child: Container(
        height: 30 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            gradient: LinearGradient(
                colors: <Color>[
                  Colors.grey[300]!,
                  Colors.white,
                  Colors.grey[300]!,
                ]
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.grey,offset: Offset(0,10),
                  blurRadius: 10
              ),
            ]
        ),
        child: Column(
          children: [
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
            Text(widget.title, style: AppTheme.boldText,),
            SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(widget.subtext, style: AppTheme.regularText,),
            ),
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
            Image.asset(Images.fingerprintImage, height: 5.5 * SizeConfig.imageSizeMultiplier, width: 5.5 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
            SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
            Text('Touch the fingerprint sensor', style: AppTheme.regularText,),
            TextButton(
              onPressed: widget.onPressed,
              child: Text(widget.buttonText, style: AppTheme.regularTextBold,),
            ),
          ],
        ),
      ),
    );
  }
}