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
import '../community_screens/navigation_pickup.dart';

class NgoScreen extends StatefulWidget {
  const NgoScreen({super.key});

  @override
  State<NgoScreen> createState() => _NgoScreenState();
}

class _NgoScreenState extends State<NgoScreen> with SingleTickerProviderStateMixin {
  TabController? tabController;
  final searchController = TextEditingController();

  final SharedPreferences _pref = AppConfig().preferences!;
  String? userName, userType, userRestaurant, userAddress;

  @override
  void initState() {
    super.initState();
    getAshramId();
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

      if(getDashboard.isNotEmpty){
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

  List<Map<String, dynamic>> getPickedUpData = [];
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
        }else if(element['status'] == "picked_up") {
          getPickedUpData.add(element);

          print("getPickedUpData : $getPickedUpData");
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
    return  WillPopWidget(
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
                        Text(
                          "Welcome ${toBeginningOfSentenceCase(userName)}",
                          style: TextStyle(
                            fontFamily: kFontBold,
                            fontSize: backButton,
                            color: gBlackColor,
                          ),
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const DashboardScreen(
                                index: 4,
                              ),
                            ),
                          );
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
              TabBar(
                controller: tabController,
                labelColor: gBlackColor,
                unselectedLabelColor: gGreyColor.withOpacity(0.5),
                indicatorColor: gBlackColor,
                labelStyle: TextStyle(
                  fontFamily: kFontBold,
                  color: gPrimaryColor,
                  fontSize: tapSelectedSize,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: tapFont,
                  color: gHintTextColor,
                  fontSize: tapUnSelectedSize,
                ),
                labelPadding: EdgeInsets.only(
                    right: 0.w, left: 0.w, top: 1.h, bottom: 1.h),
                tabs: const [
                  Text('Picked Up'),
                  Text('Delivered'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  // physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildList(getPickedUpData),
                    buildList(getDeliveredData),
                  ],
                ),
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
