import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/derman_screen/widgets/derman_circle_avatar.dart';
import 'package:dert/screens/dert_screen/widgets/custom_dert_dialog.dart';
import 'package:dert/screens/dert_screen/widgets/dert_answers_button.dart';
import 'package:dert/screens/dert_screen/widgets/dert_bips_button.dart';
import 'package:dert/screens/dert_screen/widgets/dert_details_derman_card.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/services/services.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DertDetailsScreen extends StatelessWidget {
  final UserModel user;
  final DertModel dert;
  const DertDetailsScreen({super.key, required this.dert, required this.user});

  Future<void> _onCloseDert(
    BuildContext context, {
    required String dertId,
    required DermanModel derman,
    required String dertUserId,
  }) async {
    try {
      final dertProvider = Provider.of<DertService>(context, listen: false);

      await dertProvider.closeDertAndApproveDermanForUser(
          dertId, derman, dertUserId);

      Navigator.pop(context);

      snackBar(context, "Derdinizi onayladınız.",
          bgColor: DertColor.state.success);
    } catch (e) {
      debugPrint(e.toString());
      snackBar(context, "Bir hata oluştu: $e");
    }
  }

  Future<void> _onDeleteDert(
    BuildContext context, {
    required String dertId,
    required String userId,
  }) async {
    try {
      final dertProvider = Provider.of<DertService>(context, listen: false);
      await dertProvider.deleteDert(dertId, userId);

      snackBar(context, "Dert başarıyla silindi.",
          bgColor: DertColor.state.success);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen(user: user)),
        (route) => false,
      );
    } catch (e) {
      snackBar(
        context,
        "Bir hata oluştu: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final dertProvider = Provider.of<DertService>(context);

    debugPrint(dert.dertId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DertAppbar(
        title: DertText.dert,
      ),
      body: FutureBuilder<List<DermanModel>>(
          future: dertProvider.getDermansForDert(dert.dertId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text("Dermanlar alınamadı."));
            }

            final dermans = snapshot.data ?? [];
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  expandedHeight: ScreenUtil.getHeight(context) * 0.4,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenPadding.padding16px,
                        vertical: ScreenPadding.padding32px,
                      ),
                      child: _dertContent(context, dermans: dermans),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final derman = dermans[index];

                      return StreamBuilder<UserModel?>(
                        stream: userService.streamUserById(derman.userId),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (userSnapshot.hasError ||
                              !userSnapshot.hasData) {
                            return const Text("Kullanıcı bilgisi bulunamadı");
                          }

                          final dertUser = userSnapshot.data!;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenPadding.padding16px,
                                vertical: ScreenPadding.padding4px),
                            child: _dermanContent(context, derman, dertUser),
                          );
                        },
                      );
                    },
                    childCount: dermans.length,
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _dertContent(BuildContext context,
      {required List<DermanModel> dermans}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dert.content,
          style: DertTextStyle.poppins.t14w400purple,
          textAlign: TextAlign.justify,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                DertBipsButon(bips: dert.bips),
                SizedBox(width: ScreenPadding.padding16px),
                DertAnswersButton(dermansLength: dermans.length),
              ],
            ),
            IconButton(
              onPressed: () {
                DertDialogUtils.showMyDialog(
                  context,
                  DertText.dertDeleteApproval,
                  () {
                    _onDeleteDert(
                      context,
                      dertId: dert.dertId!,
                      userId: dert.userId,
                    );
                  },
                );
              },
              icon: Icon(
                Icons.delete,
                color: DertColor.icon.darkpurple,
                size: IconSize.size30px,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dermanContent(
      BuildContext context, DermanModel derman, UserModel dertUser) {
    return DertDetailsDermanCard(
      derman: derman,
      bottomWidget: Padding(
        padding: EdgeInsets.only(top: ScreenPadding.padding8px),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                DertDialogUtils.showMyDialog(
                  context,
                  DertText.dermanisApproved,
                  () {
                    _onCloseDert(
                      context,
                      dertId: dert.dertId!,
                      derman: derman,
                      dertUserId: dert.userId,
                    );
                  },
                );
              },
              icon: Icon(
                derman.isApproved ? Icons.favorite : Icons.favorite_border,
                size: IconSize.size30px,
                color: Colors.red,
              ),
            ),
            Row(
              children: [
                Text(
                  "@${dertUser.username}",
                  style: DertTextStyle.roboto.t16w500white,
                ),
                SizedBox(width: ScreenPadding.padding8px),
                DermanCircleAvatar(
                  profileImageUrl: dertUser.profileImageUrl,
                  gender: dertUser.gender,
                  radius: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
