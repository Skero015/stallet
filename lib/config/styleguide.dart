import 'package:stallet/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{
  AppTheme._();

  static const Color appBackgroundColor = Color(0xFFFFFFFF);
  static const Color mainColorBlue = Color(0xFF0C38D1);
  static const Color mainColorSecondaryBlue = Color(0xFF325BEC);
  static const Color secondaryColorOrangeLight = Color(0xFFDF963F);
  static const Color secondaryColorOrange = Color(0xFFD08845);
  static const Color secondaryColorOrange2 = Color(0xFFEC7532);
  static const Color regularTextColor = Color(0xFF494949);
  static const Color secondaryTextColor = Color(0xFF8F8F8F);

  static final TextStyle logoBoldHeader = GoogleFonts.yatraOne(
    fontSize: 6 * SizeConfig.textMultiplier,
    color: mainColorSecondaryBlue,
    height: 1.2,
    wordSpacing: 1.1,
    letterSpacing: 1.5,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle mainBoldHeader = GoogleFonts.roboto(
    fontSize: 4 * SizeConfig.textMultiplier,
    color: mainColorBlue,
    height: 1.2,
    wordSpacing: 1.1,
    letterSpacing: 1.1,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle mainBoldHeaderWhite = GoogleFonts.roboto(
    fontSize: 4 * SizeConfig.textMultiplier,
    color: Colors.white,
    height: 1.2,
    wordSpacing: 1.1,
    letterSpacing: 1.1,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle secondaryBoldHeader = GoogleFonts.roboto(
    fontSize: 3 * SizeConfig.textMultiplier,
    color: Colors.black.withOpacity(0.8),
    height: 1.2,
    wordSpacing: 1.1,
    letterSpacing: 1.1,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle tertiaryHeader = GoogleFonts.roboto(
    fontSize: 2.3 * SizeConfig.textMultiplier,
    color: Colors.black.withOpacity(0.8),
    height: 1.2,
    wordSpacing: 1.1,
    letterSpacing: 1.1,
  );
  static final TextStyle tertiaryBoldHeader = GoogleFonts.roboto(
    fontSize: 2.3 * SizeConfig.textMultiplier,
    color: Colors.black.withOpacity(0.8),
    height: 1.2,
    wordSpacing: 1.1,
    letterSpacing: 1.1,
    fontWeight: FontWeight.w900,
  );
  static final TextStyle regularText = GoogleFonts.roboto(
    fontSize: 1.8 * SizeConfig.textMultiplier,
    color: regularTextColor,
    letterSpacing: 1.03,
  );
  static final TextStyle regularTextBold = GoogleFonts.roboto(
    fontSize: 1.9 * SizeConfig.textMultiplier,
    color: regularTextColor,
    letterSpacing: 1.03,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle boldText = GoogleFonts.roboto(
    fontSize: 2.6 * SizeConfig.textMultiplier,
    color: regularTextColor,
    letterSpacing: 1.03,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle secondaryText = GoogleFonts.poppins(
    fontSize: 1.8 * SizeConfig.textMultiplier,
    color: secondaryTextColor,
    letterSpacing: 1.03,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle outlierText = GoogleFonts.poppins(
    fontSize: 1.8 * SizeConfig.textMultiplier,
    color: secondaryColorOrange,
    letterSpacing: 1.03,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle outlierTextBold = GoogleFonts.roboto(
    fontSize: 1.8 * SizeConfig.textMultiplier,
    color: secondaryColorOrange,
    fontWeight: FontWeight.bold,
    wordSpacing: 1.1,
    letterSpacing: 1.1,
  );
  static final TextStyle descriptionText = GoogleFonts.poppins(
    fontSize: 1.3 * SizeConfig.textMultiplier,
    color: secondaryTextColor,
    letterSpacing: 1.03,
  );


  static final TextStyle regularTextWhite = GoogleFonts.roboto(
    fontSize: 1.8 * SizeConfig.textMultiplier,
    color: appBackgroundColor,
    letterSpacing: 1.03,
  );
  static final TextStyle regularTextWhiteBold = GoogleFonts.roboto(
    fontSize: 2 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.bold,
    color: appBackgroundColor,
    letterSpacing: 1.03,
  );
}