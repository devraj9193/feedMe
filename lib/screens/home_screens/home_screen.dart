import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';

import '../../utils/constants.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';
import '../donor_screens/donor_list.dart';
import '../volunteer_screens/volunteer_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() async {
    super.dispose();
    tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildAppBar(
                    () {},
                    isBackEnable: false,
                    showLogo: false,
                    showChild: true,
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: gBlackColor,
                          size: 3.5.h,
                        ),
                        SizedBox(width: 1.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Ankit",
                              style: TextStyle(
                                fontFamily: kFontBold,
                                fontSize: backButton,
                                color: gBlackColor,
                              ),
                            ),
                            Text(
                              "The Big Brunch,Bengaluru..",
                              style: TextStyle(
                                fontFamily: kFontBook,
                                fontSize: otpSubHeading,
                                color: gBlackColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 3.w),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: gGreyColor.withOpacity(0.5),
                        ),
                      ),
                      child: ImageNetwork(
                        image: '',
                        height: 35,
                        width: 35,
                        // duration: 1500,
                        curve: Curves.easeIn,
                        onPointer: true,
                        debugPrint: false,
                        fullScreen: false,
                        fitAndroidIos: BoxFit.cover,
                        fitWeb: BoxFitWeb.contain,
                        borderRadius: BorderRadius.circular(70),
                        onError: Icon(
                          Icons.person,
                          color: gGreyColor.withOpacity(0.5),
                        ),
                        onTap: () {
                          debugPrint("©gabriel_patrick_souza");
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: loginButtonSelectedColor,
                ),
                child: TextFormField(
                  cursorColor: gGreyColor,
                  controller: searchController,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: textFieldHintColor.withOpacity(0.5),
                      size: 2.5.h,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          searchController.clear();
                        });
                      },
                      child: Icon(
                        Icons.cancel_outlined,
                        color: textFieldHintColor.withOpacity(0.5),
                        size: 2.5.h,
                      ),
                    ),
                    hintText: "Search for NGO or Hunger spots",
                    hintStyle: TextStyle(
                      fontFamily: textFieldHintFont,
                      color: textFieldHintColor.withOpacity(0.5),
                      fontSize: textFieldHintText,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                      fontFamily: textFieldFont,
                      fontSize: textFieldText,
                      color: textFieldColor),
                  onChanged: (value) {},
                ),
              ),
              TabBar(
                controller: tabController,
                labelColor: gBlackColor,
                unselectedLabelColor: gGreyColor.withOpacity(0.5),
                indicatorColor: gBlackColor,
                labelStyle: TextStyle(
                  fontFamily: kFontBold,
                  color: gPrimaryColor,
                  fontSize: tapSelectedSize,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: tapFont,
                  color: gHintTextColor,
                  fontSize: tapUnSelectedSize,
                ),
                labelPadding: EdgeInsets.only(
                    right: 0.w, left: 0.w, top: 1.h, bottom: 1.h),
                tabs: const [
                  Text('DONOR'),
                  Text('VOLUNTEER'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  // physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    DonorList(),
                    VolunteerList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
