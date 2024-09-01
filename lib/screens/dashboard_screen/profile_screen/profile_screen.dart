import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_button.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_circle_avatar.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/horizontal_page_route.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final bool showScaffold;
  final UserModel? user;
  const ProfileScreen(
      {super.key, this.showScaffold = false, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.showScaffold) {
      return Scaffold(
        appBar: DertAppbar(
          title: DertText.profile,
        ),
        body: Stack(
          children: [
            _profile(context),
            _editProfile(context),
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          _profile(context),
          _editProfile(context),
        ],
      );
    }
  }

  Widget _profile(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 50,
          child: _profileHeader(context),
        ),
        Expanded(
          flex: 50,
          child: _profileContent(context),
        ),
      ],
    );
  }

  Widget _profileHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DertCircleAvatar(
          profileImageUrl: widget.user?.profileImageUrl,
          gender: widget.user!.gender,
          radius: 50,
        ),
        SizedBox(height: ScreenPadding.padding16px),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  createHorizontalPageRoute(
                      FollowScreen(showFollowers: true, user: widget.user!)),
                );
              },
              child: Text("\n${DertText.followers}",
                  style: DertTextStyle.roboto.t14w400purple),
            ),
            SizedBox(width: ScreenPadding.padding24px),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  createHorizontalPageRoute(
                      FollowScreen(showFollowers: false, user: widget.user!)),
                );
              },
              child: Text("\n${DertText.follows}",
                  style: DertTextStyle.roboto.t14w400purple),
            ),
          ],
        ),
        SizedBox(height: ScreenPadding.padding16px),
        Text("@${widget.user!.username}",
            style: DertTextStyle.roboto.t24w400purple),
      ],
    );
  }

  Widget _profileContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: ScreenPadding.padding24px,
        top: ScreenPadding.padding40px,
        right: ScreenPadding.padding24px,
      ),
      decoration: BoxDecoration(
        color: DertColor.card.purple,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _infoContent(
              context,
              isMusic: true,
              header: DertText.selectedMusic,
              content: "Müslüm Gürses - Yakarsa Dünyayı Garipler Yakar",
              logoPath: ImagePath.spotifyLogo,
            ),
            SizedBox(height: ScreenPadding.padding8px),
            Text(DertText.accountInformation,
                style: DertTextStyle.roboto.t18w700white),
            SizedBox(height: ScreenPadding.padding8px),
            _infoContent(
              context,
              header: DertText.registerUserName,
              content: "@${widget.user!.username}",
              logoPath: ImagePath.userLogo,
            ),
            SizedBox(height: ScreenPadding.padding8px),
            _infoContent(
              context,
              header: DertText.registerEmail,
              content: widget.user!.email,
              logoPath: ImagePath.emailLogo,
            ),
            SizedBox(height: ScreenPadding.padding8px),
            _infoContent(
              context,
              header: DertText.registerGender,
              content: widget.user!.gender,
              logoPath: ImagePath.genderLogo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoContent(
    BuildContext context, {
    required String logoPath,
    required String header,
    required String content,
    bool isMusic = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: IconSize.size24px,
              width: IconSize.size24px,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(logoPath),
                ),
              ),
            ),
            SizedBox(width: ScreenPadding.padding8px),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(header, style: DertTextStyle.poppins.t12w700white),
                Text(content, style: DertTextStyle.poppins.t10w500white),
              ],
            ),
            const Spacer(),
            if (isMusic) ...[
              InkWell(
                onTap: () {
                  // _showMyDialog(context);
                },
                child: Container(
                  height: IconSize.size24px,
                  width: IconSize.size24px,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagePath.randomLogo),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        if (!isMusic) ...[
          const Divider(color: Colors.white),
        ]
      ],
    );
  }

  Widget _editProfile(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenPadding.padding70px),
        child: DertButton(
          text: DertText.profileEdit,
          style: DertTextStyle.roboto.t16w400white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
