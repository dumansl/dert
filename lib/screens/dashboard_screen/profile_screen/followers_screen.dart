import 'package:dert/model/follow_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/dashboard_screen/widgets/follow_card.dart';
import 'package:dert/services/user_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowersScreen extends StatelessWidget {
  final UserModel user;
  const FollowersScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final followersProvider = Provider.of<UserService>(context);
    return Scaffold(
      appBar: DertAppbar(
        title: DertText.followers,
      ),
      body: FutureBuilder<List<FollowModel>>(
        future: followersProvider.getFollowers(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final followers = snapshot.data ?? [];
            if (followers.isEmpty) {
              return _followersEmpty(context);
            }
            return ListView.builder(
              itemCount: followers.length,
              itemBuilder: (context, index) {
                final follower = followers[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: ScreenPadding.padding8px),
                  child: FollowCard(
                    username: follower.username,
                    buttonImage: ImagePath.blockfollowers,
                  ),
                );
              },
            );
          }
        },
      ),
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
