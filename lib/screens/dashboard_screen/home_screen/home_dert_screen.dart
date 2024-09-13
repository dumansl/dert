import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dert_screen/dert_add_screen.dart';
import 'package:dert/screens/dert_screen/dert_list_screen.dart';
import 'package:dert/services/dert_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/dashboard_answers_button.dart';
import '../widgets/dashboard_bips_button.dart';
import '../widgets/dashboard_dert_card.dart';

class HomeDertScreen extends StatefulWidget {
  final UserModel? user;
  const HomeDertScreen({super.key, required this.user});

  @override
  State<HomeDertScreen> createState() => _HomeDertScreenState();
}

class _HomeDertScreenState extends State<HomeDertScreen> {
  @override
  Widget build(BuildContext context) {
    final dertProvider = Provider.of<DertService>(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenPadding.padding4px,
        vertical: ScreenPadding.padding8px,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMusicButton(),
          _buildOptionTitle(context),
          StreamBuilder<List<DertModel>>(
            stream: dertProvider.streamDerts(widget.user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final derts = snapshot.data ?? [];
                if (derts.isEmpty) {
                  return _buildEmptyDertCard(context);
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: derts.length,
                    itemBuilder: (context, index) {
                      final dert = derts[index];
                      return FutureBuilder<List<DermanModel>>(
                        future: dertProvider.getDermansForDert(dert.dertId!),
                        builder: (context, dermanSnapshot) {
                          if (dermanSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (dermanSnapshot.hasError) {
                            return Center(
                                child: Text('Error: ${dermanSnapshot.error}'));
                          } else {
                            final dermans = dermanSnapshot.data ?? [];
                            return Column(
                              children: [
                                DashboardDertCard(
                                  user: widget.user!,
                                  dert: dert,
                                  bottomWidget: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DashboardBipsButton(bips: dert.bips),
                                      DashboardAnswersButton(
                                          dermansLength: dermans.length),
                                    ],
                                  ),
                                ),
                                SizedBox(height: ScreenPadding.padding8px),
                              ],
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _launchMusicUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildMusicButton() {
    if (widget.user?.musicUrl != null && widget.user!.musicUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: () => _launchMusicUrl(widget.user!.musicUrl!),
        child: const Text(
          'Müziğimi Dinle',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildOptionTitle(BuildContext context) {
    return Row(
      children: [
        Text(DertText.dert, style: DertTextStyle.roboto.t24w600darkpurple),
        const Spacer(),
        _buildIconButton(
          icon: Icons.menu,
          onPressed: () => _navigateToDertList(context),
        ),
        SizedBox(width: ScreenPadding.padding8px),
        _buildIconButton(
          icon: Icons.add_circle,
          onPressed: () => _navigateToAddDert(context),
        ),
      ],
    );
  }

  Widget _buildEmptyDertCard(BuildContext context) {
    return Container(
      height: ScreenUtil.getHeight(context) * 0.26,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenPadding.padding16px,
        vertical: ScreenPadding.padding32px,
      ),
      decoration: BoxDecoration(
        color: DertColor.card.purple,
        borderRadius: BorderRadius.circular(SizeRadius.radius5px),
      ),
      child: Row(
        children: [
          Container(
            height: ScreenUtil.getHeight(context) * 0.125,
            width: ScreenUtil.getWidth(context) * 0.28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeRadius.radius10px),
              image: const DecorationImage(
                image: AssetImage(ImagePath.drawing1),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: ScreenPadding.padding12px),
          Expanded(
            child: Text(
              DertText.usersEmptyDertTitle,
              style: DertTextStyle.roboto.t12w400white,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: IconSize.size30px,
        color: DertColor.icon.darkpurple,
      ),
    );
  }

  void _navigateToAddDert(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DertAddScreen(user: widget.user),
      ),
    );
  }

  void _navigateToDertList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DertListScreen(user: widget.user),
      ),
    );
  }
}
