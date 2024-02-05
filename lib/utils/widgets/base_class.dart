import 'package:feed_me/utils/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class BaseClass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool isBackEnable;
  final bool isFilter;
  final Widget? filterWidget;
  const BaseClass({
    Key? key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.isBackEnable = true,
    this.isFilter = false,
    this.filterWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
       backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: buildAppBar(
              () {
                Navigator.pop(context);
              },
              isBackEnable: isBackEnable,
              isFilter: isFilter,
              filterWidget: filterWidget,
            ),
          ),
          Expanded(
            child: Padding(
              padding: padding,
              child: child,
            ),
          )
        ],
      ),
    ));
  }
}
