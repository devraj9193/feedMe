import 'package:feed_me/screens/profile_screens/profile_screen.dart';
import 'package:feed_me/screens/profile_screens/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';
import '../../repository/user_profile_repo/user_profile_repo.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';
import '../login_screens/login_Screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<Map<String, dynamic>> profileData = [];
  String getProfilePic = "";
  bool photoError = false;
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

      // getProfilePic = supabase
      //     .storage
      //     .from('profile_pic')
      //     .getPublicUrl('amith.png');
      //
      // print("getProfilePic : $getProfilePic");

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
            padding: EdgeInsets.only(top: 2.h),
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
                        "Settings",
                        style: TextStyle(
                          fontFamily: kFontBold,
                          fontSize: 15.dp,
                          color: gBlackColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 3.w),
                      child: GestureDetector(
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
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          SizedBox(height: 4.h),
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
          //     child: CircleAvatar(
          //       radius: 8.h,
          //       backgroundColor: gWhiteColor,
          //       backgroundImage: CachedNetworkImageProvider(
          //           profileDetails['profile_pic'] ?? '',
          //           errorListener: (image) {
          //         print("image error");
          //         setState(() => photoError = true);
          //       }) as ImageProvider,
          //     ),
          //   ),
          // ),
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
              child: ImageNetwork(
                image: profileDetails['profile_pic'] ?? '',
                height: 140,
                width: 140,
                duration: 1000,
                curve: Curves.easeIn,
                onPointer: true,
                debugPrint: false,
                fullScreen: false,
                fitAndroidIos: BoxFit.cover,
                fitWeb: BoxFitWeb.contain,
                borderRadius: BorderRadius.circular(100),
                onError: const Icon(
                  Icons.person,
                  color: loginButtonColor,
                ),
                onTap: () {
                  debugPrint("©gabriel_patrick_souza");
                },
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Center(
            child: Row(
              children: [
                const Expanded(child: Divider(),),
                SizedBox(width: 2.w),
                Text(
                  "${profileDetails['f_name']} ${profileDetails['l_name']}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: eUser().mainHeadingFont,
                      color: eUser().mainHeadingColor,
                      fontSize: eUser().mainHeadingFontSize),
                ),SizedBox(width: 2.w),
                const Expanded(child: Divider(),),
              ],
            ),
          ),
          SizedBox(height: 0.5.h),
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
          SizedBox(height: 2.h),
          const Divider(),
          profileTile(
              "assets/images/Group 2753.png", "My Profile",
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                    const ProfileScreen(),
                  ),
                );
              }),

          profileTile("assets/images/Group 2748.png", "Upload",
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UploadScreen(),
                  ),
                );
              }),
        ],
      ),
    );
  }

  profileTile(String image, String title, func) {
    return Column(
      children: [
        InkWell(
          onTap: func,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                padding: const EdgeInsets.all(5),
                  child: Image(
                    image: AssetImage(image),
                    height: 3.5.h,
                  ),),

              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: gBlackColor,
                    fontFamily: kFontBook,
                    fontSize: 13.dp,
                  ),
                ),
              ),
              GestureDetector(
                onTap: func,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: gBlackColor,
                  size: 2.h,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
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
