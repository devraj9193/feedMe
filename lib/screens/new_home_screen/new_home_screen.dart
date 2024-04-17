import 'package:carousel_slider/carousel_slider.dart';
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
import 'feed_list.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  final searchController = TextEditingController();

  final SharedPreferences _pref = AppConfig().preferences!;
  String? userName, userType, userRestaurant, userAddress;

  final carouselController = CarouselController();
  int _current = 0;
  List reviewList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_c-mB3wULLhpdFqSL2w8-2v5I1Nu-bbLoUg&s',
    'https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg',
    'https://i0.wp.com/picjumbo.com/wp-content/uploads/beautiful-nature-mountain-scenery-with-flowers-free-photo.jpg?w=600&quality=80',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTVGqkBZBQZ6P8dAc9BKMPxpfvcWqNodCpBg&s',
  ];

  @override
  void initState() {
    super.initState();
    getCardFeedData();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  var loading = true;
  List<Map<String, dynamic>> getCardList = [];
  List<Map<String, dynamic>> getFeedList = [];

  getCardFeedData() async {
    setState(() {
      loading = true;
    });

    try {
      final cardData = await supabase.from('ashrams').select('*');

      final feedData = await supabase.from('feeds').select('*');

      print("feedData : $feedData");

      print("cardData : $cardData");

      getCardList = cardData;

      getFeedList = feedData;

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
              : userType == "Volunteer"
                  ? FeedList(
                      isButton: true,
                      feedList: getFeedList,
                    )
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
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DashboardScreen(
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
                          height: 5.h,
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
                        buildCards(),
                        const Divider(),
                         Expanded(
                          child: SingleChildScrollView(
                            child: FeedList(
                              feedList: getFeedList,
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  buildCards() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
      child: Column(
        children: [
          SizedBox(
            height: 18.h,
            width: double.maxFinite,
            child: CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                  viewportFraction: .6,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: getCardList.map((e) {
                print("feed images : $e");
                return Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: kNumberCircleRed.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        "${e['image_url']}",
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: getCardList.map((url) {
              int index = getCardList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? appPrimaryColor
                      : kNumberCircleRed.withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
