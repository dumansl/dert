import 'package:dert/screens/derman_screen/widgets/derman_circle_avatar.dart';
import 'package:dert/services/dert_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/services/user_service.dart';
import 'package:dert/model/dert_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_points_card.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_dert_card.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_bips_button.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_dert_answer_button.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_answers_button.dart';
import 'package:dert/utils/constant/constants.dart';

class MainScreen extends StatelessWidget {
  final UserModel user;

  const MainScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final dertService = Provider.of<DertService>(context);
    final userService = Provider.of<UserService>(context);

    return Padding(
      padding: EdgeInsets.all(ScreenPadding.padding8px),
      child: StreamBuilder<List<DertModel>>(
        stream: dertService.getFollowedDerts(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _mainEmpty(context);
          }
          final derts = snapshot.data!;

          return ListView.builder(
            itemCount: derts.length,
            itemBuilder: (context, index) {
              final dert = derts[index];

              return StreamBuilder<UserModel?>(
                stream: userService.streamUserById(dert.userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final dertUser = userSnapshot.data;

                  if (dertUser == null) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenPadding.padding4px),
                    child: DashboardDertCard(
                      topWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              DermanCircleAvatar(
                                profileImageUrl: dertUser.profileImageUrl,
                                gender: dertUser.gender,
                                radius: 15,
                              ),
                              SizedBox(width: ScreenPadding.padding8px),
                              Text(
                                "@${dertUser.username}",
                                style: DertTextStyle.roboto.t14w700white,
                              ),
                            ],
                          ),
                          DashboardPointsCard(points: dertUser.points),
                        ],
                      ),
                      width: ScreenUtil.getWidth(context) * 0.76,
                      dert: dert,
                      user: user,
                      bottomWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DashboardBipsButton(bips: dert.bips),
                          Row(
                            children: [
                              DashboardDertAnswerButton(
                                dert: dert,
                                user: user,
                              ),
                              SizedBox(width: ScreenPadding.padding16px),
                              FutureBuilder<List<DermanModel>>(
                                future:
                                    dertService.getDermansForDert(dert.dertId!),
                                builder: (context, dermanSnapshot) {
                                  if (dermanSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (dermanSnapshot.hasError) {
                                    return Center(
                                        child: Text(
                                            'Error: ${dermanSnapshot.error}'));
                                  } else {
                                    final dermans = dermanSnapshot.data ?? [];
                                    return DashboardAnswersButton(
                                      dermansLength: dermans.length,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

Widget _mainEmpty(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: ScreenUtil.getHeight(context) * 0.4,
        width: ScreenUtil.getHeight(context) * 0.4,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.onboardImage),
          ),
        ),
      ),
      SizedBox(height: ScreenPadding.padding16px),
      Text(
        DertText.mainEmptyText,
        textAlign: TextAlign.center,
        style: DertTextStyle.roboto.t16w700darkpurple,
      ),
    ],
  );
}
