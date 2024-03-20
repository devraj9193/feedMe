import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:timelines/timelines.dart';

import '../../utils/constants.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';
import 'google_map_screen.dart';

class LiveTracking extends StatefulWidget {
  const LiveTracking({Key? key, }) : super(key: key);

  @override
  State<LiveTracking> createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
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
                  "Live Tracking",
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
            "Donation ID #12576",
            style: TextStyle(
              fontFamily: kFontBold,
              fontSize: backButton,
              color: gBlackColor,
            ),
          ),
          const GoogleMapScreen(),
          buildAssignPartner(
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr sadipscing elitr",
            "Thanks for donating",
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: FixedTimeline.tileBuilder(
              theme: TimelineTheme.of(context).copyWith(
                nodePosition: 0,
              ),
              builder: TimelineTileBuilder.connected(
                connectorBuilder: (context, index, type) {
                  return DashedLineConnector(
                    color: gGreyColor.withOpacity(0.5),
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
                    border: Border.all(color: gGreyColor.withOpacity(0.5), width: 1.5),
                  );
                },
                itemExtent: 10.h,
                itemCount: dummyData.length,
                contentsBuilder: (context, index) {
                  return Padding(
                    padding:  EdgeInsets.only(top: 3.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dummyData[index].name,
                          style: TextStyle(
                            fontSize: bottomSheetHeadingFontSize,
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
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildAssignPartner(String title, String subtitle, {bool isPartner = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: loginButtonColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isPartner
              ? Icon(
                  Icons.delivery_dining_outlined,
                  size: 3.h,
                  color: gBlackColor,
                )
              : Icon(
                  Icons.search,
                  size: 3.h,
                  color: gBlackColor,
                ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
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
                    fontFamily: kFontBook,
                    fontSize: otpSubHeading,
                    color: gBlackColor,
                  ),
                ),
              ],
            ),
          ),
          isPartner
              ? Icon(
                  Icons.call,
                  color: gBlackColor,
                  size: 3.h,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class Data {
  final String name;
  final String address;
  final int isFrom;

  const Data({
    required this.name,
    required this.address,
    required this.isFrom,
  });
}

const List<Data> dummyData = [
  Data(
    name: "The Big Brunch",
    address: "Drop of Arun school",
    isFrom: 1,
  ),
  Data(
    name: "Blind School",
    address: "Avenue Colony, Flat No.404",
    isFrom: 0,
  ),
];
