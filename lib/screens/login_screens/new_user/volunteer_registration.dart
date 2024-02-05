import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/app_config.dart';
import '../../../utils/constants.dart';
import '../../../utils/widgets/widgets.dart';
import '../../../utils/widgets/will_pop_widget.dart';
import '../feed_me_screen.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class VolunteerRegistration extends StatefulWidget {
  VolunteerRegistration({super.key});

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;

  @override
  State<VolunteerRegistration> createState() => _VolunteerRegistrationState();
}

class _VolunteerRegistrationState extends State<VolunteerRegistration>  {
  final formKey = GlobalKey<FormState>();

  final nameFormKey = GlobalKey<FormState>();
  final emailFormKey = GlobalKey<FormState>();
  final ageFormKey = GlobalKey<FormState>();
  final genderFormKey = GlobalKey<FormState>();
  final locationFormKey = GlobalKey<FormState>();
  final idProofFormKey = GlobalKey<FormState>();

  SharedPreferences? _pref;

  String? deviceId, fcmToken;

  bool isLoading = false;

  late FocusNode _nameFocus,
      _emailFocus,
      _ageFocus,
      _genderFocus,
      _locationFocus,
      _idProofFocus;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController idProofController = TextEditingController();

  String countryCode = '+91';

  @override
  void initState() {
    super.initState();
    getAge();
    _nameFocus = FocusNode();
    _nameFocus.addListener(() {});
    nameController.addListener(() {
      setState(() {});
    });
    emailController.addListener(() {
      setState(() {});
    });
    ageController.addListener(() {
      setState(() {});
    });
    genderController.addListener(() {
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
    ageController.removeListener(() {});
    genderController.removeListener(() {});
    locationController.removeListener(() {});
    idProofController.removeListener(() {});
    super.dispose();
  }

  List ageList = [];

  getAge(){
    for(int i = 18; i <= 100; i++){
      ageList.add(i);
    }
    print("Age");
    print(ageList);
  }

  List genderList = [
    "Male",
    "Female",
    "Others",
  ];

  PickResult? selectedPlace;

  bool _mapsInitialized = false;
  final String _mapsRenderer = "latest";

  void initRenderer() {
    if (_mapsInitialized) return;
    if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
      switch (_mapsRenderer) {
        case "legacy":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.legacy);
          break;
        case "latest":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.latest);
          break;
      }
    }
    setState(() {
      _mapsInitialized = true;
    });
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
              Padding(
                padding: EdgeInsets.only(left: 6.w, top: 2.h),
                child: Text(
                  "Volunteer",
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
            buildTextFieldHeading("Age"),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: ageFormKey,
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
                  hintText: "Select your age(only 18+)",
                ),
                items: [
                  ...ageList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toString(),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            buildTextFieldHeading("Gender"),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: genderFormKey,
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
                  hintText: "Select your gender",
                ),
                items: [
                  ...genderList.map((e) {
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
                    onTap: () {
                      initRenderer();
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
                              initialPosition: VolunteerRegistration.kInitialPosition,
                              useCurrentLocation: true,
                              selectInitialPosition: true,
                              usePinPointingSearch: true,
                              usePlaceDetailSearch: true,
                              zoomGesturesEnabled: true,
                              zoomControlsEnabled: true,
                              // ignoreLocationPermissionErrors: true,
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
                              // #region additional stuff
                              // forceSearchOnZoomChanged: true,
                              // automaticallyImplyAppBarLeading: false,
                              // autocompleteLanguage: "ko",
                              // region: 'au',
                              // pickArea: CircleArea(
                              //   center: HomePage.kInitialPosition,
                              //   radius: 300,
                              //   fillColor: Colors.lightGreen
                              //       .withGreen(255)
                              //       .withAlpha(32),
                              //   strokeColor: Colors.lightGreen
                              //       .withGreen(255)
                              //       .withAlpha(192),
                              //   strokeWidth: 2,
                              // ),
                              // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                              //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                              //   return isSearchBarFocused
                              //       ? Container()
                              //       : FloatingCard(
                              //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                              //           leftPosition: 0.0,
                              //           rightPosition: 0.0,
                              //           width: 500,
                              //           borderRadius: BorderRadius.circular(12.0),
                              //           child: state == SearchingState.Searching
                              //               ? Center(child: CircularProgressIndicator())
                              //               : ElevatedButton(
                              //                   child: Text("Pick Here"),
                              //                   onPressed: () {
                              //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                              //                     //            this will override default 'Select here' Button.
                              //                     print("do something with [selectedPlace] data");
                              //                     Navigator.of(context).pop();
                              //                   },
                              //                 ),
                              //         );
                              // },
                              // pinBuilder: (context, state) {
                              //   if (state == PinState.Idle) {
                              //     return Icon(Icons.favorite_border);
                              //   } else {
                              //     return Icon(Icons.favorite);
                              //   }
                              // },
                              // introModalWidgetBuilder: (context,  close) {
                              //   return Positioned(
                              //     top: MediaQuery.of(context).size.height * 0.35,
                              //     right: MediaQuery.of(context).size.width * 0.15,
                              //     left: MediaQuery.of(context).size.width * 0.15,
                              //     child: Container(
                              //       width: MediaQuery.of(context).size.width * 0.7,
                              //       child: Material(
                              //         type: MaterialType.canvas,
                              //         color: Theme.of(context).cardColor,
                              //         shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(12.0),
                              //         ),
                              //         elevation: 4.0,
                              //         child: ClipRRect(
                              //           borderRadius: BorderRadius.circular(12.0),
                              //           child: Container(
                              //             padding: EdgeInsets.all(8.0),
                              //             child: Column(
                              //               children: [
                              //                 SizedBox.fromSize(size: new Size(0, 10)),
                              //                 Text("Please select your preferred address.",
                              //                   style: TextStyle(
                              //                     fontWeight: FontWeight.bold,
                              //                   )
                              //                 ),
                              //                 SizedBox.fromSize(size: new Size(0, 10)),
                              //                 SizedBox.fromSize(
                              //                   size: Size(MediaQuery.of(context).size.width * 0.6, 56), // button width and height
                              //                   child: ClipRRect(
                              //                     borderRadius: BorderRadius.circular(10.0),
                              //                     child: Material(
                              //                       child: InkWell(
                              //                         overlayColor: MaterialStateColor.resolveWith(
                              //                           (states) => Colors.blueAccent
                              //                         ),
                              //                         onTap: close,
                              //                         child: Row(
                              //                           mainAxisAlignment: MainAxisAlignment.center,
                              //                           children: [
                              //                             Icon(Icons.check_sharp, color: Colors.blueAccent),
                              //                             SizedBox.fromSize(size: new Size(10, 0)),
                              //                             Text("OK",
                              //                               style: TextStyle(
                              //                                 color: Colors.blueAccent
                              //                               )
                              //                             )
                              //                           ],
                              //                         )
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 )
                              //               ]
                              //             )
                              //           ),
                              //         ),
                              //       ),
                              //     )
                              //   );
                              // },
                              // #endregion
                            );
                          },
                        ),
                      );
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

  buildTextFieldHeading(String title, {bool isRequired = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: kFontMedium,
              fontSize: registerTextFieldHeading,
              color: gGreyColor,
            ),
          ),
          isRequired
              ? Text(
            " *",
            style: TextStyle(
              fontFamily: kFontMedium,
              fontSize: registerTextFieldHeading,
              color: gSecondaryColor,
            ),
          )
              : const SizedBox(),
        ],
      ),
    );
  }
}