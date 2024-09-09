import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DashboardCircleAvatar extends StatelessWidget {
  final String? profileImageUrl;
  final String gender;
  final double radius;
  const DashboardCircleAvatar({
    super.key,
    required this.profileImageUrl,
    required this.gender,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: DertColor.frame.darkpurple,
          width: 4,
        ),
      ),
      child: CircleAvatar(
        backgroundImage: profileImageUrl != null
            ? NetworkImage(profileImageUrl!)
            : gender == "Kadın"
                ? const AssetImage(ImagePath.userFemaleLogo) as ImageProvider
                : gender == "Other"
                    ? const AssetImage(ImagePath.userOtherLogo) as ImageProvider
                    : const AssetImage(ImagePath.userMaleLogo) as ImageProvider,
        backgroundColor: Colors.white,
        radius: radius,
      ),
    );
  }
}
