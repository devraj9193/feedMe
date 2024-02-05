import 'package:feed_me/utils/widgets/will_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';

import '../../dashboard_screen.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/widgets.dart';
import 'live_tracking.dart';

class DonorFoodScreen extends StatefulWidget {
  final dynamic donorData;
  const DonorFoodScreen({super.key, required this.donorData});

  @override
  State<DonorFoodScreen> createState() => _DonorFoodScreenState();
}

class _DonorFoodScreenState extends State<DonorFoodScreen> {
  TextEditingController dateInputController = TextEditingController();
  TextEditingController expectationDateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopWidget(child: Scaffold(body: SafeArea(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAppBar(
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                    const DashboardScreen(),
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

      ],),),),);
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
                      image: '',
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
                              widget.donorData['title'],
                              style: TextStyle(
                                fontSize: listHeadingSize,
                                fontFamily: listHeadingFont,
                                color: gBlackColor,
                              ),
                            ),
                            Text(
                              widget.donorData['subtitle'],
                              style: TextStyle(
                                fontSize: listSubHeadingSize,
                                fontFamily: listSubHeadingFont,
                                color: gBlackColor,
                              ),
                            ),
                            Text(
                              widget.donorData['address'],
                              style: TextStyle(
                                fontSize: listOtherSize,
                                fontFamily: listOtherFont,
                                color: gBlackColor,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 2.h,
                                  color: gBlackColor,
                                ),
                                Text(
                                  widget.donorData['distance'],
                                  style: TextStyle(
                                    fontSize: listOtherSize,
                                    fontFamily: listOtherFont,
                                    color: gBlackColor,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Icon(
                                  Icons.timer_sharp,
                                  size: 2.h,
                                  color: gBlackColor,
                                ),
                                Text(
                                  widget.donorData['cookingTime'],
                                  style: TextStyle(
                                    fontSize: listOtherSize,
                                    fontFamily: listOtherFont,
                                    color: gBlackColor,
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
          ),
          buildTextFieldHeading("Food Items"),
          SizedBox(height: 1.h),
          buildAnswers("Rice,Roti,Dal,Salad", "",),
          buildTextFieldHeading("Food Quantity"),
          SizedBox(height: 1.h),
          buildAnswers("Rice,Roti,Dal,Salad", "15kgs", isSubtitle: true),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildTextFieldHeading("Cooking Date"),
                    TextFormField(
                      style: TextStyle(
                          fontFamily: textFieldFont,
                          fontSize: textFieldText,
                          color: textFieldColor),
                      decoration: InputDecoration(
                        hintText: 'Date',
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldColor,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldColor,
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
                              dateInputController.text =
                                  DateFormat('dd MMM yyyy').format(pickedDate);
                            }
                          },
                          child: Icon(
                            Icons.calendar_month_sharp,
                            size: 2.h,
                            color: gBlackColor,
                          ),
                        ),
                      ),
                      controller: dateInputController,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  children: [
                    buildTextFieldHeading("Cooking Time"),
                    SizedBox(height: 2.7.h),
                    buildAnswers("12:00 PM", ""),
                  ],
                ),
              ),
            ],
          ),
          buildImages(),
          buildTextFieldHeading("Pickup Time"),
          SizedBox(height: 1.h),
          buildAnswers("Till 06:00 PM today", ""),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildTextFieldHeading("Expectation Date"),
                    TextFormField(
                      style: TextStyle(
                          fontFamily: textFieldFont,
                          fontSize: textFieldText,
                          color: textFieldColor),
                      decoration: InputDecoration(
                        hintText: 'Date',
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldColor,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldColor,
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
                                  DateFormat('dd MMM yyyy').format(pickedDate);
                            }
                          },
                          child: Icon(
                            Icons.calendar_month_sharp,
                            size: 2.h,
                            color: gBlackColor,
                          ),
                        ),
                      ),
                      controller: expectationDateController,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  children: [
                    buildTextFieldHeading("Expectation Time"),
                    SizedBox(height: 2.7.h),
                    buildAnswers("12:00 PM", ""),
                  ],
                ),
              ),
            ],
          ),
          buildTextFieldHeading("Special Instructions"),
          SizedBox(height: 1.h),
          buildAnswers("Food should be consumed within 24hrs.", ""),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                   Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                    loginButtonSelectedColor, //change background color of button
                    backgroundColor: gWhiteColor, //change text color of button
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                        const LiveTracking(),
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextFieldHeading("Add Photos[optional]"),
        Container(
          height: 8.h,
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3.w),
          margin: EdgeInsets.only(top: 1.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
          border: Border.all(color: gBlackColor),),
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
}


