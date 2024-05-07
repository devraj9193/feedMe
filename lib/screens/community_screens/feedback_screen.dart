import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../dashboard_screen.dart';
import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';

class FeedbackScreen extends StatefulWidget {
  final bool isDelivery;
  final Map<String, dynamic> file;
  const FeedbackScreen(
      {super.key, this.isDelivery = false, required this.file});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController commentController = TextEditingController();

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
                isBackEnable: true,
                showLogo: false,
                showChild: true,
                child: Text(
                  "Feedback",
                  style: TextStyle(
                    fontFamily: kFontBold,
                    fontSize: 15.dp,
                    color: gBlackColor,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRating(),
                      SizedBox(height: 4.h),
                      Text(
                        "Comments :",
                        style: TextStyle(
                          fontFamily: kFontMedium,
                          fontSize: 13.dp,
                          color: gBlackColor,
                        ),
                      ),
                      Container(
                        height: 12.h,
                        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(2, 10),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: commentController,
                          cursorColor: gPrimaryColor,
                          style: TextStyle(
                              fontFamily: kFontBook,
                              color: gTextColor,
                              fontSize: 13.dp),
                          decoration: InputDecoration(
                            suffixIcon: commentController.text.isEmpty
                                ? const SizedBox()
                                : InkWell(
                              onTap: () {
                                commentController.clear();
                              },
                              child: const Icon(
                                Icons.close,
                                color: gTextColor,
                              ),
                            ),
                            hintText: "Comments",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontFamily: "GothamBook",
                              color: gTextColor,
                              fontSize: 11.dp,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                        child: ElevatedButton(
                          onPressed: acceptLoading
                              ? null
                              : () {
                            if (rating == 0.0) {
                              AppConfig().showSnackbar(
                                  context, "Please select the rating",isError: true);
                            } else if (commentController.text.isEmpty) {
                              AppConfig().showSnackbar(
                                  context, 'Please enter comments',
                                  isError: true);
                            } else {
                              submitUpload(
                                commentController.text.trim(),
                                rating.toString(),
                              );
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
                            child: (acceptLoading)
                                ? buildThreeBounceIndicator(color: gBlackColor)
                                : Text(
                              "Submit",
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
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }

  double rating = 0.0;
  Widget buildRating() {
    return SmoothStarRating(
      color: appPrimaryColor,
      borderColor: appPrimaryColor,
      rating: rating,
      size: 50,
      filledIconData: Icons.star_sharp,
      halfFilledIconData: Icons.star_half_sharp,
      defaultIconData: Icons.star_outline_sharp,
      starCount: 5,
      allowHalfRating: false,
      spacing: 1.0,
      onRatingChanged: (value) {
        print(value);
        setState(() {
          rating = value;
        });
      },
    );
  }

  bool acceptLoading = false;

  final _prefs = AppConfig().preferences;

  void submitUpload(
    String comments,
    String rating,
  ) async {
    setState(() {
      acceptLoading = true;
    });
    try {
      print("Order ID : ${widget.file}");

      Map m = {
        'user_id': "${_prefs?.getString(AppConfig.userId)}",
        'order_id': widget.file['id'],
        'comments': comments,
        'star_rating': rating,
      };

      print("body para : $m");

      final res = await supabase.from('feedbacks').insert(m);

      print("submitUpload:$res");
      print("submitUpload.runtimeType: ${res.toString()}");
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
          acceptLoading = false;
        });
      }
    }
  }
}
