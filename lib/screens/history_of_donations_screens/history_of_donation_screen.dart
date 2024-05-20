import 'package:feed_me/utils/widgets/widgets.dart';
import 'package:feed_me/utils/widgets/will_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../community_screens/feedback_screen.dart';

class HistoryOfDonation extends StatefulWidget {
  final String userType;
  const HistoryOfDonation({super.key, required this.userType});

  @override
  State<HistoryOfDonation> createState() => _HistoryOfDonationState();
}

class _HistoryOfDonationState extends State<HistoryOfDonation> {
  TabController? tabController;
  final searchController = TextEditingController();
  final SharedPreferences _pref = AppConfig().preferences!;
  String? userType;

  @override
  void initState() {
    super.initState();
    getNgoData();
  }

  var loading = true;
  List<Map<String, dynamic>> getDashboardNgoData = [];

  List<Map<String, dynamic>> getDeliveredData = [];

  getNgoData() async {
    setState(() {
      loading = true;
    });

    setState(() {
      userType = _pref.getString(AppConfig.userType) ?? '';
    });

    print("user type : $userType");

    print("user id : ${_pref.getString(AppConfig.userId)}");

    try {
      final response = await supabase.from('ashram_requests').select('*').eq(
          userType == "Donor"
              ? 'donor_id'
              : userType == "Volunteer"
                  ? 'volunteer_id'
                  : "ngo_id",
          "${_pref.getString(AppConfig.userId)}");

      print("History of Donation : $response");

      getDashboardNgoData = response;

      for (var element in getDashboardNgoData) {
        print("element :$element");

        if (element['status'] == "delivered") {
          getDeliveredData.add(element);

          print("getDeliveredData : $getDeliveredData");
        }
      }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Donations",
              //   style: TextStyle(
              //     fontFamily: kFontBold,
              //     fontSize: backButton,
              //     color: gBlackColor,
              //   ),
              // ),
              Expanded(
                child: loading
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 35.h),
                        child: buildThreeBounceIndicator(color: gBlackColor),
                      )
                    : getDeliveredData.isEmpty
                        ? const NoDataFound()
                        : buildList(getDeliveredData),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildList(List<Map<String, dynamic>> lst) {
    return ListView.builder(
      itemCount: lst.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        dynamic file = lst[index];
        return GestureDetector(
          onTap: () {
           widget.userType == "Donor" ? null : Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FeedbackScreen(
                  file: file,
                ),
              ),
            );
          },
          child: Container(
            height: 14.h,
            margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
                    width: 32.w,
                    decoration: BoxDecoration(
                      color: imageBackGround,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ImageNetwork(
                      image: '',
                      height: 14.h,
                      width: 32.w,
                      // duration: 1500,
                      curve: Curves.easeIn,
                      onPointer: true,
                      debugPrint: false,
                      fullScreen: false,
                      fitAndroidIos: BoxFit.cover,
                      fitWeb: BoxFitWeb.contain,
                      borderRadius: BorderRadius.circular(12),
                      onError: const Icon(
                        Icons.image_outlined,
                        color: loginButtonSelectedColor,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FeedbackScreen(
                              file: file,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.h, right: 3.w),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  file['food_items'],
                                  style: TextStyle(
                                    fontSize: listHeadingSize,
                                    fontFamily: listHeadingFont,
                                    color: gBlackColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Image(image: const AssetImage("assets/images/medal.png"),
                                      height: 2.h,),
                                    // Icon(
                                    //   Icons.timer_sharp,
                                    //   size: 1.5.h,
                                    //   color: gBlackColor,
                                    // ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      file['reward_points'],
                                      style: TextStyle(
                                        fontSize: listOtherSize,
                                        fontFamily: listOtherFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                  ],
                                ),
                                // Text(
                                //   "${file['food_quantity']}",
                                //   style: TextStyle(
                                //     fontSize: listSubHeadingSize,
                                //     height: 1.3,
                                //     fontFamily: listSubHeadingFont,
                                //     color: gBlackColor,
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Status : ",
                                    style: TextStyle(
                                      fontSize: 11.dp,
                                      height: 1.5,
                                      fontFamily: kFontBook,
                                      color: gBlackColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: file['status'],
                                    style: TextStyle(
                                      fontSize: 11.dp,
                                      height: 1.5,
                                      fontFamily: kFontBold,
                                      color: gBlackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Pickup Time : ",
                                    style: TextStyle(
                                      fontSize: 11.dp,
                                      fontFamily: kFontBook,
                                      color: gBlackColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: file['pickup_time'],
                                    style: TextStyle(
                                      fontSize: 11.dp,
                                      fontFamily: kFontBold,
                                      color: gBlackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 1.5.h,
                                      color: gBlackColor,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      file['cooking_date'],
                                      style: TextStyle(
                                        fontSize: listOtherSize,
                                        fontFamily: listOtherFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 1.5.h,
                                      color: gBlackColor,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      file['cooking_date'],
                                      style: TextStyle(
                                        fontSize: listOtherSize,
                                        fontFamily: listOtherFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                  ],
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
          ),
        );
      },
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
                          color: gBlackColor),
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
                          color: gBlackColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),
                    (showDeliveredProgress)
                        ? Center(child: buildCircularIndicator())
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 1.h),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
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
                                backgroundColor:
                                    loginButtonColor, //change text color of button
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

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   List dummyData = [
//     {
//       "id": "#12576",
//       "rewards": "50 points are rewarded ",
//       "message": "to you for your last delivery. Keep spreading the smile!",
//       "date": "2 Nov"
//     },
//     {
//       "id": "#12576",
//       "rewards": "",
//       "message":
//           "Congratulations! you have completed your first delivery with FeedMe,",
//       "date": "2 Nov"
//     }
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopWidget(
//       child: Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [
//               SizedBox(height: 1.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   buildAppBar(
//                     () {},
//                     isBackEnable: false,
//                     showLogo: false,
//                     showChild: true,
//                     child: Text(
//                       "Notifications",
//                       style: TextStyle(
//                         fontFamily: kFontMedium,
//                         fontSize: backButton,
//                         color: gBlackColor,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(right: 3.w),
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: Text(
//                         "Mark as read",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           decorationThickness: 3,
//                           decoration: TextDecoration.underline,
//                           fontFamily: resendFont,
//                           color: gBlackColor,
//                           fontSize: textFieldHintText,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: buildNotificationList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   buildNotificationList() {
//     return Padding(
//       padding: EdgeInsets.only(top: 2.h),
//       child: ListView.builder(
//         itemCount: dummyData.length,
//         shrinkWrap: true,
//         scrollDirection: Axis.vertical,
//         physics: const ScrollPhysics(),
//         itemBuilder: (context, index) {
//           final file = dummyData[index];
//           return Container(
//             padding: EdgeInsets.only(top: 1.h,bottom: 1.h,left: 3.w, right: 5.w),
//             margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
//             decoration: BoxDecoration(
//               color: containerBackGroundColor,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: gGreyColor.withOpacity(0.5),
//                   offset: const Offset(0, 1),
//                 ),
//               ],
//             ),
//             child: IntrinsicHeight(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     file['id'],
//                     style: TextStyle(fontSize: listHeadingSize,
//                     fontFamily: listHeadingFont,
//                       color: gBlackColor,
//                     ),
//                   ),
//                   Padding(
//                     padding:  EdgeInsets.symmetric(horizontal: 1.5.w),
//                     child: VerticalDivider(
//                       color: gGreyColor.withOpacity(0.5),
//                       thickness: 1,
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         RichText(
//                           textAlign: TextAlign.start,
//                           text: TextSpan(
//                             children: <TextSpan>[
//                               TextSpan(
//                                 text:file['rewards'],
//                                 style: TextStyle(
//                                   fontSize: 11.dp,
//                                   height: 1.5,
//                                   fontFamily: kFontBold,
//                                   color: gBlackColor,
//                                 ),
//                               ),
//                               TextSpan(
//                                   text: file['message'],
//                                   style: TextStyle(
//                                     fontSize: 11.dp,
//                                     height: 1.5,
//                                     fontFamily: kFontBook,
//                                     color: gBlackColor,
//                                   ),
//                                   ),
//                             ],
//                           ),
//                         ),
//                         Text(
//                           file['date'],
//                           style: TextStyle(fontSize: 9.dp,
//                             fontFamily: kFontBook,
//                             color: gBlackColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
