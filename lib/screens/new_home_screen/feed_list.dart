import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';

import '../../utils/constants.dart';

class FeedList extends StatefulWidget {
  final bool isButton;
  final List<Map<String, dynamic>> feedList;
  const FeedList({super.key, this.isButton = false, required this.feedList});

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  List<TestimonialDummy> list = [
    TestimonialDummy(
      'Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_c-mB3wULLhpdFqSL2w8-2v5I1Nu-bbLoUg&s",
      "Lorem ipsum",
      "2h ago",
      "assets/images/Connect Care_logo.png",
      "Software Developer",
    ),
    TestimonialDummy(
      'Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTVGqkBZBQZ6P8dAc9BKMPxpfvcWqNodCpBg&s',
      "Lorem ipsum",
      "6h ago",
      "assets/images/Connect Care_logo.png",
      "Doctor",
    ),
    TestimonialDummy(
      'Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      "https://i0.wp.com/picjumbo.com/wp-content/uploads/beautiful-nature-mountain-scenery-with-flowers-free-photo.jpg?w=600&quality=80",
      "Lorem ipsum",
      "9h ago",
      "assets/images/Connect Care_logo.png",
      "Developer",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.feedList.length,
          itemBuilder: ((context, index) {
            var feed = widget.feedList[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: gWhiteColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 2.h,
                        backgroundImage: AssetImage(list[index].profileImage),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  feed['user_name'] ?? '',
                                  style: TextStyle(
                                      fontFamily: kFontMedium,
                                      color: gBlackColor,
                                      fontSize: 13.dp),
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  feed['created_at'] ?? '',
                                  style: TextStyle(
                                      fontFamily: kFontMedium,
                                      color: gGreyColor,
                                      fontSize: 10.dp),
                                ),
                              ],
                            ),
                            // SizedBox(height: 0.h),
                            // Text(
                            //   list[index].destination,
                            //   style: TextStyle(
                            //       fontFamily: kFontMedium,
                            //       color: gTextColor,
                            //       fontSize: 11.dp),
                            // ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.isButton,
                        child: filterPopUp(),
                      )
                    ],
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    textScaleFactor: 0.85,
                    maxLines: 4,
                    text: TextSpan(children: [
                      TextSpan(
                        text:
                            "${list[index].description.substring(0, int.parse("${(list[index].description.length * 0.498).toInt()}"))}...",
                        style: TextStyle(
                            height: 1.3,
                            fontFamily: kFontBook,
                            color: eUser().mainHeadingColor,
                            fontSize: 12.dp),
                      ),
                      WidgetSpan(
                        child: InkWell(
                            mouseCursor: SystemMouseCursors.click,
                            onTap: () {},
                            child: Text(
                              "more",
                              style: TextStyle(
                                  height: 1.3,
                                  fontFamily: kFontBook,
                                  color: appPrimaryColor,
                                  fontSize: 12.dp),
                            )),
                      )
                    ]),
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ImageNetwork(
                        image: feed['file_name'],
                        height: 20.h,
                        width: double.maxFinite,
                        // duration: 1500,
                        curve: Curves.easeIn,
                        onPointer: true,
                        debugPrint: false,
                        fullScreen: false,
                        fitAndroidIos: BoxFit.fill,
                        fitWeb: BoxFitWeb.contain,
                        borderRadius: BorderRadius.circular(10),
                        onError: const Image(
                          image:
                              AssetImage("assets/images/Connect Care_logo.png"),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                  Text(
                    feed['description'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.dp,
                        fontFamily: kFontMedium,
                        color: gTextColor),
                  ),
                  SizedBox(height: 0.5.h),
                  // SizedBox(height: 1.h),],
                ],
              ),
            );
          }),
        ),
        widget.isButton
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Activity",
                        style: TextStyle(
                          fontSize: 14.dp,
                          fontFamily: kFontMedium,
                          color: gTextColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Donation",
                        style: TextStyle(
                          fontSize: 14.dp,
                          fontFamily: kFontMedium,
                          color: gTextColor,
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  filterPopUp() {
    return PopupMenuButton(
      onSelected: null,
      offset: const Offset(0, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: gWhiteColor,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delete",
                  style: TextStyle(
                      fontFamily: kFontMedium,
                      color: gBlackColor,
                      fontSize: 12.dp),
                ),
              ],
            ),
          ),
        ),
      ],
      child: Icon(
        Icons.more_vert,
        color: gBlackColor,
        size: 2.5.h,
      ),
    );
  }
}

class TestimonialDummy {
  String description;
  String image;
  String name;
  String time;
  String profileImage;
  String destination;
  TestimonialDummy(
    this.description,
    this.image,
    this.name,
    this.time,
    this.profileImage,
    this.destination,
  );
}
