import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';
import 'navigation_pickup.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Map<String, dynamic>> acceptedData = [];

  final _prefs = AppConfig().preferences;

  var loading = true;

  @override
  void initState() {
    super.initState();
    getAcceptedList();
  }

  getAcceptedList() async {
    setState(() {
      loading = true;
    });

    // getProfileDetails =
    //     UserProfileService(repository: repository).getUserProfileService();

    try {
      print("userId : ${_prefs?.getString(AppConfig.userId)}");

      final response = await supabase
          .from('ashram_requests')
          .select('*')
          .eq('volunteer_id', "${_prefs?.getString(AppConfig.userId)}");

      acceptedData = response;

      print("accepted orders : $acceptedData");
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
            padding: EdgeInsets.only(top: 1.h, left: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildAppBar(
                  () {},
                  isBackEnable: false,
                  showLogo: false,
                  showChild: true,
                  child: Text(
                    "Accepted Orders",
                    style: TextStyle(
                      fontFamily: kFontBold,
                      fontSize: 15.dp,
                      color: gBlackColor,
                    ),
                  ),
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
                        : acceptedData.isEmpty
                            ? const NoDataFound()
                            : buildAcceptedDetails(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildAcceptedDetails() {
    return ListView.builder(
      itemCount: acceptedData.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        dynamic file = acceptedData[index];
        return GestureDetector(
          onTap: () {
            buildOnClick(file);
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
                        buildOnClick(file);
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
                                Text(
                                  "${file['food_quantity']}",
                                  style: TextStyle(
                                    fontSize: listSubHeadingSize,
                                    height: 1.3,
                                    fontFamily: listSubHeadingFont,
                                    color: gBlackColor,
                                  ),
                                ),
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
                                      height: 1.5,
                                      fontFamily: kFontBook,
                                      color: gBlackColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: file['pickup_time'],
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
                            SizedBox(height: 1.h),
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
                                      Icons.timer_sharp,
                                      size: 1.5.h,
                                      color: gBlackColor,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      file['cooking_time'],
                                      style: TextStyle(
                                        fontSize: listOtherSize,
                                        fontFamily: listOtherFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
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

  void buildOnClick(Map<String, dynamic> file) {
    if (file['status'] == "accepted") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NavigationPickUp(
            file: file,
          ),
        ),
      );
    } else if (file['status'] == "picked_up") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NavigationPickUp(
            file: file,
            isDelivery: true,
          ),
        ),
      );
    } else if (file['status'] == "delivered") {
      deliveredWidget(context);
    } else {}
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
