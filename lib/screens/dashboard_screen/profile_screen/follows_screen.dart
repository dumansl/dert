import 'package:dert/model/follow_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/dashboard_screen/widgets/follow_card.dart';
import 'package:dert/services/services.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowScreen extends StatelessWidget {
  final UserModel user;
  final bool showFollowers;

  const FollowScreen(
      {super.key, required this.user, this.showFollowers = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DertAppbar(
        title: showFollowers ? DertText.followers : DertText.follows,
      ),
      body: FutureBuilder<List<FollowModel>>(
        future: showFollowers
            ? context.read<UserService>().getFollowers(user.uid)
            : context.read<UserService>().getFollows(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: showFollowers
                  ? _followersEmpty(context)
                  : _followsEmpty(context),
            );
          } else {
            List<FollowModel> follows = snapshot.data!;
            return ListView.builder(
              itemCount: follows.length,
              itemBuilder: (context, index) {
                FollowModel follow = follows[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenPadding.screenpadding,
                    vertical: ScreenPadding.screenpadding / 2,
                  ),
                  child: Column(
                    children: [
                      FollowCard(
                        follow: follow,
                        gender: user.gender,
                        buttonImage: ImagePath.unfollow,
                        onPressed: () {
                          final userService =
                              Provider.of<UserService>(context, listen: false);
                          userService.removeFollower(user.uid, follow.id);
                        },
                      ),
                      const Divider(),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _followsEmpty(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 300,
          width: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
                image: AssetImage(
                  ImagePath.onboardImage,
                ),
                fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 50),
        SizedBox(
          width: 300,
          child: Text(
            DertText.followsEmpty,
            textAlign: TextAlign.center,
            style: DertTextStyle.roboto.t14w500darkpurple,
          ),
        ),
      ],
    );
  }

  Widget _followersEmpty(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 300,
          width: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
                image: AssetImage(
                  ImagePath.drawing1,
                ),
                fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 50),
        SizedBox(
          width: 300,
          child: Text(
            DertText.followersEmpty,
            textAlign: TextAlign.center,
            style: DertTextStyle.roboto.t14w500darkpurple,
          ),
        ),
      ],
    );
  }
}
