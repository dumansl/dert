// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:dert/model/dert_model.dart';
import 'package:dert/utils/constant/constants.dart';

class DashboardDermanCard extends StatelessWidget {
  final DertModel dert;
  final DermanModel derman;
  final Widget? topWidget;
  final Widget? bottomWidget;
  final double? width;
  const DashboardDermanCard({
    super.key,
    required this.dert,
    this.topWidget,
    this.bottomWidget,
    this.width,
    required this.derman,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (topWidget != null) ...[
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: ScreenPadding.padding8px),
                      child: topWidget,
                    )
                  ],
                  Text(
                    dert.content,
                    style: DertTextStyle.roboto.t12w400grey,
                    textAlign: TextAlign.justify,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenPadding.padding16px),
                    child: Text(derman.content,
                        style: DertTextStyle.roboto.t12w400white,
                        textAlign: TextAlign.justify,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis),
                  ),
                  if (bottomWidget != null) ...[
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: ScreenPadding.padding8px),
                      child: bottomWidget,
                    )
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
