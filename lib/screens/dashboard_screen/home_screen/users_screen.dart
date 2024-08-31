import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/answers_button.dart';
import 'package:dert/screens/dashboard_screen/widgets/bips_button.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/services/dert_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/dert_card.dart';

class UsersScreen extends StatefulWidget {
  final UserModel? user;
  const UsersScreen({super.key, required this.user});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  void _launchMusicUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dertProvider = Provider.of<DertService>(context);
    debugPrint(widget.user.toString());
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenPadding.padding4px,
        vertical: ScreenPadding.padding8px,
      ),
      child: Column(
        children: [
          if (widget.user!.musicUrl != null &&
              widget.user!.musicUrl!.isNotEmpty)
            GestureDetector(
              onTap: () {
                _launchMusicUrl(widget.user!.musicUrl!);
              },
              child: const Text(
                'Müziğimi Dinle',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<DertModel>>(
              stream: dertProvider.streamDerts(widget.user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final derts = snapshot.data ?? [];
                  if (derts.isEmpty) {
                    return _usersEmpty(context);
                  }
                  return ListView.builder(
                    itemCount: derts.length,
                    itemBuilder: (context, index) {
                      final dert = derts[index];
                      return Padding(
                        padding:
                            EdgeInsets.only(bottom: ScreenPadding.padding8px),
                        child: DertCard(
                          dert: dert,
                          bottomWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BipsButon(bips: dert.bips),
                              AnswersButton(dermansLength: dert.dermans.length),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _usersEmpty(BuildContext context) {
    return Column(
      children: [
        _optionTitleContent(
          context,
          title: DertText.dert,
          iconPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DertAddScreen(
                  user: widget.user,
                ),
              ),
            );
          },
          listPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DertListScreen(user: widget.user),
              ),
            );
            Navigator.pop(context);
          },
        ),
        SizedBox(height: ScreenPadding.padding16px),
        _usersEmptyCard(
          context,
          path: ImagePath.drawing1,
          text: DertText.usersEmptyDertTitle,
        ),
        _optionTitleContent(
          context,
          title: DertText.derman,
          iconPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DermanAddScreen()),
            );
          },
          listPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DermanListScreen(),
              ),
            );
          },
        ),
        _usersEmptyCard(
          context,
          path: ImagePath.drawing2,
          text: DertText.usersEmptyDermanTitle,
        )
      ],
    );
  }

  Widget _optionTitleContent(
    BuildContext context, {
    required String title,
    required VoidCallback listPressed,
    required VoidCallback iconPressed,
  }) {
    return Row(
      children: [
        Text(title, style: DertTextStyle.roboto.t24w600darkpurple),
        const Spacer(),
        IconButton(
          onPressed: listPressed,
          icon: Icon(
            Icons.menu,
            size: IconSize.size30px,
            color: DertColor.icon.darkpurple,
          ),
        ),
        SizedBox(width: ScreenPadding.padding8px),
        IconButton(
          onPressed: iconPressed,
          icon: Icon(
            Icons.add_circle,
            size: IconSize.size30px,
            color: DertColor.icon.darkpurple,
          ),
        ),
      ],
    );
  }

  Widget _usersEmptyCard(BuildContext context,
      {required String path, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenPadding.padding16px,
          vertical: ScreenPadding.padding32px),
      decoration: BoxDecoration(
        color: DertColor.card.purple,
        borderRadius: BorderRadius.all(Radius.circular(SizeRadius.radius5px)),
      ),
      child: Row(
        children: [
          Container(
            height: ScreenUtil.getHeight(context) * 0.125,
            width: ScreenUtil.getWidth(context) * 0.28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: ScreenPadding.padding12px),
          Expanded(
            child: Text(
              text,
              style: DertTextStyle.roboto.t12w400white,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
