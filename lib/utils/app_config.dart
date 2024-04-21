import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class AppConfig{
  static AppConfig? instance;
  factory AppConfig() => instance ??= AppConfig._();
  AppConfig._();

  /// need to change this each time when we send the aab
  static const double androidVersion = 1.0;

  static const androidBundleId = "com.fembuddy.gwc_customer";

  static const String androidAppURL = "https://play.google.com/store/apps/details?id=com.fembuddy.gwc_customer";
  static const String iosAppURL = "https://play.google.com/store/apps/details?id=com.fembuddy.gwc_customer";

  static const String supabaseUrl = 'https://qvmongfaqxkvoskrguur.supabase.co';
  static const String supabaseApiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF2bW9uZ2ZhcXhrdm9za3JndXVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc1NTE2MDksImV4cCI6MjAyMzEyNzYwOX0.Wo_ipFqhoHcijLSKRA6AGy6LMxEA2P9oaiWFViJhFu0';

  SharedPreferences? preferences;

  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    late String deviceId;

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor!;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
    }else if (Platform.isWindows) {
      var windowsDeviceInfo = await deviceInfo.windowsInfo;
      deviceId = windowsDeviceInfo.deviceId;
    }else if (Platform.isMacOS) {
      var macOSDeviceInfo = await deviceInfo.macOsInfo;
      deviceId = macOSDeviceInfo.computerName;
    }
    else {
      deviceId = 'null';
    }
    return deviceId;
  }

  // *** firebase ***
  static const String notification_channelId = 'high_importance_channel';
  static const String notification_channelName = 'pushnotificationappchannel';

  static const String FCM_TOKEN = "fcm";

  static const String isLogin = "is_login";
  static const String last_login = "last_login";

  static const String userId = "userId";
  static const String userName = "userName";
  static const String userEmail = "userEmail";
  static const String userType = "userType";
  static const String userRestaurant = "userRestaurant";
  static const String userAddress = "userAddress";

  static const String userLongitude = "userLongitude";
  static const String userLatitude = "userLatitude";


  static const String User_Profile = "profile_pic";
  static const String User_Phone = "userPhone";
  final String deviceId = "deviceId";

static const String googleApiKey = 'AIzaSyAIGJ_QozQyxJaqGgqEZ0E69_dKOIwkkHU';

  static const String updateAppContent = "New Version Available Please Update";

  final String BEARER_TOKEN = "Bearer";

  static String slotErrorText = "Slots Not Available Please select different day";
  static String networkErrorText = "No Internet. Please Check Your Network Connection";
  static String oopsMessage = "OOps ! Something went wrong.";

  static String supabaseUserId = "supabase_user_id";
  static const String getSupabaseSession = 'get_supabase_session';
  static const String isSupabaseLogin = 'is_supabase_login';


  showSnackbar(BuildContext context, String message,{int? duration, bool? isError, SnackBarAction? action, double? bottomPadding}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:(isError == null || isError == false) ? gPrimaryColor : gSecondaryColor.withOpacity(0.55),
        content: Text(message),
        margin: (bottomPadding != null) ? EdgeInsets.only(bottom: bottomPadding) : null,
        duration: Duration(seconds: duration ?? 3),
        action: action,
      ),
    );
  }

  showSheet(BuildContext context, Widget viewWidget, {double? bottomSheetHeight, bool isDismissible = false}){
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: isDismissible,
        enableDrag: false,
        context: context,
        backgroundColor: Colors.transparent,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     top: Radius.circular(30),
        //   ),
        // ),
        builder: (BuildContext context) {
          return AnimatedPadding(
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
              height: bottomSheetHeight ?? 40.h,
              child: viewWidget,
            ),
          );
        }
    );
  }

}