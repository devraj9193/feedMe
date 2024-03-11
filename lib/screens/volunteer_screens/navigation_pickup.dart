import 'package:feed_me/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';
import '../donor_screens/google_map_screen.dart';

class NavigationPickUp extends StatefulWidget {
  final bool isDelivery;
  final String ashramId;
  final String donorId;
  const NavigationPickUp(
      {super.key,
      this.isDelivery = false,
      required this.ashramId,
      required this.donorId});

  @override
  State<NavigationPickUp> createState() => _NavigationPickUpState();
}

class _NavigationPickUpState extends State<NavigationPickUp> {
  List<Map<String, dynamic>> navigationData = [];

  var loading = true;

  @override
  void initState() {
    super.initState();
    getNavigation();
  }

  getNavigation() async {
    setState(() {
      loading = true;
    });

    // getProfileDetails =
    //     UserProfileService(repository: repository).getUserProfileService();

    print("donorId : ${widget.donorId}");
    print("ashramId : ${widget.ashramId}");

    try {
      final response = widget.isDelivery
          ? await supabase.from('ashrams').select('*').eq('id', widget.donorId)
          : await supabase.from('ashrams').select('*').eq('id', widget.ashramId);

      navigationData = response;

      print("Navigation Details : $navigationData");
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
    return WillPopWidget(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(
                () {
                  Navigator.pop(context);
                },
                showLogo: false,
                showChild: true,
                child: Text(
                  "Navigation",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    fontSize: backButton,
                    color: gBlackColor,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: loading
                      ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 35.h),
                    child:
                    buildThreeBounceIndicator(color: gBlackColor),
                  )
                      : navigationData.isEmpty
                      ? const NoDataFound()
                      : mainView(navigationData[0]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  mainView(Map<String, dynamic> navigationDetails) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current Location",
            style: TextStyle(
              fontFamily: kFontBook,
              fontSize: otpSubHeading,
              color: gBlackColor,
            ),
          ),
          Text(
            navigationDetails['ashram_name'] ?? "Hari Nagar Ashram",
            style: TextStyle(
              fontFamily: kFontBold,
              fontSize: backButton,
              color: gBlackColor,
            ),
          ),
          Text(
            navigationDetails['address'] ?? "1298 A divine view main road",
            style: TextStyle(
              fontFamily: kFontMedium,
              fontSize: textFieldHintText,
              color: gBlackColor,
            ),
          ),
          const GoogleMapScreen(),
          Text(
            "Here to pick up the food from Dawat Restaurant",
            style: TextStyle(
              fontFamily: kFontMedium,
              fontSize: textFieldHintText,
              color: gBlackColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5.h,
                  width: 15.w,
                  margin: EdgeInsets.only(right: 3.w),
                  decoration: BoxDecoration(
                    color: imageBackGround,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ImageNetwork(
                    image: '',
                    height: 5.h,
                    width: 15.w,
                    // duration: 1500,
                    curve: Curves.easeIn,
                    // onPointer: true,
                    // debugPrint: false,
                    // fullScreen: false,
                    // fitAndroidIos: BoxFit.cover,
                    // fitWeb: BoxFitWeb.contain,
                    // borderRadius: BorderRadius.circular(8),
                    // onError: const Icon(
                    //   Icons.image_outlined,
                    //   color: loginButtonSelectedColor,
                    // ),
                    // onTap: () {
                    //   debugPrint("©gabriel_patrick_souza");
                    // },
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        navigationDetails['ashram_name'],
                        style: TextStyle(
                          fontSize: listHeadingSize,
                          fontFamily: listHeadingFont,
                          color: gBlackColor,
                        ),
                      ),
                      Text(
                        "contact",
                        style: TextStyle(
                          fontSize: listOtherSize,
                          fontFamily: listOtherFont,
                          color: gBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: gWhiteColor,
                      border: Border.all(color: gBlackColor, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.call,
                      color: gBlackColor,
                      size: 2.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildPickUp(
              Icon(
                Icons.access_time,
                size: 3.h,
                color: gBlackColor,
              ),
              "Pick Up",
              "15 mins"),
          SizedBox(height: 2.h),
          buildPickUp(
              Icon(
                Icons.trending_down_sharp,
                size: 3.h,
                color: gBlackColor,
              ),
              "Distance",
              "3.1 kms"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: ElevatedButton(
              onPressed: widget.isDelivery ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>const DashboardScreen()
                  ),
                );
              } : (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NavigationPickUp(
                      ashramId: widget.ashramId.toString(),
                      donorId: widget.donorId.toString(),
                      isDelivery: true,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor:
                    loginButtonSelectedColor, //change background color of button
                backgroundColor: loginButtonColor, //change text color of button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2.0,
              ),
              child: Center(
                child: Text(
                  widget.isDelivery ? "Confirm Delivery" : "Confirm Pick up",
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
    );
  }

  buildPickUp(Icon icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: 3.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: kFontBook,
                fontSize: otpSubHeading,
                color: gBlackColor,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: kFontBold,
                fontSize: backButton,
                color: gBlackColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
