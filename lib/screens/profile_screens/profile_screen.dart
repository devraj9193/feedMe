import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feed_me/utils/widgets/will_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import '../../repository/user_profile_repo/user_profile_repo.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../../utils/widgets/widgets.dart';
import '../login_screens/login_Screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> profileData = [];
  bool photoError = false;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  String genderSelected = "";
  String getProfilePic = "";

  final _prefs = AppConfig().preferences;

  var loading = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  getProfileData() async {
    setState(() {
      loading = true;
    });

    // getProfileDetails =
    //     UserProfileService(repository: repository).getUserProfileService();

    try {
      final response = await supabase
          .from('users')
          .select('*')
          .eq('email', "${_prefs?.getString(AppConfig.userEmail)}");

      getProfilePic = supabase
          .storage
          .from('profile_pic')
          .getPublicUrl('amith.png');

      print("getProfilePic : $getProfilePic");

      profileData = response;

      print("user Details : $profileData");
    } on PostgrestException catch (error) {
      AppConfig().showSnackbar(context, error.message, isError: true);
    } catch (error) {
      AppConfig()
          .showSnackbar(context, 'Unexpected error occurred', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildAppBar(
                      () {},
                      isBackEnable: false,
                      showLogo: false,
                      showChild: true,
                      child: Text(
                        "My Profile",
                        style: TextStyle(
                          fontFamily: kFontBold,
                          fontSize: 15.dp,
                          color: gBlackColor,
                        ),
                      ),
                    ),
                    (!isEdit)
                        ? Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  toggleEdit();
                                  if (isEdit) {
                                    setState(() {
                                      Map<String, dynamic> data =
                                          profileData[0];
                                      print(
                                          "${data['f_name']}, ${data['age']}");
                                      fnameController.text =
                                          data['f_name'] ?? '';
                                      lnameController.text =
                                          data['l_name'] ?? '';
                                      ageController.text = data['age'] ?? '';
                                      genderSelected =
                                          data['gender'].toTitleCase() ?? '';
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: gBlackColor,
                                  size: 2.h,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              GestureDetector(
                                onTap: () => AppConfig().showSheet(
                                  context,
                                  logoutWidget(),
                                  bottomSheetHeight: 45.h,
                                  isDismissible: true,
                                ),
                                child: Icon(
                                  Icons.logout_sharp,
                                  color: gBlackColor,
                                  size: 2.h,
                                ),
                              ),
                              SizedBox(width: 3.w),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.only(right: 3.w),
                            child: GestureDetector(
                              onTap: () {
                                toggleEdit();
                                _image = null;
                              },
                              child: Icon(
                                Icons.clear,
                                color: gBlackColor,
                                size: 2.5.h,
                              ),
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 4.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: loading
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 35.h),
                            child:
                                buildThreeBounceIndicator(color: gBlackColor),
                          )
                        : profileData.isEmpty
                            ? const NoDataFound()
                            : buildProfileDetails(profileData[0]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildProfileDetails(Map<String, dynamic> profileDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: gWhiteColor,
              shape: BoxShape.circle,
              border: Border.all(
                width: 2.5,
                color: loginButtonColor,
              ),
            ),
            child: CircleAvatar(
              radius: 8.h,
              backgroundColor: gWhiteColor,
              backgroundImage: (_image != null)
                  ? FileImage(_image!)
                  : CachedNetworkImageProvider(
                  getProfilePic,
                      errorListener: (image) {
                      print("image error");
                      setState(() => photoError = true);
                    }) as ImageProvider,
              child: Stack(clipBehavior: Clip.none, children: [
                Visibility(
                  visible: isEdit,
                  child: GestureDetector(
                    onTap: showChooserSheet,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 2.h,
                        backgroundColor: appPrimaryColor.withOpacity(0.9),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.camera_enhance_outlined,
                            color: gWhiteColor,
                            size: 2.5.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
        // Center(
        //   child: Container(
        //     padding: const EdgeInsets.all(3),
        //     decoration: BoxDecoration(
        //       color: gWhiteColor,
        //       shape: BoxShape.circle,
        //       border: Border.all(
        //         width: 2.5,
        //         color: loginButtonColor,
        //       ),
        //     ),
        //     child: ImageNetwork(
        //       image: '',
        //       height: 140,
        //       width: 140,
        //       duration: 1000,
        //       curve: Curves.easeIn,
        //       onPointer: true,
        //       debugPrint: false,
        //       fullScreen: false,
        //       fitAndroidIos: BoxFit.cover,
        //       fitWeb: BoxFitWeb.contain,
        //       borderRadius: BorderRadius.circular(100),
        //       onError: const Icon(
        //         Icons.person,
        //         color: loginButtonColor,
        //       ),
        //       onTap: () {
        //         debugPrint("©gabriel_patrick_souza");
        //       },
        //     ),
        //   ),
        // ),
        SizedBox(height: 2.h),
        Center(
          child: Text(
            "${profileDetails['f_name']} ${profileDetails['l_name']}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: eUser().mainHeadingFont,
                color: eUser().mainHeadingColor,
                fontSize: eUser().mainHeadingFontSize),
          ),
        ),
        SizedBox(height: 1.h),
        Center(
          child: Text(
            profileDetails['email'] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: eUser().userTextFieldHintFont,
                color: gHintTextColor,
                fontSize: eUser().userTextFieldFontSize),
          ),
        ),
        SizedBox(height: 1.h),
        Center(
          child: Text(
            profileDetails['phone'] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: eUser().userTextFieldHintFont,
                color: gHintTextColor,
                fontSize: eUser().userTextFieldFontSize),
          ),
        ),
        SizedBox(height: 4.h),
        profileTile("First Name: ", profileDetails['f_name'] ?? ''),
        profileTile("Last Name: ", profileDetails['l_name'] ?? ''),
        profileTile("Age: ", profileDetails['age'] ?? ''),
        genderTile('Gender', profileDetails['gender'] ?? ''),
        SizedBox(height: 4.h),
        Visibility(
          visible: isEdit,
          child: Center(
            child: IntrinsicWidth(
              child: ElevatedButton(
                onPressed: () {
                  updateProfileData();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      loginButtonSelectedColor, //change background color of button
                  backgroundColor: loginButtonColor, //change text color of button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2.0,
                ),
                child: Center(
                  child: Text(
                    "Submit",
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
  }

  profileTile(String title, String subTitle,
      {TextEditingController? controller, int? maxLength}) {
    print(controller);
    print(controller.runtimeType);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: gHintTextColor,
              fontFamily: kFontBook,
              fontSize: 10.dp,
            ),
          ),
          SizedBox(height: 1.h),
          // (isEdit && controller != null)
          //     ? TextField(
          //   controller: controller,
          //   readOnly: !isEdit,
          //   decoration: InputDecoration(
          //       contentPadding: EdgeInsets.all(0.0),
          //       isDense: true,
          //       counterText: ""
          //     // border: InputBorde,
          //   ),
          //   minLines: 1,
          //   maxLines: 1,
          //   maxLength: maxLength,
          //   // onSaved: (String value) {
          //   //   // This optional block of code can be used to run
          //   //   // code when the user saves the form.
          //   // },
          //   // validator: (value) {
          //   //   if(value!.isEmpty){
          //   //     return 'Name filed can\'t be empty';
          //   //   }
          //   // },
          // )
          //     :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subTitle,
                style: TextStyle(
                  color: gBlackColor,
                  fontFamily: kFontBold,
                  fontSize: 11.dp,
                ),
              ),
              Container(
                height: 1,
                margin: EdgeInsets.only(top: 1.h, right: 5.w),
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  genderTile(String title, String selectedGender) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: gHintTextColor,
              fontFamily: kFontBook,
              fontSize: 10.dp,
            ),
          ),
          SizedBox(height: 1.h),

          /// commented the edit for gender
          /// if we need edit than uncomment this
          // (isEdit)
          //     ? Row(
          //   children: [
          //     GestureDetector(
          //         onTap: (){
          //           setState(() => genderSelected = "Male");
          //         },
          //         child: Row(
          //           children: [
          //             Radio(
          //               value: "Male",
          //               activeColor: kPrimaryColor,
          //               groupValue: genderSelected,
          //               onChanged: (value) {
          //                 setState(() {
          //                   genderSelected = value as String;
          //                 });
          //               },
          //             ),
          //             Text('Male',
          //               style: buildTextStyle(color: genderSelected == "Male" ? kTextColor : gHintTextColor,
          //                   fontFamily: genderSelected == "Male" ? kFontMedium : kFontBook
          //               ),
          //             ),
          //           ],
          //         )),
          //     SizedBox(
          //       width: 3.w,
          //     ),
          //     GestureDetector(
          //       onTap: (){
          //         setState(() => genderSelected = "Female");
          //       },
          //       child: Row(
          //         children: [
          //           Radio(
          //             value: "Female",
          //             activeColor: kPrimaryColor,
          //             groupValue: genderSelected,
          //             onChanged: (value) {
          //               setState(() {
          //                 genderSelected = value as String;
          //               });
          //             },
          //           ),
          //           Text(
          //             'Female',
          //             style: buildTextStyle(color: genderSelected == "Female" ? kTextColor : gHintTextColor,
          //                 fontFamily: genderSelected == "Female" ? kFontMedium : kFontBook
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     SizedBox(
          //       width: 3.w,
          //     ),
          //     GestureDetector(
          //       onTap: (){
          //         setState(() => genderSelected = "Other");
          //       },
          //       child: Row(
          //         children: [
          //           Radio(
          //               value: "Other",
          //               groupValue: genderSelected,
          //               activeColor: kPrimaryColor,
          //               onChanged: (value) {
          //                 setState(() {
          //                   genderSelected = value as String;
          //                 });
          //               }),
          //           Text(
          //             "Other",
          //             style: buildTextStyle(color: genderSelected == "Other" ? kTextColor : gHintTextColor,
          //                 fontFamily: genderSelected == "Other" ? kFontMedium : kFontBook
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // )
          //     :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedGender,
                style: TextStyle(
                  color: gBlackColor,
                  fontFamily: kFontBold,
                  fontSize: 11.dp,
                ),
              ),
              Container(
                height: 1,
                margin: EdgeInsets.only(top: 1.h, right: 5.w),
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool isEdit = false;

  toggleEdit() {
    setState(() {
      if (isEdit) {
        isEdit = false;
      } else {
        isEdit = true;
      }
    });
  }

  File? _image;

  showChooserSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 5.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: gHintTextColor,
                          width: 2.0,
                        ),
                      )),
                      child: Text(
                        'Choose Profile Pic',
                        style: TextStyle(
                          color: gTextColor,
                          fontFamily: kFontMedium,
                          fontSize: 12.dp,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                getImageFromCamera();
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.camera_enhance_outlined,
                                    color: appPrimaryColor,
                                    size: 2.5.h,
                                  ),
                                  SizedBox(width: 1.5.w),
                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                      color: gTextColor,
                                      fontFamily: kFontMedium,
                                      fontSize: 10.dp,
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            width: 5,
                            height: 20,
                            decoration: const BoxDecoration(
                                border: Border(
                              right: BorderSide(
                                color: gHintTextColor,
                                width: 1,
                              ),
                            )),
                          ),
                          TextButton(
                              onPressed: () {
                                pickFromFile();
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.photo_library,
                                    color: appPrimaryColor,
                                    size: 2.5.h,
                                  ), SizedBox(width: 1.5.w),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                      color: gTextColor,
                                      fontFamily: kFontMedium,
                                      fontSize: 10.dp,
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  Future getImageFromCamera() async {
    await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then(
          (pickedFile) => cropSelectedImage("${pickedFile?.path}").then(
            (croppedFile) => setState(() {
              _image = File("${croppedFile?.path}");
            }),
          ),
        );
    print("captured image: $_image");
  }

  void pickFromFile() async {
    await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then(
          (pickedFile) => cropSelectedImage("${pickedFile?.path}").then(
            (croppedFile) => setState(() {
              _image = File("${croppedFile?.path}");
            }),
          ),
        );
    // setState(() {
    //   _image = File(image);
    // });
    // var image = await ImagePicker.platform
    //     .pickImage(source: ImageSource.gallery, imageQuality: 50);
    // setState(() {
    //   _image = File(image!.path);
    // });
    // print(_image);
  }

  updateProfileData() async {

    final avatarFile = _image;

    final String path = await supabase.storage.from('profile_pic').upload(
      "${_pref.getString(AppConfig.userName)}.png",
      avatarFile!,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );

    print("Profile update : $path");

    // final res = await UserProfileService(repository: repository)
    //     .updateUserProfileService(user);
    //
    // if (res.runtimeType == UpdateUserModel) {
    //   UpdateUserModel model = res as UpdateUserModel;
    //   AppConfig().showSnackbar(context, model.message ?? '');
    //   setState(() {
    //     isEdit = false;
    //   });
    //   getProfileData();
    // } else {
    //   ErrorModel model = res as ErrorModel;
    //   AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    // }
  }

  bool showLogoutProgress = false;

  /// we r showing in stateful builder so this parameter will be used
  /// when we get setstate we will assign to this parameter based on that logout progress is used
  var logoutProgressState;

  logoutWidget() {
    return StatefulBuilder(builder: (_, setstate) {
      logoutProgressState = setstate;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "We will miss you.",
              style: TextStyle(
                  fontSize: bottomSheetHeadingFontSize,
                  fontFamily: bottomSheetHeadingFontFamily,
                  height: 1.4),
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
          Center(
            child: Text(
              'Do you really want to logout?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: gTextColor,
                fontSize: bottomSheetSubHeadingXFontSize,
                fontFamily: bottomSheetSubHeadingMediumFont,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          (showLogoutProgress)
              ? Center(
                  child: buildThreeBounceIndicator(color: gBlackColor),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IntrinsicWidth(
                      child: GestureDetector(
                        onTap: signOut,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.h, horizontal: 5.w),
                          decoration: BoxDecoration(
                              color: gSecondaryColor,
                              border: Border.all(color: kLineColor, width: 0.5),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "YES",
                            style: TextStyle(
                              fontFamily: kFontMedium,
                              color: gWhiteColor,
                              fontSize: 11.dp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    IntrinsicWidth(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.h, horizontal: 5.w),
                          decoration: BoxDecoration(
                              color: gWhiteColor,
                              border: Border.all(color: kLineColor, width: 0.5),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "NO",
                            style: TextStyle(
                              fontFamily: kFontMedium,
                              color: gSecondaryColor,
                              fontSize: 11.dp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 1.h)
        ],
      );
    });
  }

  final SharedPreferences _pref = AppConfig().preferences!;

  signOut() async {
    try {
      logoutProgressState(() {
        showLogoutProgress = true;
      });
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      AppConfig().showSnackbar(context, error.message, isError: true);
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      AppConfig()
          .showSnackbar(context, 'Unexpected error occurred', isError: true);
    } finally {
      if (mounted) {
        _pref.setBool(AppConfig.isLogin, false);
        clearAllUserDetails();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
        logoutProgressState(() {
          showLogoutProgress = false;
        });
      }
    }
  }

  // clearing some details in local storage
  clearAllUserDetails() {
    _pref.setBool(AppConfig.isLogin, false);
    _pref.remove(AppConfig().BEARER_TOKEN);

    _pref.remove(AppConfig.userName);
    _pref.remove(AppConfig.userEmail);
    _pref.remove(AppConfig.userRestaurant);
    _pref.remove(AppConfig.userType);
  }

  final UserProfileRepository repository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
