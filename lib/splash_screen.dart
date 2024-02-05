import 'dart:async';
import 'package:feed_me/screens/login_screens/feed_me_screen.dart';
import 'package:feed_me/service/notification_service.dart';
import 'package:feed_me/utils/app_config.dart';
import 'package:feed_me/utils/widgets/open_alert_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    runAllAsync();
    firebaseNotif();
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


  late FirebaseMessaging messaging;

  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  firebaseNotif() async{
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      // iOS: IOSInitializationSettings(),
    );
    _notificationsPlugin.initialize(
        initializationSettings,
       // onSelectNotification: onClickedNotifications
      // onSelectNotification: (payload) async {
      //   print('payload: $payload');
      //   onNotifications.add(payload);
      //   // Get.to(() => const NotificationsList());
      //   // print("onSelectNotification");
      //   // if (id!.isNotEmpty) {
      //   //   print("Router Value1234 $id");
      //
      //   //   // Navigator.of(context).push(
      //   //   //   MaterialPageRoute(
      //   //   //     builder: (context) => const NotificationsList(),
      //   //   //   ),
      //   //   // );
      //   // }
      // },
    );
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.toMap());
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          //message.data11 {notification_type: shopping, tag_id: ,
          // body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}
          // W/dy.gwc_custome(31771): Reducing the number of considered missed Gc histogram windows from 150 to 100
          // I/flutter (31771): message recieved: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}
          // I/flutter (31771): Notification Message: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}

          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) async {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print(message.toMap());
          print("message.data22 ${message.data['notification_type']}");
                }
      },
    );
  }

  runAllAsync() async{
    await Future.wait([
      getPermission(),
    ]);
    print("starting Application!");
  }

  Future listenNotifications()async{
    LocalNotificationService.onNotifications.stream
        .listen(onClickedNotifications);}

  void onClickedNotifications(String? payload)
  {
    print("on notification click: $payload");
    if(payload != null){
      if(payload == 'new_chat'){

      }
      else{
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => const NotificationScreen(),
        //   ),
        // );
      }
    }
  }

  Future getPermission() async{
    // await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;

    String? fcmToken = await messaging.getToken();
    print("fcm: $fcmToken");
    _pref.setString(AppConfig.FCM_TOKEN, fcmToken!);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
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
      isLogin = _pref.getBool(AppConfig.IS_LOGIN) ?? false;
    });

    print("_pref.getBool(AppConfig.isLogin): ${_pref.getBool(AppConfig.IS_LOGIN)}");
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
                    ? const DashboardScreen()
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
