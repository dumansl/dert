import 'package:dert/model/user_model.dart';
import 'package:dert/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:dert/model/dert_model.dart';
import 'package:dert/utils/constant/constants.dart';

class DertCard extends StatelessWidget {
  final UserModel user;
  final DertModel dert;
  final Widget? topWidget;
  final Widget? bottomWidget;
  final double? width;
  const DertCard({
    super.key,
    required this.user,
    required this.dert,
    this.topWidget,
    this.bottomWidget,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DertDetailsScreen(
                dert: dert,
                user: user,
              ),
            ));
      },
      child: Container(
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
                      style: DertTextStyle.roboto.t12w400white,
                      textAlign: TextAlign.justify,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (bottomWidget != null) ...[
                      Padding(
                        padding: EdgeInsets.only(top: ScreenPadding.padding8px),
                        child: bottomWidget,
                      )
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
