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
    return CircleAvatar(
      backgroundImage: profileImageUrl != null
          ? NetworkImage(profileImageUrl!)
          : gender == "Kadın"
              ? const AssetImage(ImagePath.userFemaleLogo) as ImageProvider
              : const AssetImage(ImagePath.userMaleLogo) as ImageProvider,
      backgroundColor: Colors.white,
      radius: radius,
    );
  }
}
