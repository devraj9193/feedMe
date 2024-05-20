import 'package:feed_me/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';
import '../donor_screens/google_map_screen.dart';

class NavigationPickUp extends StatefulWidget {
  final bool isDelivery;
  final Map<String, dynamic> file;
  const NavigationPickUp(
      {Key? key, this.isDelivery = false, required this.file})
      : super(key: key);

  @override
  State<NavigationPickUp> createState() => _NavigationPickUpState();
}

class _NavigationPickUpState extends State<NavigationPickUp> {
  List<Map<String, dynamic>> navigationAshramData = [];
  List<Map<String, dynamic>> navigationDonorData = [];

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

    print("navigation : ${widget.file}");

    print("donorId : ${widget.file["donor_id"]}");
    print("ashramId : ${widget.file["ashram_id"]}");

    try {
      final response = await supabase
          .from('users')
          .select('*')
          .eq('id', widget.file["donor_id"]);
      final resp = await supabase
          .from('ashrams')
          .select('*')
          .eq('id', widget.file["ashram_id"]);

      setState(() {
        navigationAshramData = resp;

        navigationDonorData = response;

        print("navigationAshramData : ${navigationAshramData}");
        print("navigationDonorData : ${navigationDonorData}");
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
                          child: buildThreeBounceIndicator(color: gBlackColor),
                        )
                      : navigationDonorData.isEmpty ||
                              navigationAshramData.isEmpty
                          ? const NoDataFound()
                          : mainView(
                              donorData: navigationDonorData[0],
                              ashramData: navigationAshramData[0]),
                  //                 ashramName: navigationData[0]['res_name'],
                  //                 ashramAddress: navigationData[0]['location'],
                  //                 deliveryName: navigationData[0]['res_name'],
                  //                 deliveryPickUp: "15 Mins",
                  //                 deliveryDistance: "3.1 Kms",
                  //                 ashramPic:
                  //                     navigationData[0]['image_url'] ?? '',
                  //                 ashramPhone: navigationData[0]['phone'] ?? '',
                  // )
                  //             : mainView(
                  //                 ashramName: navigationData[0]['ashram_name'],
                  //                 ashramAddress: navigationData[0]['address'],
                  //                 deliveryName: navigationData[0]
                  //                     ['ashram_name'],
                  //                 deliveryPickUp: "15 Mins",
                  //                 deliveryDistance: "3.1 Kms",
                  //                 ashramPic:
                  //                     navigationData[0]['image_url'] ?? '',
                  //                 ashramPhone:
                  //                     navigationData[0]['phone'] ?? '',
                ),
              ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  mainView(
      {required Map<String, dynamic> donorData,
      required Map<String, dynamic> ashramData}) {
    print("donorData['res_name'] : ${navigationDonorData[0]}");
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
            widget.isDelivery
                ? donorData['res_name'] ?? ''
                : ashramData['ashram_name'] ?? '',
            style: TextStyle(
              fontFamily: kFontBold,
              fontSize: backButton,
              color: gBlackColor,
            ),
          ),
          Text(
            widget.isDelivery
                ? donorData['location'] ?? ''
                : ashramData['address'] ?? '',
            style: TextStyle(
              fontFamily: kFontMedium,
              fontSize: textFieldHintText,
              color: gBlackColor,
            ),
          ),
          GoogleMapScreen(
            sourceLatitude: ashramData['latitude'] ?? 0.0,
            sourceLongitude: ashramData['longitude'] ?? 0.0,
            destinationLatitude: 0.0,
            destinationLongitude: 0.0,
          ),
          Text(
            !widget.isDelivery
                ? "Here to pick up the food from ${ashramData['ashram_name'] ?? ''}"
                : "Here Deliver the food to ${donorData['res_name'] ?? ''}",
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
                    image: widget.isDelivery
                        ? ashramData['image_url'] ?? ''
                        : donorData['profile_pic'] ?? '',
                    height: 5.h,
                    width: 15.w,
                    // duration: 1500,
                    curve: Curves.easeIn,
                    onPointer: true,
                    debugPrint: false,
                    fullScreen: false,
                    fitAndroidIos: BoxFit.cover,
                    fitWeb: BoxFitWeb.contain,
                    borderRadius: BorderRadius.circular(8),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isDelivery
                            ? ashramData['ashram_name'] ?? ''
                            : donorData['res_name'] ?? '',
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
                  onTap: () async {
                    String url = widget.isDelivery
                        ? "tel:${ashramData['phone']}"
                        : "tel:${donorData['phone']}";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
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
            widget.isDelivery
                ? widget.file['expectation_time']
                : widget.file['pickup_time'],
          ),
          SizedBox(height: 2.h),
          // buildPickUp(
          //     Icon(
          //       Icons.trending_down_sharp,
          //       size: 3.h,
          //       color: gBlackColor,
          //     ),
          //     "Distance",
          //     "deliveryDistance"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      submitConfirmStatus(
                        widget.isDelivery ? "delivered" : "picked_up",
                        "${_prefs?.getString(AppConfig.userId)}",
                        widget.file['id'].toString(),
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
                child: (isLoading)
                    ? buildThreeBounceIndicator(color: gBlackColor)
                    : Text(
                        widget.isDelivery
                            ? "Confirm Delivery"
                            : "Confirm Pick up",
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

  bool isLoading = false;

  final _prefs = AppConfig().preferences;

  void submitConfirmStatus(
    String status,
    String volunteerId,
    String requestId,
  ) async {
    setState(() {
      isLoading = true;
    });

    print("volunteerId : $volunteerId");

    try {
      final res = status == "delivered"
          ? await supabase.from('ashram_requests').update({
              'status': status,
              'volunteer_id': volunteerId,
              'reward_points': "50",
            }).eq('id', requestId)
          : await supabase.from('ashram_requests').update({
              'status': status,
              'volunteer_id': volunteerId,
            }).eq('id', requestId);

      print("submitConfirmStatus:$res");
      print("submitConfirmStatus.runtimeType: ${res.runtimeType}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(
            index: 1,
          ),
        ),
      );
    } on PostgrestException catch (error) {
      AppConfig().showSnackbar(context, error.message, isError: true);
    } catch (error) {
      AppConfig()
          .showSnackbar(context, 'Unexpected error occurred', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
