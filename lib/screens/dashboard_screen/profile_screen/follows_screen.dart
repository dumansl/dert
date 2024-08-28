import 'package:dert/model/follow_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/dashboard_screen/widgets/follow_card.dart';
import 'package:dert/services/user_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowsScreen extends StatelessWidget {
  final UserModel user;
  const FollowsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final followsProvider = Provider.of<UserService>(context);
    return Scaffold(
      appBar: DertAppbar(
        title: DertText.follows,
      ),
      body: FutureBuilder<List<FollowModel>>(
        future: followsProvider.getFollows(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final follows = snapshot.data ?? [];
            if (follows.isEmpty) {
              return _followsEmpty(context);
            }
            return ListView.builder(
              itemCount: follows.length,
              itemBuilder: (context, index) {
                final follow = follows[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: ScreenPadding.padding8px),
                  child: FollowCard(
                    username: follow.username,
                    buttonImage: ImagePath.unfollow,
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
    return Center(
      child: Column(
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
      ),
    );
  }
}
