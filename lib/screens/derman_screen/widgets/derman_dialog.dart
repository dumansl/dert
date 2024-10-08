import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

import 'custom_derman_button.dart';

class DermanDialogUtils {
  static void showMyDialog(
      BuildContext context, String title, Function() onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: IconSize.size24px,
                height: IconSize.size24px,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImagePath.closeLogo),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          content: Text(title,
              style: DertTextStyle.roboto.t18w700darkpurple,
              textAlign: TextAlign.center),
          actions: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: CustomDermanButton(
                onPressed: onPressed,
                child: Text(
                  DertText.send,
                  style: DertTextStyle.roboto.t20w500white,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
