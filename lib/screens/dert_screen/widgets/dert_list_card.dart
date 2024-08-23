import 'package:dert/model/dert_model.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

import 'answer_logo.dart';
import 'bip_logo.dart';

class DertListCard extends StatelessWidget {
  final DertModel dert;
  const DertListCard({
    super.key,
    required this.dert,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenPadding.padding12px,
        vertical: ScreenPadding.padding16px,
      ),
      decoration: BoxDecoration(
        color: DertColor.background.purple,
        borderRadius: BorderRadius.all(
          Radius.circular(SizeRadius.radius5px),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            VerticalDivider(
              color: DertColor.card.darkpurple,
              thickness: 5,
            ),
            SizedBox(width: ScreenPadding.padding8px),
            Expanded(
              child: Column(
                children: [
                  Text(
                    dert.dert,
                    style: DertTextStyle.roboto.t12w400white,
                    textAlign: TextAlign.justify,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenPadding.padding8px),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _bipButton(),
                        _answersCount(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bipButton() {
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
          const BipLogo(radius: 20),
          SizedBox(
            width: ScreenPadding.padding8px,
          ),
          Text(
            "${dert.bip}",
            style: DertTextStyle.roboto.t12w500white,
          ),
        ],
      ),
    );
  }

  Widget _answersCount() {
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
            "${dert.derman.length}",
            style: DertTextStyle.roboto.t12w500white,
          ),
          SizedBox(width: ScreenPadding.padding8px),
          const AnswerLogo(radius: 20),
        ],
      ),
    );
  }
}
