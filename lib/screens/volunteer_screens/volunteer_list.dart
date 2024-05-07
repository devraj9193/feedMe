import 'package:feed_me/screens/volunteer_screens/volunteer_delivery_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';

import '../../utils/constants.dart';

class VolunteerList extends StatefulWidget {
  const VolunteerList({Key? key, }) : super(key: key);

  @override
  State<VolunteerList> createState() => _VolunteerListState();
}

class _VolunteerListState extends State<VolunteerList> {
  List dummyData = [
    {
      "title": "The Big Brunch",
      "subtitle": "Meal for 25 people",
      "address": "Drop of Arun school, Avenue Colony.404 Flat No.",
      "distance": "4 Kms",
      "cookingTime": "Cooked 2hrs Ago",
    },
    {
      "title": "Concept Restaurants",
      "subtitle": "Meal for 40 people",
      "address": "Drop of Arun school, Avenue Colony.404 Flat No.",
      "distance": "6 Kms",
      "cookingTime": "Cooked 3hrs Ago",
    },
    {
      "title": "Chawla Restaurants",
      "subtitle": "Meal for 10 people",
      "address": "Drop of Arun school, Avenue Colony.404 Flat No.",
      "distance": "10 Kms",
      "cookingTime": "Cooked 4hrs Ago",
    },
    {
      "title": "Pind Baluchi",
      "subtitle": "Meal for 35 people",
      "address": "Drop of Arun school, Avenue Colony.404 Flat No.",
      "distance": "11 Kms",
      "cookingTime": "Cooked 15hrs Ago",
    },
    {
      "title": "The Big Brunch",
      "subtitle": "Meal for 50 people",
      "address": "Drop of Arun school, Avenue Colony.404 Flat No.",
      "distance": "4 Kms",
      "cookingTime": "Cooked 16hrs Ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: ListView.builder(
        itemCount: dummyData.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          final file = dummyData[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const VolunteerDeliveryDetails(
                    volunteerData: null, ashramFoodRequestList: null,
                  ),
                ),
              );
            },
            child: Container(
              height: 14.h,
              margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
                                file['title'],
                                style: TextStyle(
                                  fontSize: listHeadingSize,
                                  fontFamily: listHeadingFont,
                                  color: gBlackColor,
                                ),
                              ),
                              Text(
                                file['subtitle'],
                                style: TextStyle(
                                  fontSize: listSubHeadingSize,
                                  fontFamily: listSubHeadingFont,
                                  color: gBlackColor,
                                ),
                              ),
                              Text(
                                file['address'],
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
                                    file['distance'],
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
                                    file['cookingTime'],
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
          );
        },
      ),
    );
  }
}
