import 'dart:async';
import 'package:feed_me/screens/login_screens/feed_me_screen.dart';
import 'package:feed_me/utils/app_config.dart';
import 'package:feed_me/utils/constants.dart';
import 'package:feed_me/utils/widgets/open_alert_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:open_store/open_store.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  bool isLogin = false;

  bool isError = false;

  String errorMsg = '';
  String? deviceId;

  final _pref = AppConfig().preferences!;

  /// for App Update Dialog
  bool isAppUpdateAlertClosed = true;


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getDeviceId();
    super.initState();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState");
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        // show update alert if user didnot updated the app
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
      case AppLifecycleState.hidden:
    }
  }

  Future getDeviceId() async{
    final _pref = AppConfig().preferences;

    if(_pref!.getString(AppConfig().deviceId) == null || _pref.getString(AppConfig().deviceId) == ""){
      print("getDeviceId if");
      await AppConfig().getDeviceId().then((id) {
        print("deviceId: $id");
        if(id != null){
          _pref.setString(AppConfig().deviceId, id);
          deviceId = id;
        }
      });
    }
    else{
      print("getDeviceId else");
      deviceId = _pref.getString(AppConfig().deviceId);
    }
    startTimer();
  }

  startTimer(){
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 1;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
    getScreen();
  }


  getScreen(){
    setState(() {
      isLogin = _pref.getBool(AppConfig.isLogin) ?? false;
    });

    print("_pref.getBool(AppConfig.isLogin): ${_pref.getBool(AppConfig.isLogin)}");
    print("isLogin: $isLogin");
  }



  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gWhiteColor,
      body: Stack(
        children: <Widget>[
          PageView(
            reverse: false,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: <Widget>[
              splashImage(),
                isLogin
                    ? const DashboardScreen(index: 0,)
                    : const FeedMeScreen()
            ],
          ),
        ],
      ),
    );
  }

  splashImage() {
    return Center(
      child: Image(
        width: 70.w,
        image: const AssetImage("assets/images/Connect Care_logo.png"),
      ),
      // SvgPicture.asset(
      //     "assets/images/splash_screen/Splash screen Logo.svg"),
    );
  }

  /// alert box when there is a new update
  showAppUpdateAlert(){
    return openAlertBox(
        context: context,
        barrierDismissible: false,
        content: AppConfig.updateAppContent,
        titleNeeded: true,
        title: "Update Available",
        isSingleButton: true,
        positiveButtonName: 'Update Now',
        positiveButton: (){
          OpenStore.instance.open(
            // appStoreId: '284815942', // AppStore id of your app for iOS
            // appStoreIdMacOS: '284815942', // AppStore id of your app for MacOS (appStoreId used as default)
            androidAppBundleId: AppConfig.androidBundleId, // Android app bundle package name
            // windowsProductId: '9NZTWSQNTD0S' // Microsoft store id for Widnows apps
          );
          isAppUpdateAlertClosed = true;
          Navigator.pop(context);
        }
    );
  }

}
