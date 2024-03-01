import 'package:feed_me/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../utils/widgets/widgets.dart';
import 'login_Screen.dart';
import 'new_user/register_selection.dart';

class FeedMeScreen extends StatefulWidget {
  const FeedMeScreen({super.key});

  @override
  State<FeedMeScreen> createState() => _FeedMeScreenState();
}

class _FeedMeScreenState extends State<FeedMeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Text(
                "FeedMe",
                style: TextStyle(
                  fontFamily: kFontBold,
                  fontSize: loginHeading,
                  color: gBlackColor,
                ),
              ),
            ),
            buildLoginButtons('Login', () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                  // SitBackScreen(),
                  const LoginScreen(),
                ),
              );
            }),
            SizedBox(height: 2.h),
            buildLoginButtons('Register', () async {

              // final data = await supabase
              //     .from('users')
              //     .select('*')
              //     .eq('email', 'amith@gmail.com');

              // final data = await supabase
              //     .from('users')
              //     .select('f_name, l_name')
              //     .eq('email', 'amith@gmail.com');
              // final data = await supabase.from('users').select('*').eq('email', 'amith@gmail.com');

              // print("data : ${data}");

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                  // SitBackScreen(),
                  const RegisterScreen(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
