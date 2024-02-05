import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';
import '../donor_screens/google_map_screen.dart';

class NavigationPickUp extends StatefulWidget {
  final bool isDelivery;
  final String name;
  const NavigationPickUp(
      {super.key, this.isDelivery = false, required this.name});

  @override
  State<NavigationPickUp> createState() => _NavigationPickUpState();
}

class _NavigationPickUpState extends State<NavigationPickUp> {
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
                  "Navigation",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    fontSize: backButton,
                    color: gBlackColor,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: mainView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  mainView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
          Text(
            "Current Location",
            style: TextStyle(
              fontFamily: kFontBook,
              fontSize: otpSubHeading,
              color: gBlackColor,
            ),
          ),
          Text(
            "Hari Nagar Ashram",
            style: TextStyle(
              fontFamily: kFontBold,
              fontSize: backButton,
              color: gBlackColor,
            ),
          ),
          Text(
            "1298 A divine view main road",
            style: TextStyle(
              fontFamily: kFontMedium,
              fontSize: textFieldHintText,
              color: gBlackColor,
            ),
          ),
          const GoogleMapScreen(),
          Text(
            "Here to pick up the food from Dawat Restaurant",
            style: TextStyle(
              fontFamily: kFontMedium,
              fontSize: textFieldHintText,
              color: gBlackColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5.h,
                  width: 15.w,
                  margin: EdgeInsets.only(right: 3.w),
                  decoration: BoxDecoration(
                    color: imageBackGround,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ImageNetwork(
                    image: '',
                    height: 5.h,
                    width: 15.w,
                    // duration: 1500,
                    curve: Curves.easeIn,
                    // onPointer: true,
                    // debugPrint: false,
                    // fullScreen: false,
                    // fitAndroidIos: BoxFit.cover,
                    // fitWeb: BoxFitWeb.contain,
                    // borderRadius: BorderRadius.circular(8),
                    // onError: const Icon(
                    //   Icons.image_outlined,
                    //   color: loginButtonSelectedColor,
                    // ),
                    // onTap: () {
                    //   debugPrint("©gabriel_patrick_souza");
                    // },
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: listHeadingSize,
                          fontFamily: listHeadingFont,
                          color: gBlackColor,
                        ),
                      ),
                      Text(
                        "contact",
                        style: TextStyle(
                          fontSize: listOtherSize,
                          fontFamily: listOtherFont,
                          color: gBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: gWhiteColor,
                      border: Border.all(color: gBlackColor, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.call,
                      color: gBlackColor,
                      size: 2.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildPickUp(
              Icon(
                Icons.access_time,
                size: 3.h,
                color: gBlackColor,
              ),
              "Pick Up",
              "15 mins"),
          SizedBox(height: 2.h),
          buildPickUp(
              Icon(
                Icons.trending_down_sharp,
                size: 3.h,
                color: gBlackColor,
              ),
              "Distance",
              "3.1 kms"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: ElevatedButton(
              onPressed: () {},
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
                  widget.isDelivery ? "Confirm Delivery" : "Confirm Pick up",
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
    );
  }

  buildPickUp(Icon icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: 3.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: kFontBook,
                fontSize: otpSubHeading,
                color: gBlackColor,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: kFontBold,
                fontSize: backButton,
                color: gBlackColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
