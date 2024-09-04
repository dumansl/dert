import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DashboardBipsButton extends StatelessWidget {
  final int bips;
  const DashboardBipsButton({super.key, required this.bips});

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
          InkWell(onTap: () {}, child: _bipLogo()),
          SizedBox(
            width: ScreenPadding.padding8px,
          ),
          Text(
            "$bips",
            style: DertTextStyle.roboto.t12w500white,
          ),
        ],
      ),
    );
  }

  Container _bipLogo() {
    return Container(
      height: IconSize.size20px,
      width: IconSize.size20px,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.bipLogo),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
