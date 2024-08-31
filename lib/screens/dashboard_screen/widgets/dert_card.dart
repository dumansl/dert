import 'package:dert/model/dert_model.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DertCard extends StatelessWidget {
  final DertModel dert;
  final Widget? topWidget;
  final Widget? bottomWidget;
  const DertCard({
    super.key,
    required this.dert,
    this.topWidget,
    this.bottomWidget,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: ScreenPadding.padding8px),
                    child: topWidget,
                  ),
                  Text(
                    dert.content,
                    style: DertTextStyle.roboto.t12w400white,
                    textAlign: TextAlign.justify,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenPadding.padding8px),
                    child: bottomWidget,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
