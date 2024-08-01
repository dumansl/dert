import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.mobileBuilder,
    required this.tabletBuilder,
    required this.desktopBuilder,
    super.key,
  });

  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
  ) mobileBuilder;

  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
  ) tabletBuilder;

  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
  ) desktopBuilder;

  static bool isMobile(BuildContext context) =>
      ScreenUtil.getWidth(context) < 650;

  static bool isTablet(BuildContext context) =>
      ScreenUtil.getWidth(context) < 1248 &&
      ScreenUtil.getWidth(context) >= 650;

  static bool isDesktop(BuildContext context) =>
      ScreenUtil.getWidth(context) >= 1248;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1500) {
          return desktopBuilder(context, constraints);
        } else if (constraints.maxWidth >= 650) {
          return tabletBuilder(context, constraints);
        } else {
          return mobileBuilder(context, constraints);
        }
      },
    );
  }
}
