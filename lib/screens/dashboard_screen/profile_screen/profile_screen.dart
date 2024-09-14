import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_input_text.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_button.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/services/fetch_youtube_info_service.dart';
import 'package:dert/services/services.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/dashboard_circle_avatar.dart';

class ProfileScreen extends StatefulWidget {
  final bool showScaffold;
  final UserModel user;
  const ProfileScreen(
      {super.key, this.showScaffold = false, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Stream<UserModel?> userStream;
  Map<String, String>? musicInfo;

  @override
  void initState() {
    super.initState();
    userStream = Provider.of<UserService>(context, listen: false)
        .streamUserById(widget.user.uid);
    _fetchMusicInfo();
  }

  Future<void> _fetchMusicInfo() async {
    final youtubeInfoService =
        Provider.of<YoutubeInfoService>(context, listen: false);
    final info =
        await youtubeInfoService.fetchYouTubeInfo(widget.user.musicUrl!);

    setState(() {
      musicInfo = info;
    });
  }

  bool isValidYouTubeUrl(String url) {
    final regex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com\/(?:channel\/|user\/|playlist\/|watch\?v=|shorts\/)?|youtu\.be\/)[a-zA-Z0-9_-]{11}$',
      caseSensitive: false,
    );
    return regex.hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Kullanıcı bilgilerini yüklerken hata oluştu'));
        } else if (snapshot.hasData && snapshot.data != null) {
          return _buildProfileScreen(context, snapshot.data!);
        } else {
          return const Center(child: Text('Kullanıcı bulunamadı'));
        }
      },
    );
  }

  Widget _buildProfileScreen(BuildContext context, UserModel user) {
    if (widget.showScaffold) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: DertAppbar(
          title: DertText.profile,
        ),
        body: Stack(
          children: [
            _profile(context, user),
            _editProfile(context, user),
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          _profile(context, user),
          _editProfile(context, user),
        ],
      );
    }
  }

  Widget _profile(BuildContext context, UserModel user) {
    return Column(
      children: [
        Expanded(
          flex: 50,
          child: _profileHeader(context, user),
        ),
        Expanded(
          flex: 50,
          child: _profileContent(context, user),
        ),
      ],
    );
  }

  Widget _profileHeader(BuildContext context, UserModel user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DashboardCircleAvatar(
          profileImageUrl: user.profileImageUrl,
          gender: user.gender,
          radius: 75,
        ),
        // SizedBox(height: ScreenPadding.padding16px),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     InkWell(
        //       onTap: () {
        //         Navigator.push(
        //           context,
        //           createHorizontalPageRoute(
        //               FollowScreen(showFollowers: true, user: user)),
        //         );
        //       },
        //       child: Text("\n${DertText.followers}",
        //           style: DertTextStyle.roboto.t14w400purple),
        //     ),
        //     SizedBox(width: ScreenPadding.padding24px),
        //     InkWell(
        //       onTap: () {
        //         Navigator.push(
        //           context,
        //           createHorizontalPageRoute(
        //               FollowScreen(showFollowers: false, user: user)),
        //         );
        //       },
        //       child: Text("\n${DertText.follows}",
        //           style: DertTextStyle.roboto.t14w400purple),
        //     ),
        //   ],
        // ),
        SizedBox(height: ScreenPadding.padding16px),
        Text("@${user.username}",
            style: DertTextStyle.roboto.t24w600darkpurple),
      ],
    );
  }

  Widget _profileContent(BuildContext context, UserModel user) {
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
              content: musicInfo != null
                  ? "${musicInfo!['title']} - ${musicInfo!['artist']}"
                  : "",
              logoPath: ImagePath.spotifyLogo,
            ),
            SizedBox(height: ScreenPadding.padding8px),
            Text(DertText.accountInformation,
                style: DertTextStyle.roboto.t18w700white),
            SizedBox(height: ScreenPadding.padding8px),
            _infoContent(
              context,
              header: DertText.registerUserName,
              content: "@${user.username}",
              logoPath: ImagePath.userLogo,
            ),
            SizedBox(height: ScreenPadding.padding8px),
            _infoContent(
              context,
              header: DertText.registerEmail,
              content: user.email,
              logoPath: ImagePath.emailLogo,
            ),
            SizedBox(height: ScreenPadding.padding8px),
            _infoContent(
              context,
              header: DertText.registerGender,
              content: user.gender,
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(header, style: DertTextStyle.poppins.t12w700white),
                  Text(
                    content,
                    style: DertTextStyle.poppins.t10w500white,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (isMusic) ...[
              InkWell(
                onTap: () {
                  _showMyDialog(context, widget.user);
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

  void _showMyDialog(BuildContext context, UserModel user) {
    final TextEditingController urlController = TextEditingController();
    bool isEditing = user.musicUrl != null && user.musicUrl!.isNotEmpty;

    if (isEditing) {
      urlController.text = user.musicUrl!;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DertText.shareMusicLink,
                style: DertTextStyle.roboto.t18w700darkpurple,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: IconSize.size24px,
                  height: IconSize.size24px,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagePath.closeLogo),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
          content: DashboardInputText(
            controller: urlController,
            labelText: "YouTube URL",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final url = urlController.text;
                if (url.isNotEmpty) {
                  if (isValidYouTubeUrl(url)) {
                    try {
                      await Provider.of<UserService>(context, listen: false)
                          .updateUserMusicUrl(user.uid, url);
                      Navigator.pop(context);
                    } catch (e) {
                      snackBar(context, 'Bir hata oluştu: $e');
                    }
                  } else {
                    snackBar(context, "Geçerli bir YouTube URL'si girin.");
                  }
                }
              },
              child: Text(
                DertText.add,
                style: DertTextStyle.roboto.t12w700darkpurple,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _editProfile(BuildContext context, UserModel user) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenPadding.padding70px),
        child: DashboardDertButton(
          text: DertText.profileEdit,
          style: DertTextStyle.roboto.t16w400white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(user: user),
              ),
            );
          },
        ),
      ),
    );
  }
}
