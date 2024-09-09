import 'package:dert/model/dert_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/dert_screen/widgets/dert_answers_button.dart';
import 'package:dert/screens/dert_screen/widgets/dert_bips_button.dart';
import 'package:dert/screens/dert_screen/widgets/dert_details_derman_card.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DertDetailsScreen extends StatelessWidget {
  final DertModel dert;
  const DertDetailsScreen({super.key, required this.dert});

  @override
  Widget build(BuildContext context) {
    debugPrint(ScreenUtil.getHeight(context).toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DertAppbar(
        title: DertText.dert,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            expandedHeight: ScreenUtil.getHeight(context) * 0.4,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenPadding.padding16px,
                  vertical: ScreenPadding.padding32px,
                ),
                child: Expanded(
                  child: _dertContent(),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return DertDetailsDermanCard(derman: dert.dermans[index]);
              },
              childCount: dert.dermans.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dertContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dert.content,
          style: DertTextStyle.poppins.t14w400purple,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                DertBipsButon(bips: dert.bips),
                SizedBox(width: ScreenPadding.padding8px),
                DertAnswersButton(dermansLength: dert.dermans.length),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_horiz,
                color: DertColor.icon.darkpurple,
                size: IconSize.size30px,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
