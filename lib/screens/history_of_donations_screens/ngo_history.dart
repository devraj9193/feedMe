import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';
import '../community_screens/feedback_screen.dart';

class NgoHistory extends StatefulWidget {
  const NgoHistory({super.key});

  @override
  State<NgoHistory> createState() => _NgoHistoryState();
}

class _NgoHistoryState extends State<NgoHistory> {

  final SharedPreferences _pref = AppConfig().preferences!;
  String? userName, userType, userRestaurant, userAddress;

  @override
  void initState() {
    super.initState();
    getAshramId();
  }

  var loading = true;
  List<Map<String, dynamic>> getDashboard = [];
  List<Map<String, dynamic>> getDashboardNgoData = [];

  getAshramId() async {
    setState(() {
      loading = true;
    });

    try {
      final data = await supabase
          .from('ashrams')
          .select('*')
          .eq('ngo_id', _pref.getString(AppConfig.userId) as Object);

      print("getDashboardNGOData : $data");

      getDashboard = data;

      if (getDashboard.isNotEmpty) {
        setState(() {
          userName = getDashboard[0]['ashram_name'] ?? '';
          userType = _pref.getString(AppConfig.userType) ?? '';
          userRestaurant = _pref.getString(AppConfig.userRestaurant) ?? '';
          userAddress = _pref.getString(AppConfig.userAddress) ?? '';
        });
        getNgoData(getDashboard[0]['id']);
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

  List<Map<String, dynamic>> getDeliveredData = [];

  getNgoData(int ashramId) async {
    setState(() {
      loading = true;
    });

    try {
      final data = await supabase
          .from('ashram_requests')
          .select('*')
          .eq('ashram_id', ashramId);

      print("getDashboardNGOData : $data");

      getDashboardNgoData = data;

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
      reverse: true,
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        dynamic file = lst[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
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
                                      file['reward_points'] ?? '',
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
}
