import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DertAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  const DertAppbar({
    super.key,
    required this.title,
    this.backgroundColor = Colors.white,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: DertColor.icon.darkpurple),
      ),
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: DertColor.icon.darkpurple,
      ),
      title: Text(
        title,
        style: DertTextStyle.roboto.t20w600darkPurple,
      ),
      centerTitle: true,
    );
  }
}
