import 'dart:async';
import 'package:feed_me/screens/login_screens/privacy_policy.dart';
import 'package:feed_me/screens/login_screens/terms_and_conditions.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:pinput/pinput.dart';

import '../../dashboard_screen.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final mobileFormKey = GlobalKey<FormState>();
  late FocusNode _phoneFocus;

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final focusNode = FocusNode();

  late bool otpVisibility;

  String countryCode = '+91';

  bool otpSent = false;
  bool showOpenBottomSheetProgress = false;
  bool showLoginProgress = false;

  String otpMessage = "Sending OTP";

  Timer? _timer;
  int _resendTimer = 0;
  bool isSheetOpen = false;
  late Function bottomsheetSetState;

  bool enableResendOtp = false;

  /// timer code to show resent otp text when waiting for otp
  void startTimer() {
    _resendTimer = 60;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (isSheetOpen) {
          if (_resendTimer == 0) {
            bottomsheetSetState(() {
              timer.cancel();
              enableResendOtp = true;
            });
          } else {
            bottomsheetSetState(() {
              _resendTimer--;
            });
          }
        } else {
          _resendTimer--;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    otpVisibility = false;
    _phoneFocus = FocusNode();

    phoneController.addListener(() {
      setState(() {});
    });
    otpController.addListener(() {
      setState(() {});
    });
    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) {
        mobileFormKey.currentState!.validate();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
    _phoneFocus.removeListener(() {});
    phoneController.dispose();
    otpController.dispose();
    otpController.removeListener(() {});
  }

  bottomSheetHeight() {
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      return 70.h;
    } else {
      return 50.h;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(
                () {
                  Navigator.pop(context);
                },
                showLogo: false,
                showChild: true,
                child: Text(
                  "Back",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    fontSize: backButton,
                    color: gBlackColor,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Expanded(
                child: SingleChildScrollView(
                  child: buildForms(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final countryPicker = const FlCountryCodePicker();
  CountryCode? _countryCode;

  buildForms() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mobile No",
              style: TextStyle(
                fontFamily: kFontBold,
                fontSize: loginHeading,
                color: gBlackColor,
              ),
            ),
            Text(
              "OTP will be sent on this number",
              style: TextStyle(
                fontFamily: kFontBook,
                fontSize: otpSubHeading,
                color: gGreyColor.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 10.h),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: mobileFormKey,
              child: TextFormField(
                cursorColor: gPrimaryColor,
                textAlignVertical: TextAlignVertical.center,
                maxLength: 10,
                controller: phoneController,
                style: TextStyle(
                    fontFamily: eUser().userTextFieldFont,
                    fontSize: eUser().userTextFieldFontSize,
                    color: eUser().userTextFieldColor),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Mobile Number';
                  } else if (!isPhone(value)) {
                    return 'Please enter valid Mobile Number';
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (value) {
                  print("isPhone(value): ${isPhone(value)}");
                  print("!_phoneFocus.hasFocus: ${_phoneFocus.hasFocus}");
                  if (isPhone(value) && _phoneFocus.hasFocus) {
                    // getOtp(value);
                    _phoneFocus.unfocus();
                  }
                },
                focusNode: _phoneFocus,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: eUser().focusedBorderColor,
                          width: eUser().focusedBorderWidth)
                      // borderRadius: BorderRadius.circular(25.0),
                      ),
                  enabledBorder: (phoneController.text.isEmpty)
                      ? null
                      : UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: eUser().focusedBorderColor,
                              width: eUser().focusedBorderWidth)),
                  isDense: true,
                  counterText: '',
                  prefixIcon: Padding(
                    padding:  EdgeInsets.only(top: 1.8.h),
                    child: GestureDetector(
                      onTap: () async {
                        final code = await countryPicker.showPicker(context: context);
                        setState(() {
                          _countryCode = code;
                        });
                      },
                      child: Text(
                        _countryCode?.dialCode ?? "+91",
                        style: TextStyle(
                            fontFamily: eUser().userTextFieldFont,
                            fontSize: eUser().userTextFieldFontSize,
                            color: eUser().userTextFieldColor),
                      ),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 2),
                  suffixIcon: (phoneController.text.length != 10 &&
                          phoneController.text.length > 0)
                      ? InkWell(
                          onTap: () {
                            phoneController.clear();
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: gMainColor,
                          ),
                        )
                      : (phoneController.text.length == 10)
                          ? Icon(
                              Icons.check_circle_outline,
                              color: gPrimaryColor,
                              size: 2.h,
                            )
                          : const SizedBox(),
                  hintText: "XXXX-XXX-XXX",
                  hintStyle: TextStyle(
                    fontFamily: eUser().userTextFieldHintFont,
                    color: eUser().userTextFieldHintColor,
                    fontSize: eUser().userTextFieldHintFontSize,
                  ),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.phone,
              ),
            ),
            SizedBox(height: 1.h),
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'By continuing, ypu accept the',
                    style: TextStyle(
                      fontSize: 10.dp,
                      fontFamily: kFontBook,
                      color: gBlackColor,
                    ),
                  ),
                  TextSpan(
                      text: " Terms and conditions.",
                      style: TextStyle(
                        fontSize: 11.dp,
                        fontFamily: kFontMedium,
                        color: policyColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  // SitBackScreen(),
                                  const TermsAndConditions(),
                            ),
                          );
                        }),
                  TextSpan(
                    text: " Note. The ",
                    style: TextStyle(
                      fontSize: 10.dp,
                      fontFamily: kFontBook,
                      color: gBlackColor,
                    ),
                  ),
                  TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        fontSize: 11.dp,
                        fontFamily: kFontMedium,
                        color: policyColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  // SitBackScreen(),
                                  const PrivacyPolicy(),
                            ),
                          );
                        }),
                  TextSpan(
                    text: " describes how data is handled in this service.",
                    style: TextStyle(
                      fontSize: 10.dp,
                      fontFamily: kFontBook,
                      color: gBlackColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: ElevatedButton(
                onPressed: () {
                  buildGetOTP(context);
                  // if(showOpenBottomSheetProgress){
                  //
                  // }
                  // else{
                  //   if (mobileFormKey.currentState!.validate()) {
                  //     if (isPhone(phoneController.text)) {
                  //       print("ifff");
                  //       setState(() {
                  //         showOpenBottomSheetProgress = true;
                  //       });
                  //       buildGetOTP(context);
                  //       // getOtp(phoneController.text);
                  //     }
                  //   }
                  //   else {
                  //     AppConfig().showSnackbar(
                  //         context, 'Enter your Mobile Number',
                  //         isError: true);
                  //   }
                  // }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      loginButtonSelectedColor, //change background color of button
                  backgroundColor:
                      loginButtonColor, //change text color of button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2.0,
                ),
                child: Center(
                  child: Text(
                    "Get OTP",
                    style: TextStyle(
                      fontFamily: buttonFont,
                      fontSize: buttonFontSize,
                      color: buttonColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isPhone(String input) =>
      RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input);

  // void getOtp(String phoneNumber, {bool isFromResendOtp = false}) async {
  //   setState(() {
  //     otpSent = true;
  //   });
  //   print("get otp");
  //   if(isFromResendOtp) startTimer();
  //   final result = await _loginWithOtpService.getOtpService(phoneNumber);
  //
  //   if (result.runtimeType == GetOtpResponse) {
  //     GetOtpResponse model = result as GetOtpResponse;
  //     setState(() {
  //       isSheetOpen = true;
  //       otpMessage = "OTP Sent";
  //       showOpenBottomSheetProgress = false;
  //       if (kDebugMode) otpController.text = result.otp!;
  //     });
  //     if(!isFromResendOtp) buildGetOTP(context);
  //     Future.delayed(Duration(seconds: 2)).whenComplete(() {
  //       setState(() {
  //         otpSent = false;
  //         // if (kDebugMode) _resendTimer = 0;
  //       });
  //     });
  //     // if (kDebugMode) _timer!.cancel();
  //   }
  //   else {
  //     setState(() {
  //       otpSent = false;
  //       showOpenBottomSheetProgress = false;
  //     });
  //     ErrorModel response = result as ErrorModel;
  //     if(_timer != null) _timer!.cancel();
  //     _resendTimer = 0;
  //     AppConfig().showSnackbar(context, AppConfig.numberNotFound, isError: true);
  //   }
  // }

  buildGetOTP(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 50,
      textStyle: TextStyle(
        fontFamily: eUser().anAccountTextFont,
        color: eUser().loginDummyTextColor,
        fontSize: eUser().loginSignupTextFontSize,
      ),
      decoration: BoxDecoration(
        color: gGreyColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
    );
    startTimer();
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     top: Radius.circular(30),
      //   ),
      // ),
      builder: (BuildContext context) => AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        // EdgeInsets. only(bottom: MediaQuery.of(context).viewInsets),
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          height: bottomSheetHeight(),
          child: Column(
            children: [
              SizedBox(height: 3.h),
              Flexible(child: SingleChildScrollView(
                child: StatefulBuilder(builder: (_, setstate) {
                  bottomsheetSetState = setstate;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "SECURE WITH PIN OR\nVERIFY YOUR PHONE NUMBER",
                          style: TextStyle(
                              fontSize: bottomSheetHeadingFontSize,
                              fontFamily: bottomSheetHeadingFontFamily,
                              height: 1.4,
                            color: bottomSheetHeadingColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(
                          color: kLineColor,
                          thickness: 1.2,
                        ),
                      ),
                      // Visibility(
                      //     visible: otpSent, child: SizedBox(height: 1.h)),
                      // Visibility(
                      //   visible: otpSent,
                      //   child: Text(
                      //     otpMessage,
                      //     style: TextStyle(
                      //         fontFamily: kFontMedium,
                      //         color: gPrimaryColor,
                      //         fontSize: 8.5.dp),
                      //   ),
                      // ),
                      SizedBox(height: 5.h),
                      Center(
                        child: Pinput(
                          controller: otpController,
                          length: 6,
                          focusNode: focusNode,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsUserConsentApi,
                          listenForMultipleSmsOnAndroid: true,
                          defaultPinTheme: defaultPinTheme,
                          validator: (value) {
                            return value == otpController.text
                                ? null
                                : 'Pin is incorrect';
                          },
                          // onClipboardFound: (value) {
                          //   debugPrint('onClipboardFound: $value');
                          //   pinController.setText(value);
                          // },
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            debugPrint('onCompleted: $pin');
                          },
                          onChanged: (value) {
                            debugPrint('onChanged: $value');
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: eUser().loginDummyTextColor,
                              ),
                            ],
                          ),
                          // focusedPinTheme: defaultPinTheme.copyWith(
                          //   decoration: defaultPinTheme.decoration!.copyWith(
                          //     borderRadius: BorderRadius.circular(8),
                          //     border: Border.all(color: gPrimaryColor),
                          //   ),
                          // ),
                          // submittedPinTheme: defaultPinTheme.copyWith(
                          //   decoration: defaultPinTheme.decoration!.copyWith(
                          //     color: gGreyColor,
                          //     borderRadius: BorderRadius.circular(19),
                          //     border: Border.all(color: gPrimaryColor),
                          //   ),
                          // ),
                          // errorPinTheme: defaultPinTheme.copyBorderWith(
                          //   border: Border.all(color: Colors.redAccent),
                          // ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Visibility(
                        visible: _resendTimer != 0,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                EdgeInsets.only(right: 5.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timelapse_rounded,
                                  size: 2.h,
                                  color: textFieldHintColor,
                                ),
                                SizedBox(width: 1.w),
                                Text(_resendTimer.toString(),
                                    style: TextStyle(
                                      fontFamily: resendFont,
                                      color:  resendActiveColor,
                                      fontSize: resendTextSize,
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Center(
                        child: Text(
                          "Didn't receive an OTP?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decorationThickness: 3,
                            // decoration: TextDecoration.underline,
                            fontFamily: resendFont,
                            color: (_resendTimer != 0 || !enableResendOtp)
                                ? resendDisableColor.withOpacity(0.5)
                                : resendActiveColor,
                            fontSize: resendTextSize,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Center(
                        child: GestureDetector(
                          onTap: (_resendTimer != 0 || !enableResendOtp)
                              ? null
                              : () {
                                  // getOtp(phoneController.text, isFromResendOtp: true);
                                  // Navigator.push(context, MaterialPageRoute(builder: (_) => ResendOtpScreen()));
                                },
                          child: Text(
                            "Resend OTP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decorationThickness: 3,
                              decoration: TextDecoration.underline,
                              fontFamily: resendFont,
                              color: (_resendTimer != 0 || !enableResendOtp)
                                  ? resendDisableColor.withOpacity(0.5)
                                  : resendActiveColor,
                              fontSize: resendTextSize,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Center(
                        child: IntrinsicWidth(
                          child: SizedBox(
                            width: 35.w,
                            child: ElevatedButton(
                              onPressed: (showLoginProgress)
                                  ? null
                                  : () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const DashboardScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor:
                                loginButtonSelectedColor, //change background color of button
                                backgroundColor: loginButtonColor, //change text color of button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2.0,
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontFamily: buttonFont,
                                    fontSize: buttonFontSize,
                                    color: buttonColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
