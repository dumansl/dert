import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DashboardPointsCard extends StatelessWidget {
  final int? points;
  const DashboardPointsCard({
    super.key,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenPadding.padding8px,
        vertical: ScreenPadding.padding4px,
      ),
      decoration: BoxDecoration(
        color: DertColor.button.darkpurple,
        borderRadius: BorderRadius.all(
          Radius.circular(SizeRadius.radius8px),
        ),
      ),
      child: Row(
        children: [
          Text(
            "$points",
            style: DertTextStyle.roboto.t12w500white,
          ),
          SizedBox(width: ScreenPadding.padding8px),
          InkWell(onTap: () {}, child: _dertLogo()),
        ],
      ),
    );
  }

  Container _dertLogo() {
    return Container(
      height: IconSize.size20px,
      width: IconSize.size20px,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipOval(
        child: Image.asset(
          ImagePath.dertLogov2,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
