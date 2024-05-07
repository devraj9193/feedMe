import 'package:feed_me/utils/widgets/will_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../dashboard_screen.dart';
import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/widgets.dart';
import 'live_tracking.dart';

class DonorFoodScreen extends StatefulWidget {
  final dynamic donorData;
  const DonorFoodScreen({Key? key,  required this.donorData}) : super(key: key);

  @override
  State<DonorFoodScreen> createState() => _DonorFoodScreenState();
}

class _DonorFoodScreenState extends State<DonorFoodScreen> {
  final foodItemsFormKey = GlobalKey<FormState>();
  final foodQuantityFormKey = GlobalKey<FormState>();
  final cookingDateFormKey = GlobalKey<FormState>();
  final cookingTimeFormKey = GlobalKey<FormState>();
  final pickupTimeFormKey = GlobalKey<FormState>();
  final expectationDateFormKey = GlobalKey<FormState>();
  final expectationTimeFormKey = GlobalKey<FormState>();
  final specialInstructionsFormKey = GlobalKey<FormState>();

  TextEditingController foodItemsController = TextEditingController();
  TextEditingController cookingDateController = TextEditingController();
  TextEditingController foodQuantityController = TextEditingController();
  TextEditingController cookingTimeController = TextEditingController();
  TextEditingController pickupTimeController = TextEditingController();
  TextEditingController expectationDateController = TextEditingController();
  TextEditingController expectationTimeController = TextEditingController();
  TextEditingController specialInstructionsController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    foodItemsController.addListener(() {
      setState(() {});
    });
    foodQuantityController.addListener(() {
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
    expectationDateController.addListener(() {
      setState(() {});
    });
    expectationTimeController.addListener(() {
      setState(() {});
    });
    specialInstructionsController.addListener(() {
      setState(() {});
    });
  }

  // @override
  // void dispose() {
  //   foodItemsController.removeListener(() {});
  //   foodQuantityController.removeListener(() {});
  //   cookingDateController.removeListener(() {});
  //   cookingTimeController.removeListener(() {});
  //   pickupTimeController.removeListener(() {});
  //   expectationDateController.removeListener(() {});
  //   expectationTimeController.removeListener(() {});
  //   specialInstructionsController.removeListener(() {});
  //   super.dispose();
  // }

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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(index: 1,),
                    ),
                  );
                },
                showLogo: false,
                showChild: true,
                child: Text(
                  "Donate Food",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    fontSize: backButton,
                    color: gBlackColor,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: mainView(),
                ),
              ),
            ],
          ),
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
          Container(
            height: 14.h,
            margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
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
                      image: widget.donorData['image_url'] ?? '',
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
                      onLoading: const SizedBox(),
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.donorData['ashram_name'],
                              style: TextStyle(
                                fontSize: listHeadingSize,
                                fontFamily: listHeadingFont,
                                color: gBlackColor,
                              ),
                            ),
                            // Text(
                            //   "Meal for ${widget.donorData['meal_request']} people",
                            //   style: TextStyle(
                            //     fontSize: listSubHeadingSize,
                            //     height: 1.3,
                            //     fontFamily: listSubHeadingFont,
                            //     color: gBlackColor,
                            //   ),
                            // ),
                            SizedBox(height: 1.5.h),
                            Text(
                              widget.donorData['address'],
                              style: TextStyle(
                                fontSize: listOtherSize,
                                height: 1.3,
                                fontFamily: listOtherFont,
                                color: gBlackColor,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Row(
                            //       children: [
                            //         Icon(
                            //           Icons.location_on_outlined,
                            //           size: 2.h,
                            //           color: gBlackColor,
                            //         ),
                            //         Text(
                            //           "4 Kms",
                            //           style: TextStyle(
                            //             fontSize: listOtherSize,
                            //             fontFamily: listOtherFont,
                            //             color: gBlackColor,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     Row(
                            //       children: [
                            //         Icon(
                            //           Icons.timer_sharp,
                            //           size: 2.h,
                            //           color: gBlackColor,
                            //         ),
                            //         Text(
                            //           "Posted at ${DateFormat.jm().format(DateTime.parse(widget.donorData['created_at']))}",
                            //           style: TextStyle(
                            //             fontSize: listOtherSize,
                            //             fontFamily: listOtherFont,
                            //             color: gBlackColor,
                            //           ),
                            //         ),
                            //         SizedBox(width: 3.w),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildTextFieldHeading("Food Items"),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: foodItemsFormKey,
            child: TextFormField(
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
          buildTextFieldHeading("Food Quantity"),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: foodQuantityFormKey,
            child: TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: foodQuantityController,
              // inputFormatters: [
              //   FilteringTextInputFormatter.digitsOnly,
              //   FoodQuantityFormatter(),
              //   LengthLimitingTextInputFormatter(14),
              // ],
              cursorColor: gGreyColor,
              validator: (value) {
                if (value!.isEmpty
                    // || !RegExp(r"^[a-z A-Z]").hasMatch(value)
                    ) {
                  return 'Please enter Food Quantity';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: "Enter your Food Quantity(ex: 15kgs 500g)",
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
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2050));

                              if (pickedDate != null) {
                                cookingDateController.text =
                                    DateFormat('dd MMM yyyy')
                                        .format(pickedDate);
                              }
                            },
                            child: Icon(
                              Icons.calendar_month_sharp,
                              size: 2.h,
                              color: textFieldUnderLineColor,
                            ),
                          ),
                        ),
                        controller: cookingDateController,
                        readOnly: true,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildTextFieldHeading("Expectation Date"),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: expectationDateFormKey,
                      child: TextFormField(
                        style: TextStyle(
                            fontFamily: textFieldFont,
                            fontSize: textFieldText,
                            color: textFieldColor),
                        validator: (value) {
                          if (value!.isEmpty
                              // || !RegExp(r"^[a-z A-Z]").hasMatch(value)
                              ) {
                            return 'Please enter Expectation Date';
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
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2050));

                              if (pickedDate != null) {
                                expectationDateController.text =
                                    DateFormat('dd MMM yyyy')
                                        .format(pickedDate);
                              }
                            },
                            child: Icon(
                              Icons.calendar_month_sharp,
                              size: 2.h,
                              color: textFieldUnderLineColor,
                            ),
                          ),
                        ),
                        controller: expectationDateController,
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  children: [
                    buildTextFieldHeading("Expectation Time"),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: expectationTimeFormKey,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: expectationTimeController,
                        cursorColor: gGreyColor,
                        validator: (value) {
                          if (value!.isEmpty
                              // || !RegExp(r"^[a-z A-Z]").hasMatch(value)
                              ) {
                            return 'Please enter Expectation Time';
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
          buildTextFieldHeading("Special Instructions"),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: specialInstructionsFormKey,
            child: TextFormField(
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
            child: (isLoading)
                ? Center(
                    child: buildThreeBounceIndicator(color: gBlackColor),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const DashboardScreen(index: 0,),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              loginButtonSelectedColor, //change background color of button
                          backgroundColor:
                              gWhiteColor, //change text color of button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0.0,
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: buttonFont,
                              fontSize: buttonFontSize,
                              color: buttonColor,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (foodItemsFormKey.currentState!.validate() &&
                                    foodQuantityFormKey.currentState!
                                        .validate() &&
                                    cookingDateFormKey.currentState!
                                        .validate() &&
                                    cookingTimeFormKey.currentState!
                                        .validate() &&
                                    pickupTimeFormKey.currentState!
                                        .validate() &&
                                    expectationDateFormKey.currentState!
                                        .validate() &&
                                    expectationTimeFormKey.currentState!
                                        .validate() &&
                                    specialInstructionsFormKey.currentState!
                                        .validate()) {
                                  if (foodItemsController.text.isNotEmpty &&
                                      foodQuantityController.text.isNotEmpty &&
                                      cookingDateController.text.isNotEmpty &&
                                      cookingTimeController.text.isNotEmpty &&
                                      pickupTimeController.text.isNotEmpty &&
                                      expectationDateController
                                          .text.isNotEmpty &&
                                      expectationTimeController
                                          .text.isNotEmpty &&
                                      specialInstructionsController
                                          .text.isNotEmpty) {
                                    submitDonateFood(
                                      widget.donorData['id'],
                                      foodItemsController.text.trim(),
                                      foodQuantityController.text.trim(),
                                      cookingDateController.text.trim(),
                                      cookingTimeController.text.trim(),
                                      pickupTimeController.text.trim(),
                                      expectationDateController.text.trim(),
                                      expectationTimeController.text.trim(),
                                      specialInstructionsController.text.trim(),
                                    );
                                  }
                                }
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
                            "Done",
                            style: TextStyle(
                              fontFamily: buttonFont,
                              fontSize: buttonFontSize,
                              color: buttonColor,
                            ),
                          ),
                        ),
                      ),
                    ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextFieldHeading("Add Photos[optional]"),
        Container(
          height: 8.h,
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
          margin: EdgeInsets.only(top: 1.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: gBlackColor),
          ),
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
                    onLoading: const SizedBox(),
                    onTap: () {
                      debugPrint("©gabriel_patrick_souza");
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  final _prefs = AppConfig().preferences;

  void submitDonateFood(
    int ashramId,
    String foodItems,
    String foodQuantity,
    String cookingDate,
    String cookingTime,
    String pickupTime,
    String expectationDate,
    String expectationTime,
    String specialInstructions,
  ) async {
    setState(() {
      isLoading = true;
    });

    print("ashramId : $ashramId");
    print("donor_id : ${_prefs?.getString(AppConfig.userId)}");

    Map data = { "ashram_id": ashramId,
      "food_items": foodItems,
      "donor_id": _prefs?.getString(AppConfig.userId),
      "food_quantity": foodQuantity,
      "cooking_date": cookingDate,
      "cooking_time": cookingTime,
      "pickup_time": pickupTime,
      "expectation_date": expectationDate,
      "expectation_time": expectationTime,
      "special_instructions": specialInstructions,
    };

    print("DATA : $data");

    try {
      final res = await supabase.from('ashram_requests').insert({
        "ashram_id": ashramId,
        "donor_id": _prefs?.getString(AppConfig.userId),
        "food_items": foodItems,
        "food_quantity": foodQuantity,
        "cooking_date": cookingDate,
        "cooking_time": cookingTime,
        "pickup_time": pickupTime,
        "expectation_date": expectationDate,
        "expectation_time": expectationTime,
        "special_instructions": specialInstructions,
      });

      print("submitDonateFood:$res");
      print("submitDonateFood.runtimeType: ${res.runtimeType}");
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
