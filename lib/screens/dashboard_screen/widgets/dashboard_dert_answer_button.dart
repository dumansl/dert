import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/derman_screen/derman_add_screen.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DashboardDertAnswerButton extends StatelessWidget {
  final DertModel dert;
  final UserModel user;
  const DashboardDertAnswerButton(
      {super.key, required this.dert, required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DermanAddScreen(dert: dert, user: user),
            ),
          );
        },
        child: _dertAnswerLogo());
  }

  Container _dertAnswerLogo() {
    return Container(
      height: IconSize.size20px,
      width: IconSize.size20px,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.checkLogo),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
