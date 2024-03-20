import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:im_animations/im_animations.dart';
import 'package:image_cropper/image_cropper.dart';
import '../constants.dart';

buildCircularIndicator() {
  return Center(
    child: HeartBeat(
        child: Image.asset(
      'assets/images/progress_logo.png',
      width: 75,
      height: 75,
    )),
  );
}

buildThreeBounceIndicator({Color? color}) {
  return Center(
    child: SpinKitThreeBounce(
      color: color ?? gMainColor,
      size: 15,
    ),
  );
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

buildLoginButtons(String title, VoidCallback func) {
  return SizedBox(
    width: 35.w,
    child: ElevatedButton(
      onPressed: func,
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
          title,
          style: TextStyle(
            fontFamily: buttonFont,
            fontSize: buttonFontSize,
            color: buttonColor,
          ),
        ),
      ),
    ),
  );
}

buildAppBar(
  VoidCallback func, {
  bool isBackEnable = true,
  bool showNotificationIcon = false,
  VoidCallback? notificationOnTap,
  bool showHelpIcon = false,
  VoidCallback? helpOnTap,
  bool showSupportIcon = false,
  VoidCallback? supportOnTap,
  Color? helpIconColor,
  String? badgeNotification,
  bool showLogo = true,
  bool showChild = false,
  bool isFilter = false,
  Widget? filterWidget,
  Widget? child,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          SizedBox(
            width: 1.5.w,
          ),
          Visibility(
            visible: isBackEnable,
            child: SizedBox(
              width: 2.h,
              child: IconButton(
                onPressed: func,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: gBlackColor,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 1.5.w,
          ),
          Visibility(
            visible: showLogo,
            child: SizedBox(
              height: 6.h,
              child: const Image(
                image: AssetImage("assets/images/Gut welness logo.png"),
              ),
              //SvgPicture.asset("assets/images/splash_screen/Inside Logo.svg"),
            ),
          ),
          Visibility(
            visible: showChild,
            child: child ?? const SizedBox(),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: showNotificationIcon,
            child: GestureDetector(
              child: badgeNotification == "1"
                  ? buildCustomBadge(
                      child: Icon(
                        Icons.notifications,
                        color: gHintTextColor,
                      ),
                      // child: Icon(Icons.notifications,color: gHintTextColor,)
                      // SvgPicture.asset(
                      //   "assets/images/Notification.svg",
                      //   height: 2.5.h,
                      //   color: gHintTextColor,
                      // ),
                    )
                  : Icon(
                      Icons.notifications,
                      color: gHintTextColor,
                    ),
              onTap: notificationOnTap,
            ),
          ),
          Visibility(
            visible: isFilter,
            child: filterWidget ?? const SizedBox(),
          ),
          SizedBox(
            width: 3.25.w,
          ),
          Visibility(
            visible: showHelpIcon,
            child: GestureDetector(
              child: ImageIcon(
                AssetImage("assets/images/new_ds/help.png"),
                color: helpIconColor ?? gHintTextColor,
              ),
              onTap: helpOnTap,
            ),
          ),
          SizedBox(
            width: 3.25.w,
          ),
          Visibility(
            visible: showSupportIcon,
            child: GestureDetector(
              child: ImageIcon(
                AssetImage("assets/images/new_ds/support.png"),
                color: gHintTextColor,
              ),
              onTap: supportOnTap,
            ),
          ),
        ],
      ),
    ],
  );
}

Future<CroppedFile?> cropSelectedImage(String filePath) async {
  return await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
            toolbarColor: gBlackColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ]);
}

buildTapCount(String title, int count) {
  return Row(
    children: [
      Text(title),
      SizedBox(width: 1.w),
      count == 0
          ? const SizedBox()
          : Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: kNumberCircleRed,
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 7.sp,
                  fontFamily: "GothamMedium",
                  color: gWhiteColor,
                ),
              ),
            )
    ],
  );
}

buildCustomBadge({required Widget child}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      child,
      const Positioned(
        top: 2,
        right: 2,
        child: CircleAvatar(
          radius: 4,
          backgroundColor: Colors.red,
        ),
      ),
    ],
  );
}
