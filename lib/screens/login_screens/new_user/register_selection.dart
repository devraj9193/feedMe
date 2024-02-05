import 'package:feed_me/screens/login_screens/new_user/volunteer_registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../utils/constants.dart';
import '../../../utils/widgets/widgets.dart';
import '../../../utils/widgets/will_pop_widget.dart';
import 'donor_registration.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildAppBar(() {
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
                    )),
                SizedBox(height: 20.h),
                buildLoginButtons('Donor', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                      // SitBackScreen(),
                      const DonorRegistration(),
                    ),
                  );
                }),
                SizedBox(height: 2.h),
                buildLoginButtons('Volunteer', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                      // SitBackScreen(),
                      VolunteerRegistration(),
                    ),
                  );
                }),
                SizedBox(height: 2.h),
                buildLoginButtons('NGO', () {}),
                SizedBox(height: 20.h),
                Center(
                  child: Image(
                    width: 40.w,
                    image: const AssetImage("assets/images/Connect Care_logo.png"),
                  ),
                  // SvgPicture.asset(
                  //     "assets/images/splash_screen/Splash screen Logo.svg"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
