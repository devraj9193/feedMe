import 'package:feed_me/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timelines/timelines.dart';

import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../../utils/widgets/widgets.dart';

import '../donor_screens/live_tracking.dart';
import '../community_screens/navigation_pickup.dart';

class VolunteerDeliveryDetails extends StatefulWidget {
  final dynamic volunteerData;

  const VolunteerDeliveryDetails({Key? key, required this.volunteerData}) : super(key: key);

  @override
  State<VolunteerDeliveryDetails> createState() =>
      _VolunteerDeliveryDetailsState();
}

class _VolunteerDeliveryDetailsState extends State<VolunteerDeliveryDetails> {
  final foodItemsFormKey = GlobalKey<FormState>();
  final cookingDateFormKey = GlobalKey<FormState>();
  final cookingTimeFormKey = GlobalKey<FormState>();
  final pickupTimeFormKey = GlobalKey<FormState>();
  final specialInstructionsFormKey = GlobalKey<FormState>();

  TextEditingController foodItemsController = TextEditingController();
  TextEditingController cookingDateController = TextEditingController();
  TextEditingController cookingTimeController = TextEditingController();
  TextEditingController pickupTimeController = TextEditingController();
  TextEditingController specialInstructionsController = TextEditingController();

  bool isLoading = false;
  List<Map<String, dynamic>> getDeliveryList = [];

  @override
  void initState() {
    super.initState();
    foodItemsController.addListener(() {
      setState(() {});
    });
    cookingDateController.addListener(() {
      setState(() {});
    });
    cookingTimeController.addListener(() {
      setState(() {});
    });
    pickupTimeController.addListener(() {
      setState(() {});
    });
    specialInstructionsController.addListener(() {
      setState(() {});
    });
    getDeliveryDetails();
  }

  getDeliveryDetails() async {
    setState(() {
      isLoading = true;
    });

    // getProfileDetails =
    //     UserProfileService(repository: repository).getUserProfileService();

    try {
      final data = await supabase
          .from('ashram_requests')
          .select('*')
          .eq('id', widget.volunteerData['id']);

      getDeliveryList = data;

      print("Delivery Details : $getDeliveryList");

      foodItemsController.text = data[0]['food_items'];
      cookingDateController.text = data[0]['cooking_date'];
      cookingTimeController.text = data[0]['cooking_time'];
      pickupTimeController.text = data[0]['pickup_time'];
      specialInstructionsController.text = data[0]['special_instructions'];
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

  @override
  void dispose() {
    foodItemsController.removeListener(() {});
    cookingDateController.removeListener(() {});
    cookingTimeController.removeListener(() {});
    pickupTimeController.removeListener(() {});
    specialInstructionsController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppBar(
              () {
                Navigator.pop(context);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) =>
                //     const DashboardScreen(),
                //   ),
                // );
              },
              showLogo: false,
              showChild: true,
              child: Text(
                "Delivery Details",
                style: TextStyle(
                  fontFamily: kFontMedium,
                  fontSize: backButton,
                  color: gBlackColor,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: isLoading
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 35.h),
                        child: buildThreeBounceIndicator(color: gBlackColor),
                      )
                    : getDeliveryList.isEmpty
                        ? const NoDataFound()
                        : mainView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  mainView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          Text(
            "Donation ID #${getDeliveryList[0]['id']}",
            style: TextStyle(
              fontFamily: kFontBold,
              fontSize: backButton,
              color: gBlackColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: FixedTimeline.tileBuilder(
              theme: TimelineTheme.of(context).copyWith(
                nodePosition: 0,
              ),
              builder: TimelineTileBuilder.connected(
                connectionDirection: ConnectionDirection.after,
                contentsAlign: ContentsAlign.basic,
                connectorBuilder: (context, index, type) {
                  return DashedLineConnector(
                    color: gBlackColor,
                    thickness: 1.5,
                    space: 7.w,
                    gap: 1.5.w,
                    dash: 1.w,
                    indent: 1.w,
                    endIndent: 1.w,
                  );
                },
                indicatorBuilder: (context, index) {
                  return DotIndicator(
                    color: gWhiteColor,
                    border: Border.all(color: gBlackColor, width: 1.5),
                  );
                },
                itemExtent: 12.h,
                itemCount: dummyData.length,
                contentsBuilder: (context, index) {
                  return Container(
                    height: 10.h,
                    margin:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
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
                            width: 30.w,
                            decoration: BoxDecoration(
                              color: imageBackGround,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ImageNetwork(
                              image: '',
                              height: 14.h,
                              width: 30.w,
                              // duration: 1500,
                              curve: Curves.easeIn,
                              // onPointer: true,
                              // debugPrint: false,
                              // fullScreen: false,
                              // fitAndroidIos: BoxFit.cover,
                              // fitWeb: BoxFitWeb.contain,
                              // borderRadius: BorderRadius.circular(12),
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
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dummyData[index].name,
                                      style: TextStyle(
                                        fontSize: listHeadingSize,
                                        fontFamily: listHeadingFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                    Text(
                                      dummyData[index].address,
                                      style: TextStyle(
                                        fontSize: listOtherSize,
                                        fontFamily: listOtherFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: gWhiteColor,
                                              border: Border.all(
                                                  color: gBlackColor, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.call,
                                              color: gBlackColor,
                                              size: 1.5.h,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        GestureDetector(
                                          onTap: () {
                                            // Navigator.of(context).push(
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         dummyData[index].isFrom == 1
                                            //             ? NavigationPickUp(
                                            //                 name:
                                            //                     dummyData[index]
                                            //                         .name,
                                            //               )
                                            //             : NavigationPickUp(
                                            //                 name:
                                            //                     dummyData[index]
                                            //                         .name,
                                            //                 isDelivery: true,
                                            //               ),
                                            //   ),
                                            // );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: gWhiteColor,
                                              border: Border.all(
                                                  color: gBlackColor, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.navigation,
                                              color: gBlackColor,
                                              size: 1.5.h,
                                            ),
                                          ),
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
                  );
                },
              ),
            ),
          ),
          buildTextFieldHeading("Food Items"),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: foodItemsFormKey,
            child: TextFormField(
              readOnly: true,
              textCapitalization: TextCapitalization.words,
              controller: foodItemsController,
              cursorColor: gGreyColor,
              validator: (value) {
                if (value!.isEmpty
                    // || !RegExp(r"^[a-z A-Z]").hasMatch(value)
                    ) {
                  return 'Please enter Food Items';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: "Enter your Food Items",
                hoverColor: gSecondaryColor,
                hintStyle: TextStyle(
                  fontFamily: textFieldHintFont,
                  color: textFieldHintColor.withOpacity(0.5),
                  fontSize: textFieldHintText,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: textFieldUnderLineColor.withOpacity(0.3),
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: textFieldUnderLineColor,
                  ),
                ),
              ),
              style: TextStyle(
                  fontFamily: textFieldFont,
                  fontSize: textFieldText,
                  color: textFieldColor),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.streetAddress,
              // inputFormatters: [
              //   FilteringTextInputFormatter.allow(
              //     RegExp(
              //       "[a-zA-Z ]",
              //     ),
              //   ),
              // ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildTextFieldHeading("Cooking Date"),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: cookingDateFormKey,
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                            fontFamily: textFieldFont,
                            fontSize: textFieldText,
                            color: textFieldColor),
                        validator: (value) {
                          if (value!.isEmpty
                              // || !RegExp(r"^[a-z A-Z]").hasMatch(value)
                              ) {
                            return 'Please enter Cooking Date';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Date',
                          hintStyle: TextStyle(
                            fontFamily: textFieldHintFont,
                            color: textFieldHintColor.withOpacity(0.5),
                            fontSize: textFieldHintText,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: textFieldUnderLineColor.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: textFieldUnderLineColor,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            // onTap: () async {
                            //   DateTime? pickedDate = await showDatePicker(
                            //       context: context,
                            //       initialDate: DateTime.now(),
                            //       firstDate: DateTime(1950),
                            //       lastDate: DateTime(2050));
                            //
                            //   if (pickedDate != null) {
                            //     cookingDateController.text =
                            //         DateFormat('dd MMM yyyy')
                            //             .format(pickedDate);
                            //   }
                            // },
                            child: Icon(
                              Icons.calendar_month_sharp,
                              size: 2.h,
                              color: textFieldUnderLineColor,
                            ),
                          ),
                        ),
                        controller: cookingDateController,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  children: [
                    buildTextFieldHeading("Cooking Time"),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: cookingTimeFormKey,
                      child: TextFormField(
                        readOnly: true,
                        textCapitalization: TextCapitalization.words,
                        controller: cookingTimeController,
                        cursorColor: gGreyColor,
                        validator: (value) {
                          if (value!.isEmpty
                              // || !RegExp(r"^[a-z A-Z]").hasMatch(value)
                              ) {
                            return 'Please enter Cooking Time';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "(ex: 12:00 PM)",
                          hoverColor: gSecondaryColor,
                          hintStyle: TextStyle(
                            fontFamily: textFieldHintFont,
                            color: textFieldHintColor.withOpacity(0.5),
                            fontSize: textFieldHintText,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: textFieldUnderLineColor.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: textFieldUnderLineColor,
                            ),
                          ),
                        ),
                        style: TextStyle(
                            fontFamily: textFieldFont,
                            fontSize: textFieldText,
                            color: textFieldColor),
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.streetAddress,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //     RegExp(
                        //       "[a-zA-Z ]",
                        //     ),
                        //   ),
                        // ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          buildImages(),
          buildTextFieldHeading("Pickup Time"),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: pickupTimeFormKey,
            child: TextFormField(
              readOnly: true,
              textCapitalization: TextCapitalization.words,
              controller: pickupTimeController,
              cursorColor: gGreyColor,
              validator: (value) {
                if (value!.isEmpty
                    // || !RegExp(r"^[a-z A-Z]").hasMatch(value)
                    ) {
                  return 'Please enter Pickup Time';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: "Enter Pickup Time(ex: Till 06:00 PM today)",
                hoverColor: gSecondaryColor,
                hintStyle: TextStyle(
                  fontFamily: textFieldHintFont,
                  color: textFieldHintColor.withOpacity(0.5),
                  fontSize: textFieldHintText,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: textFieldUnderLineColor.withOpacity(0.3),
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: textFieldUnderLineColor,
                  ),
                ),
              ),
              style: TextStyle(
                  fontFamily: textFieldFont,
                  fontSize: textFieldText,
                  color: textFieldColor),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.streetAddress,
              // inputFormatters: [
              //   FilteringTextInputFormatter.allow(
              //     RegExp(
              //       "[a-zA-Z ]",
              //     ),
              //   ),
              // ],
            ),
          ),
          buildTextFieldHeading("Special Instructions"),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: specialInstructionsFormKey,
            child: TextFormField(
              readOnly: true,
              textCapitalization: TextCapitalization.words,
              controller: specialInstructionsController,
              cursorColor: gGreyColor,
              validator: (value) {
                if (value!.isEmpty
                    // || !RegExp(r"^[a-z A-Z]").hasMatch(value)
                    ) {
                  return 'Please enter special instructions';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: "Enter Special Instructions",
                hoverColor: gSecondaryColor,
                hintStyle: TextStyle(
                  fontFamily: textFieldHintFont,
                  color: textFieldHintColor.withOpacity(0.5),
                  fontSize: textFieldHintText,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: textFieldUnderLineColor.withOpacity(0.3),
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: textFieldUnderLineColor,
                  ),
                ),
              ),
              style: TextStyle(
                  fontFamily: textFieldFont,
                  fontSize: textFieldText,
                  color: textFieldColor),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.streetAddress,
              // inputFormatters: [
              //   FilteringTextInputFormatter.allow(
              //     RegExp(
              //       "[a-zA-Z ]",
              //     ),
              //   ),
              // ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: ElevatedButton(
              onPressed: acceptLoading
                  ? null
                  : () {
                      submitVolunteerFood(
                        widget.volunteerData['id'],
                        foodItemsController.text.trim(),
                        cookingDateController.text.trim(),
                        cookingTimeController.text.trim(),
                        pickupTimeController.text.trim(),
                        specialInstructionsController.text.trim(),
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
                child: (acceptLoading)
                    ? buildThreeBounceIndicator(color: gBlackColor)
                    : Text(
                        "Accept",
                        style: TextStyle(
                          fontFamily: buttonFont,
                          fontSize: buttonFontSize,
                          color: buttonColor,
                        ),
                      ),
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              child: ElevatedButton(
                onPressed: () {
                  // deliveredWidget(context);
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
                    "Delivered",
                    style: TextStyle(
                      fontFamily: buttonFont,
                      fontSize: buttonFontSize,
                      color: buttonColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildAnswers(String title, String subtitle, {bool isSubtitle = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontFamily: textFieldFont,
                  fontSize: textFieldText,
                  color: textFieldColor),
            ),
            isSubtitle
                ? Text(
                    subtitle,
                    style: TextStyle(
                        fontFamily: textFieldFont,
                        fontSize: textFieldText,
                        color: textFieldColor),
                  )
                : const SizedBox(),
          ],
        ),
        const Divider(
          color: textFieldColor,
        ),
      ],
    );
  }

  buildImages() {
    return SizedBox(
      height: 8.h,
      child: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return Center(
            child: Container(
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
          );
        },
      ),
    );
  }

  bool acceptLoading = false;

  final _prefs = AppConfig().preferences;

  void submitVolunteerFood(
    int ashramId,
    String foodItems,
    String cookingDate,
    String cookingTime,
    String pickupTime,
    String specialInstructions,
  ) async {
    setState(() {
      acceptLoading = true;
    });

    print("ashramId : $ashramId");

    try {
      final res = await await supabase.from('ashram_requests').update({
        'status': 'accepted',
        'volunteer_id': "${_prefs?.getString(AppConfig.userId)}"
      }).eq('id', getDeliveryList[0]['id']);

      // final res = await supabase
      //     .from('ashram_requests')
      //     .select('*')
      //     .eq('id', getDeliveryList[0]['id']);

      print("submitVolunteer:$res");
      print("submitVolunteer.runtimeType: ${res.runtimeType}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(index: 0,),
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
