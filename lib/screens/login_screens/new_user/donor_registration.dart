import 'package:feed_me/screens/login_screens/feed_me_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/app_config.dart';
import '../../../utils/constants.dart';
import '../../../utils/widgets/widgets.dart';
import '../../../utils/widgets/will_pop_widget.dart';

class DonorRegistration extends StatefulWidget {
  const DonorRegistration({super.key});

  @override
  State<DonorRegistration> createState() => _DonorRegistrationState();
}

class _DonorRegistrationState extends State<DonorRegistration> {
  final formKey = GlobalKey<FormState>();

  final nameFormKey = GlobalKey<FormState>();
  final emailFormKey = GlobalKey<FormState>();
  final restaurantsNameFormKey = GlobalKey<FormState>();
  final locationFormKey = GlobalKey<FormState>();
  final idProofFormKey = GlobalKey<FormState>();

  SharedPreferences? _pref;

  String? deviceId, fcmToken;

  bool isLoading = false;

  late FocusNode _nameFocus,
      _emailFocus,
      _restaurantNameFocus,
      _locationFocus,
      _idProofFocus;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController idProofController = TextEditingController();

  String countryCode = '+91';

  @override
  void initState() {
    super.initState();
    _nameFocus = FocusNode();
    _nameFocus.addListener(() {});
    emailController.addListener(() {
      setState(() {});
    });
    nameController.addListener(() {
      setState(() {});
    });
    restaurantNameController.addListener(() {
      setState(() {});
    });
    locationController.addListener(() {
      setState(() {});
    });
    idProofController.addListener(() {
      setState(() {});
    });
    getDeviceId();
  }

  getDeviceId() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      deviceId = _pref!.getString(AppConfig().deviceId);
      fcmToken = _pref!.getString(AppConfig.FCM_TOKEN);
    });
    print("fcm token: $fcmToken");
    print("devId: $deviceId");
  }

  @override
  void dispose() {
    _nameFocus.removeListener(() {});
    nameController.removeListener(() {});
    emailController.removeListener(() {});
    restaurantNameController.removeListener(() {});
    locationController.removeListener(() {});
    idProofController.removeListener(() {});
    super.dispose();
  }

  List restaurantNameList = [
    "Nagarjuna Restaurant",
    "The Only Place",
    "Meghana Foods",
  ];

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
              Padding(
                padding: EdgeInsets.only(left: 6.w, top: 2.h),
                child: Text(
                  "Donor",
                  style: TextStyle(
                    fontFamily: kFontBold,
                    fontSize: loginHeading,
                    color: gBlackColor,
                  ),
                ),
              ),
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

  buildForms() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextFieldHeading("Name"),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: nameFormKey,
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: nameController,
                cursorColor: gGreyColor,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                    return 'Please enter your Name';
                  } else {
                    return null;
                  }
                },
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  hintText: "Enter your full name",
                  hoverColor: gSecondaryColor,
                  hintStyle: TextStyle(
                    fontFamily: textFieldHintFont,
                    color: textFieldHintColor.withOpacity(0.5),
                    fontSize: textFieldHintText,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldUnderLineColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldUnderLineColor,
                    ),
                  ),
                ),
                style: TextStyle(
                    fontFamily: textFieldFont,
                    fontSize: textFieldText,
                    color: textFieldColor),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(
                      "[a-zA-Z ]",
                    ),
                  ),
                ],
              ),
            ),
            buildTextFieldHeading("Email"),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: emailFormKey,
              child: TextFormField(
                controller: emailController,
                cursorColor: gGreyColor,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Email Address';
                  } else if (!validEmail(value)) {
                    return 'Please enter valid Email Address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Enter your Email address",
                  hintStyle: TextStyle(
                    fontFamily: textFieldHintFont,
                    color: textFieldHintColor.withOpacity(0.5),
                    fontSize: textFieldHintText,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldUnderLineColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldUnderLineColor,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: textFieldFont,
                  fontSize: textFieldText,
                  color: textFieldColor,
                ),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            buildTextFieldHeading("Restaurant Name"),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: restaurantsNameFormKey,
              child: DropdownButtonFormField(
                icon: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: gGreyColor.withOpacity(0.5),
                  size: 3.h,
                ),
                style: TextStyle(
                  fontFamily: textFieldFont,
                  fontSize: textFieldText,
                  color: textFieldColor,
                ),
                onChanged: (v) {},
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontFamily: textFieldHintFont,
                    color: textFieldHintColor.withOpacity(0.5),
                    fontSize: textFieldHintText,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldUnderLineColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldUnderLineColor,
                    ),
                  ),
                  hintText: "Enter your restaurant's name",
                ),
                items: [
                  ...restaurantNameList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            buildTextFieldHeading("Location"),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: locationFormKey,
              child: TextFormField(
                controller: locationController,
                cursorColor: gGreyColor,
                decoration: InputDecoration(
                  hintText: "Pick the restaurant's location",
                  hintStyle: TextStyle(
                    fontFamily: textFieldHintFont,
                    color: textFieldHintColor.withOpacity(0.5),
                    fontSize: textFieldHintText,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldUnderLineColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldUnderLineColor,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.my_location_outlined,
                      color: textFieldHintColor.withOpacity(0.5),
                      size: 2.5.h,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: textFieldFont,
                  fontSize: textFieldText,
                  color: textFieldColor,
                ),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            buildTextFieldHeading("ID Proof", isRequired: true),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: idProofFormKey,
              child: TextFormField(
                controller: idProofController,
                cursorColor: gGreyColor,
                decoration: InputDecoration(
                    hintText: "Attach your adhaar card",
                    hintStyle: TextStyle(
                      fontFamily: textFieldHintFont,
                      color: textFieldHintColor.withOpacity(0.5),
                      fontSize: textFieldHintText,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: textFieldUnderLineColor.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: textFieldUnderLineColor,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.attach_file_sharp,
                        color: textFieldHintColor.withOpacity(0.5),
                        size: 2.5.h,
                      ),
                    ),
                ),
                style: TextStyle(
                  fontFamily: textFieldFont,
                  fontSize: textFieldText,
                  color: textFieldColor,
                ),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          // SitBackScreen(),
                          const FeedMeScreen(),
                    ),
                  );
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
                    "Register",
                    style: TextStyle(
                      fontFamily: buttonFont,
                      fontSize: buttonFontSize,
                      color: buttonColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
