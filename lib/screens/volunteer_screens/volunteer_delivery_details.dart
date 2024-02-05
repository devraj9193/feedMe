import 'package:feed_me/dashboard_screen.dart';
import 'package:feed_me/utils/widgets/will_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../../utils/constants.dart';
import '../../utils/widgets/widgets.dart';

import '../donor_screens/live_tracking.dart';
import 'navigation_pickup.dart';

class VolunteerDeliveryDetails extends StatefulWidget {
  const VolunteerDeliveryDetails({super.key});

  @override
  State<VolunteerDeliveryDetails> createState() =>
      _VolunteerDeliveryDetailsState();
}

class _VolunteerDeliveryDetailsState extends State<VolunteerDeliveryDetails> {
  TextEditingController dateInputController = TextEditingController();

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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                      const DashboardScreen(),
                    ),
                  );
                },
                showLogo: false,
                showChild: true,
                child: Text(
                  "Delivery Details",
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
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          Text(
            "Donation ID #12576",
            style: TextStyle(
              fontFamily: kFontBold,
              fontSize: backButton,
              color: gBlackColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: FixedTimeline.tileBuilder(
              theme: TimelineTheme.of(context).copyWith(
                nodePosition: 0,
              ),
              builder: TimelineTileBuilder.connected(
                connectionDirection: ConnectionDirection.after,
                contentsAlign: ContentsAlign.basic,
                connectorBuilder: (context, index, type) {
                  return DashedLineConnector(
                    color: gBlackColor,
                    thickness: 1.5,
                    space: 7.w,
                    gap: 1.5.w,
                    dash: 1.w,
                    indent: 1.w,
                    endIndent: 1.w,
                  );
                },
                indicatorBuilder: (context, index) {
                  return DotIndicator(
                    color: gWhiteColor,
                    border: Border.all(color: gBlackColor,width: 1.5),
                  );
                },
                itemExtent: 12.h,
                itemCount: dummyData.length,
                contentsBuilder: (context, index) {
                  return Container(
                    height: 10.h,
                    margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: gWhiteColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: gGreyColor,
                        width: 1.5,
                      ),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14.h,
                            width: 30.w,
                            decoration: BoxDecoration(
                              color: imageBackGround,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ImageNetwork(
                              image: '',
                              height: 14.h,
                              width: 30.w,
                              // duration: 1500,
                              curve: Curves.easeIn,
                              // onPointer: true,
                              // debugPrint: false,
                              // fullScreen: false,
                              // fitAndroidIos: BoxFit.cover,
                              // fitWeb: BoxFitWeb.contain,
                              // borderRadius: BorderRadius.circular(12),
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
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dummyData[index].name,
                                      style: TextStyle(
                                        fontSize: listHeadingSize,
                                        fontFamily: listHeadingFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                    Text(
                                      dummyData[index].address,
                                      style: TextStyle(
                                        fontSize: listOtherSize,
                                        fontFamily: listOtherFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: gWhiteColor,
                                              border:
                                              Border.all(color: gBlackColor, width: 1),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.call,
                                              color: gBlackColor,
                                              size: 1.5.h,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => dummyData[index].isFrom == 1
                                                    ? NavigationPickUp(
                                                  name: dummyData[index].name,
                                                )
                                                    : NavigationPickUp(
                                                  name: dummyData[index].name,
                                                  isDelivery: true,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: gWhiteColor,
                                              border:
                                              Border.all(color: gBlackColor, width: 1),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.navigation,
                                              color: gBlackColor,
                                              size: 1.5.h,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          buildTextFieldHeading("Food Items"),
          SizedBox(height: 1.h),
          buildAnswers("Rice,Roti,Dal,Salad", "15kgs", isSubtitle: true),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildTextFieldHeading("Cooking Date"),
                    TextFormField(
                      style: TextStyle(
                          fontFamily: textFieldFont,
                          fontSize: textFieldText,
                          color: textFieldColor),
                      decoration: InputDecoration(
                        hintText: 'Date',
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldColor,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldColor,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2050));

                            if (pickedDate != null) {
                              dateInputController.text =
                                  DateFormat('dd MMM yyyy').format(pickedDate);
                            }
                          },
                          child: Icon(
                            Icons.calendar_month_sharp,
                            size: 2.h,
                            color: gBlackColor,
                          ),
                        ),
                      ),
                      controller: dateInputController,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  children: [
                    buildTextFieldHeading("Cooking Time"),
                    SizedBox(height: 2.7.h),
                    buildAnswers("12:00 PM", ""),
                  ],
                ),
              ),
            ],
          ),
          buildImages(),
          buildTextFieldHeading("Pickup Time"),
          SizedBox(height: 1.h),
          buildAnswers("Till 06:00 PM today", ""),
          buildTextFieldHeading("Special Instructions"),
          SizedBox(height: 1.h),
          buildAnswers("Food should be consumed within 24hrs.", ""),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: ElevatedButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) =>
                //     // SitBackScreen(),
                //     const FeedMeScreen(),
                //   ),
                // );
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
                  "Accept",
                  style: TextStyle(
                    fontFamily: buttonFont,
                    fontSize: buttonFontSize,
                    color: buttonColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: ElevatedButton(
              onPressed: () {
                deliveredWidget(context);             },
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
                  "Delivered",
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


  buildAnswers(String title, String subtitle, {bool isSubtitle = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontFamily: textFieldFont,
                  fontSize: textFieldText,
                  color: textFieldColor),
            ),
            isSubtitle
                ? Text(
                    subtitle,
                    style: TextStyle(
                        fontFamily: textFieldFont,
                        fontSize: textFieldText,
                        color: textFieldColor),
                  )
                : const SizedBox(),
          ],
        ),
        const Divider(
          color: textFieldColor,
        ),
      ],
    );
  }

  buildImages() {
    return SizedBox(
      height: 8.h,
      child: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return Center(
            child: Container(
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
          );
        },
      ),
    );
  }

  bool showDeliveredProgress = false;

  /// we r showing in stateful builder so this parameter will be used
  /// when we get setstate we will assign to this parameter based on that logout progress is used
  var deliveredProgressState;

  void deliveredWidget(BuildContext context) {

    showDialog(
        barrierDismissible: false,
        barrierColor: gWhiteColor.withOpacity(0.8),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (_, setstate) {
            deliveredProgressState = setstate;
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: lightTextColor, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Delivery completed. Thank you for your help and contribution for this community",
                      style: TextStyle(
                          fontSize: listOtherSize,
                          fontFamily: kFontBook,
                          height: 1.4,
                        color: gBlackColor
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '50 Points Rewarded',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: gTextColor,
                        fontSize: bottomSheetSubHeadingXFontSize,
                        fontFamily: bottomSheetSubHeadingMediumFont,
                      ),
                    ),
                    Text(
                      "has been added to your account",
                      style: TextStyle(
                          fontSize: listOtherSize,
                          fontFamily: kFontBook,
                          height: 1.4,
                          color: gBlackColor
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),
                    (showDeliveredProgress)
                        ? Center(child: buildCircularIndicator())
                        : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //     // SitBackScreen(),
                          //     const FeedMeScreen(),
                          //   ),
                          // );
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
                            "YAY!",
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
          });
        });
  }
}