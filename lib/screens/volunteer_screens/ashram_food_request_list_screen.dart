import 'package:feed_me/screens/volunteer_screens/volunteer_delivery_details.dart';
import 'package:feed_me/utils/widgets/will_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../dashboard_screen.dart';
import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../../utils/widgets/widgets.dart';

class AshramFoodRequestListScreen extends StatefulWidget {
  final dynamic volunteerData;
  const AshramFoodRequestListScreen({Key? key, required this.volunteerData}) : super(key: key);

  @override
  State<AshramFoodRequestListScreen> createState() =>
      _AshramFoodRequestListScreenState();
}

class _AshramFoodRequestListScreenState
    extends State<AshramFoodRequestListScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> pendingList = [];

  @override
  void initState() {
    super.initState();
    getDeliveryDetails();
  }

  getDeliveryDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data =
          await supabase.from('ashram_requests').select('*').eq('ashram_id', widget.volunteerData['id']);

      print("Donation List : $data");

      for (var element in data) {
        print("element :$element");

        if (element['status'] == "pending") {
          pendingList.add(element);

          print("pendingList : $pendingList");
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
          isLoading = false;
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
            children: [
              SizedBox(height: 1.h),
              buildAppBar(
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(index: 1,),
                    ),
                  );
                },
                showLogo: false,
                showChild: true,
                child: Text(
                  widget.volunteerData['ashram_name'],
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    fontSize: backButton,
                    color: gBlackColor,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: isLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 35.h),
                          child: buildThreeBounceIndicator(color: gBlackColor),
                        )
                      : pendingList.isEmpty
                          ? const NoDataFound()
                          : buildList(),
                ),
              ),
              // TabBar(
              //   controller: tabController,
              //   labelColor: gBlackColor,
              //   unselectedLabelColor: gGreyColor.withOpacity(0.5),
              //   indicatorColor: gBlackColor,
              //   labelStyle: TextStyle(
              //     fontFamily: kFontBold,
              //     color: gPrimaryColor,
              //     fontSize: tapSelectedSize,
              //   ),
              //   unselectedLabelStyle: TextStyle(
              //     fontFamily: tapFont,
              //     color: gHintTextColor,
              //     fontSize: tapUnSelectedSize,
              //   ),
              //   labelPadding: EdgeInsets.only(
              //       right: 0.w, left: 0.w, top: 1.h, bottom: 1.h),
              //   tabs: const [
              //     Text('DONOR'),
              //     Text('VOLUNTEER'),
              //   ],
              // ),
              // Expanded(
              //   child: TabBarView(
              //     controller: tabController,
              //     // physics: const NeverScrollableScrollPhysics(),
              //     children: const [
              //       DonorList(),
              //       VolunteerList(),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  buildList() {
    return ListView.builder(
      itemCount: pendingList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        dynamic file = pendingList[index];
        return  GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => VolunteerDeliveryDetails(
                  volunteerData: file, ashramFoodRequestList: widget.volunteerData,
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
                        debugPrint("©gabriel_patrick_souza");
                      },
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            SizedBox(height: 1.5.h),
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
                            SizedBox(height: 1.5.h),
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
