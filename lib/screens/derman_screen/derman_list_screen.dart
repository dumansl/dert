import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/services/dert_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dashboard_screen/widgets/dert_appbar.dart';
import 'widgets/derman_card.dart';

class DermanListScreen extends StatelessWidget {
  final UserModel? user;
  const DermanListScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final dermanProvider = Provider.of<DertService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DertAppbar(
        title: DertText.derman,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenPadding.padding16px,
          vertical: ScreenPadding.padding16px,
        ),
        child: Column(
          children: [
            _dermanListBanner(context),
            Expanded(
              child: StreamBuilder<List<DermanModel>>(
                stream: dermanProvider.streamDerman(user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final dermans = snapshot.data ?? [];
                    if (dermans.isEmpty) {
                      return _dermanListEmpty(context);
                    }
                    return ListView.builder(
                      itemCount: dermans.length,
                      itemBuilder: (context, index) {
                        final derman = dermans[index];

                        return FutureBuilder<DertModel?>(
                          future: dermanProvider.getDert(derman.dertId),
                          builder: (context, dertSnapshot) {
                            if (dertSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (dertSnapshot.hasError ||
                                !dertSnapshot.hasData) {
                              return Center(
                                  child: Text(
                                      'Derman bulunamadı: ${dertSnapshot.error ?? ''}'));
                            } else {
                              final dert = dertSnapshot.data!;
                              return Column(
                                children: [
                                  DermanCard(
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
                                  SizedBox(height: ScreenPadding.padding8px)
                                ],
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
      ),
    );
  }

  Widget _dermanListBanner(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.filter_alt,
        //     size: IconSize.size30px,
        //     color: DertColor.icon.darkpurple,
        //   ),
        // ),
        IconButton(
          onPressed: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => DermanAddScreen(user: user),
            //   ),
            // );
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

  Widget _dermanListEmpty(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: ScreenUtil.getWidth(context) * 0.63,
          width: ScreenUtil.getWidth(context) * 0.63,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePath.onboardImage),
            ),
          ),
        ),
        SizedBox(height: ScreenPadding.padding16px),
        SizedBox(
          width: ScreenUtil.getWidth(context) * 0.6,
          child: Text(
            DertText.dermanListEmptyDertTitle,
            textAlign: TextAlign.center,
            style: DertTextStyle.roboto.t14w500darkpurple,
          ),
        ),
      ],
    );
  }
}
