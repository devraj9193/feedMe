import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';
import '../donor_screens/donor_food_screen.dart';
import '../volunteer_screens/ashram_food_request_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final searchController = TextEditingController();

  final SharedPreferences _pref = AppConfig().preferences!;
  String? userName, userType, userRestaurant, userAddress;

  @override
  void initState() {
    super.initState();
    getDashboardData();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() async {
    super.dispose();
    tabController?.dispose();
  }

  var loading = true;
  List<Map<String, dynamic>> getDashboard = [];

  getDashboardData() async {
    setState(() {
      loading = true;
    });

    try {
      final data = await supabase.from('ashrams').select('*');

      print("getDashboardData : $data");

      getDashboard = data;

      setState(() {
        userName = _pref.getString(AppConfig.userName) ?? '';
        userType = _pref.getString(AppConfig.userType) ?? '';
        userRestaurant = _pref.getString(AppConfig.userRestaurant) ?? '';
        userAddress = _pref.getString(AppConfig.userAddress) ?? '';
      });

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
    var subTitle = userType == "Donor" ? userRestaurant : userAddress;

    return WillPopWidget(
      child: Scaffold(
        body: SafeArea(
          child: loading
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 35.h),
                  child: buildThreeBounceIndicator(color: gBlackColor),
                )
              : getDashboard.isEmpty
                  ? const NoDataFound()
                  : Column(
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
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: gBlackColor,
                                    size: 3.5.h,
                                  ),
                                  SizedBox(width: 1.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Welcome ${toBeginningOfSentenceCase(userName)}",
                                        style: TextStyle(
                                          fontFamily: kFontBold,
                                          fontSize: backButton,
                                          color: gBlackColor,
                                        ),
                                      ),
                                      Text(
                                        subTitle ?? "",
                                        style: TextStyle(
                                          fontFamily: kFontBook,
                                          fontSize: otpSubHeading,
                                          color: gBlackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 3.w),
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: gGreyColor.withOpacity(0.5),
                                  ),
                                ),
                                child: ImageNetwork(
                                  image: '',
                                  height: 35,
                                  width: 35,
                                  // duration: 1500,
                                  curve: Curves.easeIn,
                                  onPointer: true,
                                  debugPrint: false,
                                  fullScreen: false,
                                  fitAndroidIos: BoxFit.cover,
                                  fitWeb: BoxFitWeb.contain,
                                  borderRadius: BorderRadius.circular(70),
                                  onError: Icon(
                                    Icons.person,
                                    color: gGreyColor.withOpacity(0.5),
                                  ),
                                  onTap: () {
                                    debugPrint("©gabriel_patrick_souza");
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 6.h,
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          margin: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: loginButtonSelectedColor,
                          ),
                          child: TextFormField(
                            cursorColor: gGreyColor,
                            controller: searchController,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: textFieldHintColor.withOpacity(0.5),
                                size: 2.5.h,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searchController.clear();
                                  });
                                },
                                child: Icon(
                                  Icons.cancel_outlined,
                                  color: textFieldHintColor.withOpacity(0.5),
                                  size: 2.5.h,
                                ),
                              ),
                              hintText: "Search for NGO or Hunger spots",
                              hintStyle: TextStyle(
                                fontFamily: textFieldHintFont,
                                color: textFieldHintColor.withOpacity(0.5),
                                fontSize: textFieldHintText,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                                fontFamily: textFieldFont,
                                fontSize: textFieldText,
                                color: textFieldColor),
                            onChanged: (value) {},
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: buildList(),
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
      itemCount: getDashboard.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        dynamic file = getDashboard[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => userType == "Donor"
                    ? DonorFoodScreen(
                        donorData: file,
                      )
                    : userType == "Volunteer" ? AshramFoodRequestListScreen(volunteerData: file,) : const SizedBox(),
                // VolunteerDeliveryDetails(volunteerData: file,),
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
                              file['ashram_name'],
                              style: TextStyle(
                                fontSize: listHeadingSize,
                                fontFamily: listHeadingFont,
                                color: gBlackColor,
                              ),
                            ),
                            Text(
                              "Meal for ${file['meal_request']} people",
                              style: TextStyle(
                                fontSize: listSubHeadingSize,
                                height: 1.3,
                                fontFamily: listSubHeadingFont,
                                color: gBlackColor,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              file['address'],

                              style: TextStyle(
                                fontSize: listOtherSize,
                                height: 1.3,
                                fontFamily: listOtherFont,
                                color: gBlackColor,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 1.5.h,
                                      color: gBlackColor,
                                    ),SizedBox(width: 1.w),
                                    Text(
                                      "4 Kms",
                                      style: TextStyle(
                                        fontSize: listOtherSize,
                                        fontFamily: listOtherFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                userType == "Donor"
                                    ?  Row(
                                  children: [
                                    Icon(
                                      Icons.timer_sharp,
                                      size: 1.5.h,
                                      color: gBlackColor,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      "Posted at ${DateFormat.jm().format(DateTime.parse(file['created_at']))}",
                                      style: TextStyle(
                                        fontSize: listOtherSize,
                                        fontFamily: listOtherFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                  ],
                                ) : Row(
                                  children: [
                                    Icon(
                                      Icons.timer_sharp,
                                      size: 1.5.h,
                                      color: gBlackColor,
                                    ),SizedBox(width: 1.w),
                                    Text(
                                      "Cooked 1hr ago",
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
}
