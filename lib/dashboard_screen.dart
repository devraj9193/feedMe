import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:feed_me/screens/community_screens/community_screen.dart';
import 'package:feed_me/screens/home_screens/home_screen.dart';
import 'package:feed_me/screens/location_screens/location_screen.dart';
import 'package:feed_me/screens/notification_screens/notification_screen.dart';
import 'package:feed_me/screens/profile_screens/profile_screen.dart';
import 'package:feed_me/utils/app_config.dart';
import 'package:feed_me/utils/constants.dart';
import 'package:feed_me/utils/widgets/exit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _bottomNavIndex = 0;

  final int savePrevIndex = 0;

  List<TabItem> items = [
    const TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    const TabItem(
      icon: Icons.groups,
      title: 'Community',
    ),
    const TabItem(
      icon: Icons.pin_drop_outlined,
      title: 'Location',
    ),
    const TabItem(
      icon: Icons.notifications_active_outlined,
      title: 'Notifications',
    ),
    const TabItem(
      icon: Icons.manage_accounts_outlined,
      title: 'profile',
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
          return const LocationScreen();
        }
      case 3:
        {
          return const NotificationScreen();
        }
      case 4:
        {
          return const ProfileScreen();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: pageCaller(_bottomNavIndex),
        bottomNavigationBar: BottomBarDefault(
          items: items,
          backgroundColor: gWhiteColor,
          color: gBlackColor,
          colorSelected: gSecondaryColor,
          indexSelected: _bottomNavIndex,
          paddingVertical: 25,
          onTap: onChangedTab,
          titleStyle: TextStyle(
            fontSize: bottomBarHeading,
            fontFamily: kFontMedium,
          ),
        ),
      ),
    );
  }

  void onChangedTab(int index) {
    setState(() {
      _bottomNavIndex = index;
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
