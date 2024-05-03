import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../dashboard_screen.dart';
import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';
import '../donor_screens/donor_food_screen.dart';
import '../volunteer_screens/ashram_food_request_list_screen.dart';
import 'ngo_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key, }) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
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

      final datas = await supabase
          .from('ashrams')
          .select('*')
          .eq('ngo_id', _pref.getString(AppConfig.userId) as Object);

      print("ngo : $datas");

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

    print("User Type : $userType");

    var subTitle = userType == "Donor" ? userRestaurant : userAddress;

    return userType == "ngo" ? const NgoScreen() : WillPopWidget(
      child: Scaffold(
        body: SafeArea(
          child: loading
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 35.h),
                  child: buildThreeBounceIndicator(color: gBlackColor),
                )
              : getDashboard.isEmpty
                  ? const NoDataFound()
                  : buildList(),
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
                      image: file['image_url'] ?? "",
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
                            // Text(
                            //   "Meal for ${file['meal_request']} people",
                            //   style: TextStyle(
                            //     fontSize: listSubHeadingSize,
                            //     height: 1.3,
                            //     fontFamily: listSubHeadingFont,
                            //     color: gBlackColor,
                            //   ),
                            // ),
                             SizedBox(height: 1.5.h),
                            Text(
                              file['address'],
                              style: TextStyle(
                                fontSize: listOtherSize,
                                height: 1.7,
                                fontFamily: listOtherFont,
                                color: gBlackColor,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Row(
                            //       children: [
                            //         Icon(
                            //           Icons.location_on_outlined,
                            //           size: 1.5.h,
                            //           color: gBlackColor,
                            //         ),SizedBox(width: 1.w),
                            //         Text(
                            //           "4 Kms",
                            //           style: TextStyle(
                            //             fontSize: listOtherSize,
                            //             fontFamily: listOtherFont,
                            //             color: gBlackColor,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     userType == "Donor"
                            //         ?  Row(
                            //       children: [
                            //         Icon(
                            //           Icons.timer_sharp,
                            //           size: 1.5.h,
                            //           color: gBlackColor,
                            //         ),
                            //         SizedBox(width: 1.w),
                            //         Text(
                            //           "Posted at ${DateFormat.jm().format(DateTime.parse(file['created_at']))}",
                            //           style: TextStyle(
                            //             fontSize: listOtherSize,
                            //             fontFamily: listOtherFont,
                            //             color: gBlackColor,
                            //           ),
                            //         ),
                            //         SizedBox(width: 3.w),
                            //       ],
                            //     ) : Row(
                            //       children: [
                            //         Icon(
                            //           Icons.timer_sharp,
                            //           size: 1.5.h,
                            //           color: gBlackColor,
                            //         ),SizedBox(width: 1.w),
                            //         Text(
                            //           "Cooked 1hr ago",
                            //           style: TextStyle(
                            //             fontSize: listOtherSize,
                            //             fontFamily: listOtherFont,
                            //             color: gBlackColor,
                            //           ),
                            //         ),
                            //         SizedBox(width: 3.w),
                            //       ],
                            //     ),
                            //
                            //   ],
                            // ),
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
