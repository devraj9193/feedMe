import 'package:feed_me/screens/accepted_orders/accepted_orders.dart';
import 'package:feed_me/screens/history_of_donations_screens/history_of_donation_screen.dart';
import 'package:feed_me/screens/community_screens/community_screen.dart';
import 'package:feed_me/screens/home_screens/home_screen.dart';
import 'package:feed_me/screens/profile_screens/settings_screen.dart';
import 'package:feed_me/utils/app_config.dart';
import 'package:feed_me/utils/constants.dart';
import 'package:feed_me/utils/widgets/exit_widget.dart';
import 'package:feed_me/utils/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  final int index;
  const DashboardScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _bottomNavIndex = 0;
  bool showFab = true;
  final int savePrevIndex = 0;

  String? userName, userType,userRestaurant, userAddress;

  final SharedPreferences _pref = AppConfig().preferences!;

  @override
  void initState() {
    super.initState();
    setState(() {
      _bottomNavIndex = widget.index;
    });
    setState(() {
      userName = _pref.getString(AppConfig.userName) ?? '';
      userType = _pref.getString(AppConfig.userType) ?? '';
      userRestaurant = _pref.getString(AppConfig.userRestaurant) ?? '';
      userAddress = _pref.getString(AppConfig.userAddress) ?? '';
    });
  }

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
        size: 3.h,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.groups,
        size: 3.h,
      ),
      label: 'Community',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.pin_drop_outlined,
        size: 3.h,
      ),
      label: 'Donations',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.notifications_active_outlined,
        size: 3.h,
      ),
      label: 'Accepted',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.manage_accounts_outlined,
        size: 3.h,
      ),
      label: 'profile',
    ),
  ];

  pageCaller(int index) {
    switch (index) {
      case 0:
        {
          return const HomeScreen();
        }
      case 1:
        {
          return const CommunityScreen();
        }
      case 2:
        {
          return const HistoryOfDonation();
        }
      case 3:
        {
          return const AcceptedOrdersScreen();
        }
      case 4:
        {
          return const SettingsScreen();
          //return const ProfileScreen();
        }
    }
  }

  @override
  Widget build(BuildContext context) {

    print("User Type : $userType");

    var subTitle = userType == "Donor" ? userRestaurant : userAddress;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showFab
                  ?  SizedBox(height: 1.h) : const SizedBox(),
              showFab
                  ? Row(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
              ) : const SizedBox(),
              Expanded(child:
              pageCaller(_bottomNavIndex),),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          selectedFontSize: bottomBarHeading,
          selectedItemColor: appPrimaryColor,
          iconSize: 2.5.h,
          currentIndex: _bottomNavIndex,
          onTap: onChangedTab,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: bottomBarHeading,
            fontFamily: kFontMedium,
            color: gBlackColor,
          ),
          items: items,
        ),
        // bottomNavigationBar: BottomBarDefault(
        //   items: items,
        //   backgroundColor: gWhiteColor,
        //   color: gBlackColor,
        //   colorSelected: gSecondaryColor,
        //   indexSelected: _bottomNavIndex,
        //   paddingVertical: 25,
        //   onTap: onChangedTab,
        //   titleStyle: TextStyle(
        //     fontSize: bottomBarHeading,
        //     fontFamily: kFontMedium,
        //   ),
        // ),
      ),
    );
  }

  void onChangedTab(int index) {
    setState(() {
      _bottomNavIndex = index;
      if (_bottomNavIndex == 4) {
        showFab = false;
      } else {
        showFab = true;
      }
    });
  }

  /// on back button press if we r in other index except 2
  /// than we r moving to 2nd index
  Future<bool> _onWillPop() async {
    if (_bottomNavIndex != 0) {
      onChangedTab(0);
    } else {
      AppConfig().showSheet(
        context,
        const ExitWidget(),
        bottomSheetHeight: 45.h,
        isDismissible: true,
      );
    }
    return false;
  }
}
