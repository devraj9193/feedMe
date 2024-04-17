import 'package:feed_me/screens/community_screens/community_screen.dart';
import 'package:feed_me/screens/home_screens/home_screen.dart';
import 'package:feed_me/screens/location_screens/location_screen.dart';
import 'package:feed_me/screens/new_home_screen/new_home_screen.dart';
import 'package:feed_me/screens/notification_screens/notification_screen.dart';
import 'package:feed_me/screens/profile_screens/profile_screen.dart';
import 'package:feed_me/screens/profile_screens/settings_screen.dart';
import 'package:feed_me/utils/app_config.dart';
import 'package:feed_me/utils/constants.dart';
import 'package:feed_me/utils/widgets/exit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class DashboardScreen extends StatefulWidget {
  final int index;
  const DashboardScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _bottomNavIndex = 0;

  final int savePrevIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _bottomNavIndex = widget.index;
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
      label: 'Location',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.notifications_active_outlined,
        size: 3.h,
      ),
      label: 'Notifications',
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
          return const NewHomeScreen();
        }
      case 1:
        {
          return const HomeScreen();
        }
      case 2:
        {
          return const CommunityScreen();
        }
      case 3:
        {
          return const NotificationScreen();
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: pageCaller(_bottomNavIndex),
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
