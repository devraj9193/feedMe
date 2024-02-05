

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

var bottomBarHeading = 08.dp;
var loginHeading = 20.dp;
var buttonFontSize = 10.dp;
var backButton = 10.dp;
var otpSubHeading = 08.dp;
var registerTextFieldHeading = 10.dp;
var textFieldHintText = 9.dp;
var textFieldText = 10.dp;
var resendTextSize = 11.dp;
var bottomSheetHeadingFontSize = 12.dp;
var listHeadingSize = 13.dp;
var listSubHeadingSize = 10.dp;
var listOtherSize = 9.dp;
var tapSelectedSize = 10.dp;
var tapUnSelectedSize = 10.dp;


const loginButtonColor = Color(0xffE6E6E6);
const loginButtonSelectedColor = Color(0xffF2F2F2);
const policyColor = Color(0xff0082FC);
const gGreyColor = Color(0xff707070);
const gBlackColor = Color(0xff000000);
const gWhiteColor = Color(0xffFFFFFF);
const imageBackGround = Color(0xffB1B1B1);

String textFieldHintFont = kFontMedium;
String textFieldFont = kFontMedium;
String buttonFont = kFontBold;
String resendFont = kFontMedium;
String bottomSheetHeadingFontFamily = kFontBold;
String listHeadingFont = kFontBold;
String listSubHeadingFont = kFontMedium;
String listOtherFont = kFontBook;
String tapFont = kFontMedium;

const textFieldColor = gBlackColor;
const textFieldHintColor = gGreyColor;
const textFieldUnderLineColor = gGreyColor;
const buttonColor = gBlackColor;
const resendDisableColor = gGreyColor;
const resendActiveColor = gSecondaryColor;
const bottomSheetHeadingColor = gBlackColor;
const containerBackGroundColor = loginButtonColor;

const gPrimaryColor = Color(0xff4E7215);

// const gsecondaryColor = Color(0xffC10B02);
// const gsecondaryColor = Color(0xffD10034);
const gSecondaryColor = Color(0xffEE1004);

const gMainColor = Color(0xffC7A102);

const gTextColor = Color(0xff000000);
const gHintTextColor = Color(0xff676363);
const kLineColor = Color(0xffB9B4B4);
const gBgColor = Color(0xffFAFAFA);

const lightTextColor = Color(0xffB9B4B4);

const String kFontMedium = 'GothamMedium';
const String kFontBook = 'GothamBook';
const String kFontBold = 'GothamBold';

const kBottomSheetHeadYellow = Color(0xffFFE281);
const kBottomSheetHeadGreen = Color(0xffA7C652);
const kBottomSheetHeadCircleColor = Color(0xffFFF9F8);

// new dashboard colors
const kNumberCircleRed = Color(0xffEF8484);
const kNumberCirclePurple = Color(0xff9C7ADF);
const kNumberCircleAmber = Color(0xffFFBD59);
const kNumberCircleGreen = Color(0xffA7CB52);

double bottomSheetSubHeadingXLFontSize = 12.sp;
double bottomSheetSubHeadingXFontSize = 11.sp;
double bottomSheetSubHeadingSFontSize = 10.sp;
String bottomSheetSubHeadingBoldFont = kFontBold;
String bottomSheetSubHeadingMediumFont = kFontMedium;
String bottomSheetSubHeadingBookFont = kFontBook;

const bsHeadPinIcon = "assets/images/bs-head-pin.png";
const bsHeadBellIcon = "assets/images/bs-head-bell.png";
const bsHeadBulbIcon = "assets/images/bs-head-bulb.png";
const bsHeadStarsIcon = "assets/images/bs-head-stars.png";



var headingFontSize = 12.sp;
var midSubHeadingFontSize = 11.sp;
var subHeadingFontSize = 10.sp;

var smallFontSize = 8.sp;
var mediumFontSize1 = 9.sp;
var mediumFontSize2 = 10.sp;

TextStyle hintStyle = TextStyle(
    fontSize: mediumFontSize2,
    color: gHintTextColor,
    fontFamily: kFontBook
);

TextStyle fieldTextStyle({Color? color, double? fontSize, String? fontFamily}){
  return TextStyle(
      fontSize: fontSize ?? mediumFontSize2,
      color: color ?? gTextColor,
      fontFamily: fontFamily ?? kFontMedium
  );
}

TextStyle btnTextStyle({Color? color, double? fontSize}){
  return TextStyle(
    fontSize: fontSize ?? mediumFontSize2,
    color: color ?? gWhiteColor,
    fontFamily: kFontMedium,
  );
}

// existing user
class eUser{
  var kRadioButtonColor = gSecondaryColor;
  var threeBounceIndicatorColor = gWhiteColor;

  var mainHeadingColor = gBlackColor;
  var mainHeadingFont = kFontBold;
  double mainHeadingFontSize = 15.dp;

  var userFieldLabelColor =  gBlackColor;
  var userFieldLabelFont = kFontMedium;
  double userFieldLabelFontSize = 15.dp;
  /*
  fontFamily: "GothamBook",
  color: gHintTextColor,
  fontSize: 11.dp
   */
  var userTextFieldColor =  gHintTextColor;
  var userTextFieldFont = kFontBook;
  double userTextFieldFontSize = 13.dp;

  var userTextFieldHintColor =  Colors.grey.withOpacity(0.5);
  var userTextFieldHintFont = kFontMedium;
  double userTextFieldHintFontSize = 13.dp;

  var focusedBorderColor = gBlackColor;
  var focusedBorderWidth = 1.5;

  var fieldSuffixIconColor = gPrimaryColor;
  var fieldSuffixIconSize = 22;

  var fieldSuffixTextColor =  gBlackColor.withOpacity(0.5);
  var fieldSuffixTextFont = kFontMedium;
  double fieldSuffixTextFontSize = 8.dp;

  var resendOtpFontSize = 9.dp;
  var resendOtpFont = kFontBook;
  var resendOtpFontColor = gSecondaryColor;

  var buttonColor = gSecondaryColor;
  var buttonTextColor = gWhiteColor;
  double buttonTextSize = 14.dp;
  var buttonTextFont = kFontBold;
  var buttonBorderColor = kLineColor;
  double buttonBorderWidth = 1;



  var buttonBorderRadius = 30.0;

  var loginDummyTextColor =  Colors.black87;
  var loginDummyTextFont = kFontBook;
  double loginDummyTextFontSize = 9.dp;

  var anAccountTextColor =  gHintTextColor;
  var anAccountTextFont = kFontMedium;
  double anAccountTextFontSize = 10.dp;

  var loginSignupTextColor =  gSecondaryColor;
  var loginSignupTextFont = kFontBold;
  double loginSignupTextFontSize = 10.5.dp;

}