import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/answers_button.dart';
import 'package:dert/screens/dashboard_screen/widgets/bips_button.dart';
import 'package:dert/screens/dashboard_screen/widgets/derman_card.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/services/dert_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    return _usersEmptyCard(
                      context,
                      path: ImagePath.drawing1,
                      text: DertText.usersEmptyDertTitle,
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: derts.length,
                    itemBuilder: (context, index) {
                      final dert = derts[index];
                      return Padding(
                        padding:
                            EdgeInsets.only(right: ScreenPadding.padding8px),
                        child: DertCard(
                          width: ScreenUtil.getWidth(context) * 0.76,
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
          _optionTitleContent(
            context,
            title: DertText.derman,
            iconPressed: () async {
              final dertService =
                  Provider.of<DertService>(context, listen: false);
              DertModel? dert = await dertService.findRandomDert();
              if (dert != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DermanAddScreen(
                      dert: dert,
                      user: widget.user!,
                    ),
                  ),
                );
              } else {
                snackBar(context, "No derman found!");
              }
            },
            listPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DermanListScreen(
                    user: widget.user!,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<List<DermanModel>>(
              stream: dertProvider.streamDerman(widget.user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final dermans = snapshot.data ?? [];

                  if (dermans.isEmpty) {
                    return _usersEmptyCard(
                      context,
                      path: ImagePath.drawing2,
                      text: DertText.usersEmptyDermanTitle,
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dermans.length,
                    itemBuilder: (context, index) {
                      final derman = dermans[index];

                      return FutureBuilder<DertModel?>(
                        future: dertProvider.getDert(derman.dertId),
                        builder: (context, dertSnapshot) {
                          if (dertSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (dertSnapshot.hasError ||
                              !dertSnapshot.hasData) {
                            return Center(
                                child: Text(
                                    'Dert bulunamadı: ${dertSnapshot.error ?? ''}'));
                          } else {
                            final dert = dertSnapshot.data!;
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: ScreenPadding.padding8px),
                              child: DermanCard(
                                width: ScreenUtil.getWidth(context) * 0.76,
                                derman: derman,
                                dert: dert,
                                bottomWidget: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    derman.isApproved
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: IconSize.size24px,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
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
              borderRadius: BorderRadius.circular(SizeRadius.radius10px),
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
