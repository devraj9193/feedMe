import 'package:feed_me/utils/widgets/widgets.dart';
import 'package:feed_me/utils/widgets/will_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../utils/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List dummyData = [
    {
      "id": "#12576",
      "rewards": "50 points are rewarded ",
      "message": "to you for your last delivery. Keep spreading the smile!",
      "date": "2 Nov"
    },
    {
      "id": "#12576",
      "rewards": "",
      "message":
          "Congratulations! you have completed your first delivery with FeedMe,",
      "date": "2 Nov"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildAppBar(
                    () {},
                    isBackEnable: false,
                    showLogo: false,
                    showChild: true,
                    child: Text(
                      "Notifications",
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        fontSize: backButton,
                        color: gBlackColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 3.w),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Mark as read",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decorationThickness: 3,
                          decoration: TextDecoration.underline,
                          fontFamily: resendFont,
                          color: gBlackColor,
                          fontSize: textFieldHintText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: buildNotificationList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildNotificationList() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: ListView.builder(
        itemCount: dummyData.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          final file = dummyData[index];
          return Container(
            padding: EdgeInsets.only(top: 1.h,bottom: 1.h,left: 3.w, right: 5.w),
            margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
            decoration: BoxDecoration(
              color: containerBackGroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gGreyColor.withOpacity(0.5),
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    file['id'],
                    style: TextStyle(fontSize: listHeadingSize,
                    fontFamily: listHeadingFont,
                      color: gBlackColor,
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 1.5.w),
                    child: VerticalDivider(
                      color: gGreyColor.withOpacity(0.5),
                      thickness: 1,
                    ),
                  ),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text:file['rewards'],
                                style: TextStyle(
                                  fontSize: 11.dp,
                                  height: 1.5,
                                  fontFamily: kFontBold,
                                  color: gBlackColor,
                                ),
                              ),
                              TextSpan(
                                  text: file['message'],
                                  style: TextStyle(
                                    fontSize: 11.dp,
                                    height: 1.5,
                                    fontFamily: kFontBook,
                                    color: gBlackColor,
                                  ),
                                  ),
                            ],
                          ),
                        ),
                        Text(
                          file['date'],
                          style: TextStyle(fontSize: 9.dp,
                            fontFamily: kFontBook,
                            color: gBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
