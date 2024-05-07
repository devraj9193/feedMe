import 'dart:io';

import 'package:feed_me/screens/login_screens/feed_me_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../main.dart';
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

  final firstNameFormKey = GlobalKey<FormState>();
  final lastNameFormKey = GlobalKey<FormState>();
  final emailFormKey = GlobalKey<FormState>();
  final mobileFormKey = GlobalKey<FormState>();
  final pwdFormKey = GlobalKey<FormState>();
  final restaurantsNameFormKey = GlobalKey<FormState>();
  final locationFormKey = GlobalKey<FormState>();
  final idProofFormKey = GlobalKey<FormState>();

  PickResult? selectedPlace;

  SharedPreferences? _pref;

  String? deviceId, fcmToken;

  bool isLoading = false;
  late bool passwordVisibility;

  late FocusNode _nameFocus,
      _emailFocus,
      _restaurantNameFocus,
      _locationFocus,
      _idProofFocus,
      _phoneFocus;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController idProofController = TextEditingController();

  String countryCode = '+91';

  @override
  void initState() {
    super.initState();
    _nameFocus = FocusNode();
    passwordVisibility = false;
    _nameFocus.addListener(() {});
    emailController.addListener(() {
      setState(() {});
    });
    mobileController.addListener(() {
      setState(() {});
    });
    firstNameController.addListener(() {
      setState(() {});
    });
    lastNameController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
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

    _phoneFocus = FocusNode();
    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) {
        mobileFormKey.currentState!.validate();
      }
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
    _phoneFocus.removeListener(() {});
    firstNameController.removeListener(() {});
    lastNameController.removeListener(() {});
    emailController.removeListener(() {});
    mobileController.removeListener(() {});
    passwordController.removeListener(() {});
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
            buildTextFieldHeading("First Name"),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: firstNameFormKey,
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: firstNameController,
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
                  hintText: "Enter your first name",
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
            buildTextFieldHeading("Last Name"),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: lastNameFormKey,
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: lastNameController,
                cursorColor: gGreyColor,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                    return 'Please enter your Name';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: "Enter your last name",
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
            buildTextFieldHeading("Mobile No"),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: mobileFormKey,
              child: TextFormField(
                cursorColor: gPrimaryColor,
                textAlignVertical: TextAlignVertical.center,
                maxLength: 10,
                controller: mobileController,
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
                  enabledBorder: (mobileController.text.isEmpty)
                      ? null
                      : UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: eUser().focusedBorderColor,
                              width: eUser().focusedBorderWidth)),
                  isDense: true,
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                  suffixIcon: (mobileController.text.length != 10 &&
                          mobileController.text.isNotEmpty)
                      ? InkWell(
                          onTap: () {
                            mobileController.clear();
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: gBlackColor,
                          ),
                        )
                      : (mobileController.text.length == 10)
                          ? Icon(
                              Icons.check_circle_outline,
                              color: gPrimaryColor,
                              size: 2.h,
                            )
                          : const SizedBox(),
                  hintText: "Enter Mobile Number",
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
            buildTextFieldHeading("Password"),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: pwdFormKey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: gBlackColor,
                controller: passwordController,
                obscureText: !passwordVisibility,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                    fontFamily: textFieldFont,
                    fontSize: textFieldText,
                    color: textFieldColor),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the Password';
                  }
                  if (!RegExp('[a-zA-Z]')
                      // RegExp(
                      //         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,20}$')
                      .hasMatch(value)) {
                    return 'Password may contains alpha numeric';
                  }
                  if (value.length < 6 || value.length > 20) {
                    return 'Password must me 6 to 20 characters';
                  }
                  if (!RegExp('[a-zA-Z]')
                      // RegExp(
                      //         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,20}$')
                      .hasMatch(value)) {
                    return 'Password must contains \n '
                        '1-symbol 1-alphabet 1-number';
                  }
                  return null;
                },
                onFieldSubmitted: (val) {
                  formKey.currentState!.validate();
                },
                decoration: InputDecoration(
                  // prefixIcon: Icon(
                  //   Icons.lock_outline_sharp,
                  //   color: gBlackColor,
                  //   size: 15.dp,
                  // ),
                  hintText: "Enter your password",
                  hintStyle: TextStyle(
                    fontFamily: textFieldHintFont,
                    color: textFieldHintColor.withOpacity(0.5),
                    fontSize: textFieldHintText,
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        passwordVisibility = !passwordVisibility;
                      });
                    },
                    child: Icon(
                      passwordVisibility
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: passwordVisibility ? gBlackColor : gGreyColor,
                      size: 15.dp,
                    ),
                  ),
                ),
              ),
            ),
            buildTextFieldHeading("Restaurant Name"),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: restaurantsNameFormKey,
              child: TextFormField(
                controller: restaurantNameController,
                cursorColor: gGreyColor,
                decoration: InputDecoration(
                  hintText: "Enter your restaurant's name",
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
                  suffixIcon: filterPopUp(),
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
            // Form(
            //   autovalidateMode: AutovalidateMode.disabled,
            //   key: restaurantsNameFormKey,
            //   child: DropdownButtonFormField(
            //     icon: Icon(
            //       Icons.keyboard_arrow_down_sharp,
            //       color: gGreyColor.withOpacity(0.5),
            //       size: 3.h,
            //     ),
            //     style: TextStyle(
            //       fontFamily: textFieldFont,
            //       fontSize: textFieldText,
            //       color: textFieldColor,
            //     ),
            //     onChanged: (v) {
            //       restaurantNameController.text = v.toString();
            //     },
            //     decoration: InputDecoration(
            //       hintStyle: TextStyle(
            //         fontFamily: textFieldHintFont,
            //         color: textFieldHintColor.withOpacity(0.5),
            //         fontSize: textFieldHintText,
            //       ),
            //       enabledBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(
            //           color: textFieldUnderLineColor.withOpacity(0.3),
            //         ),
            //       ),
            //       focusedBorder: const UnderlineInputBorder(
            //         borderSide: BorderSide(
            //           color: textFieldUnderLineColor,
            //         ),
            //       ),
            //       hintText: "Enter your restaurant's name",
            //     ),
            //     items: [
            //       ...restaurantNameList.map((e) {
            //         return DropdownMenuItem(
            //           value: e,
            //           child: Text(
            //             e,
            //           ),
            //         );
            //       }).toList(),
            //     ],
            //   ),
            // ),
            buildTextFieldHeading("Location"),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: locationFormKey,
              child: TextFormField(
                controller: locationController,
                cursorColor: gGreyColor,
                decoration: InputDecoration(
                  hintText: "Pick the location",
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PlacePicker(
                              resizeToAvoidBottomInset:
                                  false, // only works in page mode, less flickery
                              apiKey: AppConfig.googleApiKey,
                              hintText: "Find a place ...",
                              searchingText: "Please wait ...",
                              selectText: "Select place",
                              outsideOfPickAreaText: "Place not in area",
                              initialPosition: LatLng(
                                  _pref?.getDouble(AppConfig.userLatitude) ?? 0.0,
                                  _pref?.getDouble(AppConfig.userLongitude) ?? 0.0),
                              useCurrentLocation: true,
                              selectInitialPosition: true,
                              usePinPointingSearch: true,
                              usePlaceDetailSearch: true,
                              zoomGesturesEnabled: true,
                              zoomControlsEnabled: true,
                              onMapCreated: (GoogleMapController controller) {
                                print("Map created");
                              },
                              onPlacePicked: (PickResult result) {
                                print(
                                    "Place picked: ${result.formattedAddress}");
                                setState(() {
                                  selectedPlace = result;
                                  Navigator.of(context).pop();
                                });
                              },
                              onMapTypeChanged: (MapType mapType) {
                                print(
                                    "Map type changed to ${mapType.toString()}");
                              },
                            );
                          },
                        ),
                      );
                      // pickLocation(context);
                    },
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
            buildTextFieldHeading("ID Proof Number", isRequired: true),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: idProofFormKey,
              child: TextFormField(
                controller: idProofController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  AdhaarCardNumberFormater(),
                  LengthLimitingTextInputFormatter(14),
                ],
                cursorColor: gGreyColor,
                decoration: InputDecoration(
                  hintText: "Enter your adhaar card Number",
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (firstNameFormKey.currentState!.validate() &&
                            lastNameFormKey.currentState!.validate() &&
                            emailFormKey.currentState!.validate() &&
                            restaurantsNameFormKey.currentState!.validate() &&
                            idProofFormKey.currentState!.validate()) {
                          if (firstNameController.text.isNotEmpty &&
                              lastNameController.text.isNotEmpty &&
                              restaurantNameController.text.isNotEmpty &&
                              emailController.text.isNotEmpty &&
                              idProofController.text.isNotEmpty) {
                            donorRegistration(
                              firstNameController.text.trim(),
                              lastNameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              restaurantNameController.text.trim(),
                              idProofController.text.trim(),
                              'Donor',
                              locationController.text.trim(),
                              mobileController.text.trim(),
                            );
                          }
                        }
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
                  child: isLoading
                      ? buildThreeBounceIndicator(
                          color: buttonColor,
                        )
                      : Text(
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

  bool isPhone(String input) =>
      RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input);

  filterPopUp() {
    return PopupMenuButton(
      onSelected: (e) {
        setState(() {
          restaurantNameController.text = e;
        });
      },
      offset: const Offset(0, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: gWhiteColor,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...restaurantNameList.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        restaurantNameController.text = e;
                      });
                    },
                    child: Text(
                      e,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
      child: Icon(
        Icons.expand_more,
        color: gBlackColor,
        size: 2.5.h,
      ),
    );
  }

  // void pickLocation(BuildContext context) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => Container(
  //         height: double.maxFinite,
  //         width: double.maxFinite,
  //         margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 7.h),
  //         // padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
  //         decoration: BoxDecoration(
  //           color: gWhiteColor,
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         child: Scaffold(
  //           body: OpenStreetMapSearchAndPick(
  //               center: const LatLong(23, 89),
  //               buttonText: 'Pick address',
  //               buttonWidth: 30.w,
  //               buttonHeight: 5.h,
  //               onPicked: (pickedData) {
  //                 setState(() {
  //                   locationController.text = pickedData.address.toString();
  //                   Navigator.pop(context);
  //                 });
  //                 print(pickedData.latLong.latitude);
  //                 print(pickedData.latLong.longitude);
  //                 print(pickedData.address);
  //               }),
  //         )),
  //   );
  // }

  void donorRegistration(
    String fName,
    String lName,
    String email,
    String password,
    String resName,
    String idProofNumber,
    String userType,
    String location,
    String phone,
  ) async {
    print("--- DONOR LOGIN ---");

    setState(() {
      isLoading = true;
    });

    try {
      Map m = {
        'f_name': fName,
        'l_name': lName,
        'email': email,
        'password': password,
        'res_name': resName,
        'id_proof_number': idProofNumber,
        'user_type': userType,
        'location': location,
        'phone': phone,
      };

      print("Map $m");

      final res = await supabase.from('users').insert(m);

      print("response : $res");

      AppConfig()
          .showSnackbar(context, "Registered Successfully", isError: false);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const FeedMeScreen(),
        ),
      );
      setState(() {
        isLoading = false;
      });
    } on PostgrestException catch (error) {
      setState(() {
        isLoading = false;
      });
      AppConfig().showSnackbar(context, error.message, isError: true);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      AppConfig()
          .showSnackbar(context, 'Unexpected error occurred', isError: true);
    }
    setState(() {
      isLoading = false;
    });
  }
}

// this class will be called, when their is change in textField
class AdhaarCardNumberFormater extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String enteredData = newValue.text; // get data enter by used in textField
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < enteredData.length; i++) {
      // add each character into String buffer
      buffer.write(enteredData[i]);
      int index = i + 1;
      if (index % 4 == 0 && enteredData.length != index) {
        // add space after 4th digit
        buffer.write(" ");
      }
    }

    return TextEditingValue(
        text: buffer.toString(), // final generated credit card number
        selection: TextSelection.collapsed(
            offset: buffer.toString().length) // keep the cursor at end
        );
  }
}
