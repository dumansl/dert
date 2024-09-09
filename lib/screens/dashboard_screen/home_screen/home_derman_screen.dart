import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_points_card.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/services/dert_service.dart';
import 'package:dert/services/user_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../derman_screen/widgets/derman_circle_avatar.dart';
import '../widgets/dashboard_derman_card.dart';

class HomeDermanScreen extends StatelessWidget {
  final UserModel? user;
  const HomeDermanScreen({super.key, required this.user});

  void _launchMusicUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      snackBar(context, "Could not launch the music URL");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dertService = Provider.of<DertService>(context);
    final userService = Provider.of<UserService>(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenPadding.padding4px,
        vertical: ScreenPadding.padding8px,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user?.musicUrl != null && user!.musicUrl!.isNotEmpty)
            GestureDetector(
              onTap: () => _launchMusicUrl(context, user!.musicUrl!),
              child: const Text(
                'Müziğimi Dinle',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          _headerOptions(context),
          Expanded(
            child: StreamBuilder<List<DermanModel>>(
              stream: dertService.streamDerman(user!.uid),
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
                    itemCount: dermans.length,
                    itemBuilder: (context, index) {
                      final derman = dermans[index];

                      return FutureBuilder<DertModel?>(
                        future: dertService.getDert(derman.dertId),
                        builder: (context, dertSnapshot) {
                          if (dertSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (dertSnapshot.hasError ||
                              !dertSnapshot.hasData) {
                            return const Text('Dert bulunamadı');
                          }
                          final dert = dertSnapshot.data!;
                          return StreamBuilder<UserModel?>(
                            stream: userService.streamUserById(dert.userId),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (userSnapshot.hasError ||
                                  !userSnapshot.hasData) {
                                return const Text(
                                    "Kullanıcı bilgisi bulunamadı");
                              }

                              final dertUser = userSnapshot.data!;
                              return Column(
                                children: [
                                  DashboardDermanCard(
                                    derman: derman,
                                    dert: dert,
                                    topWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            DermanCircleAvatar(
                                              profileImageUrl:
                                                  dertUser.profileImageUrl,
                                              gender: dertUser.gender,
                                              radius: 15,
                                            ),
                                            SizedBox(
                                                width:
                                                    ScreenPadding.padding8px),
                                            Text(
                                              "@${dertUser.username}",
                                              style: DertTextStyle
                                                  .roboto.t14w700white,
                                            ),
                                          ],
                                        ),
                                        DashboardPointsCard(
                                            points: dertUser.points)
                                      ],
                                    ),
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
                                  SizedBox(height: ScreenPadding.padding8px),
                                ],
                              );
                            },
                          );
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

  Widget _headerOptions(BuildContext context) {
    return Row(
      children: [
        Text(DertText.derman, style: DertTextStyle.roboto.t24w600darkpurple),
        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DermanListScreen(user: user!),
              ),
            );
          },
          icon: Icon(
            Icons.menu,
            size: IconSize.size30px,
            color: DertColor.icon.darkpurple,
          ),
        ),
        SizedBox(width: ScreenPadding.padding8px),
        IconButton(
          onPressed: () async {
            final dertService =
                Provider.of<DertService>(context, listen: false);
            DertModel? randomDert = await dertService.findRandomDert(user!.uid);
            if (randomDert != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DermanAddScreen(dert: randomDert, user: user!),
                ),
              );
            } else {
              snackBar(context, "No derman found!");
            }
          },
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
