import 'package:auto_size_text/auto_size_text.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLeadingVisible;
  final Color backgroundColor;
  final Color? iconColor;
  final TextStyle style;
  const BasicAppBar(
      {super.key,
      required this.title,
      this.isLeadingVisible = true,
      required this.backgroundColor,
      required this.style,
      this.iconColor});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isLeadingVisible
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: iconColor),
            )
          : const SizedBox(),
      backgroundColor: backgroundColor,
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: DertColor.icon.darkpurple,
      ),
      title: AutoSizeText(title, style: style),
      centerTitle: true,
    );
  }
}
