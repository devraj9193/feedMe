import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../utils/constants.dart';
import '../../utils/widgets/widgets.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
              },
              showLogo: false,
              showChild: true,
              child: Text(
                "Back",
                style: TextStyle(
                  fontFamily: kFontMedium,
                  fontSize: backButton,
                  color: gBlackColor,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            buildTerms(),
          ],
        ),
      ),
    );
  }

  buildTerms() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Privacy Policy",
            style: TextStyle(
              fontFamily: kFontBold,
              fontSize: loginHeading,
              color: gBlackColor,
            ),
          ),
        ],
      ),
    );
  }
}
