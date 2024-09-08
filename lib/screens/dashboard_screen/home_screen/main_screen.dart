import 'package:dert/model/dert_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_answers_button.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_bips_button.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_dert_card.dart';
import 'package:dert/services/dert_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  final String userId;

  const MainScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final dertService = Provider.of<DertService>(context);
    return Padding(
      padding: EdgeInsets.all(ScreenPadding.padding8px),
      child: StreamBuilder<List<DertModel>>(
        stream: dertService.getFollowedDerts(userId),
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
              return Padding(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenPadding.padding4px),
                child: DashboardDertCard(
                  width: ScreenUtil.getWidth(context) * 0.76,
                  dert: dert,
                  bottomWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DashboardBipsButton(bips: dert.bips),
                      DashboardAnswersButton(
                          dermansLength: dert.dermans.length),
                    ],
                  ),
                ),
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
