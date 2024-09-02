import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_circle_avatar.dart';
import 'package:dert/services/auth_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? _profileImageUrl;
  bool _isUploadingImage = false;

  Future<void> _uploadProfileImage() async {
    setState(() {
      _isUploadingImage = true;
    });

    try {
      String? imageUrl = await Provider.of<AuthService>(context, listen: false)
          .uploadProfileImage();
      setState(() {
        _profileImageUrl = imageUrl;
      });
    } catch (e) {
      snackBar(context, "Resim yükleme sırasında bir hata oluştu: $e");
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DertAppbar(
        title: DertText.profileEdit.toUpperCase(),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenPadding.padding24px,
            vertical: ScreenPadding.padding16px,
          ),
          child: Column(
            children: [
              _changePhoto(context),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _changePhoto(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.getWidth(context) * 0.25,
      width: ScreenUtil.getWidth(context) * 0.25,
      child: Stack(
        children: [
          DertCircleAvatar(
            profileImageUrl: _profileImageUrl ?? widget.user.profileImageUrl,
            gender: widget.user.gender,
            radius: 50,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: _uploadProfileImage,
              child: Container(
                width: IconSize.size35px,
                height: IconSize.size35px,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      ImagePath.changePhotoLogo,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isUploadingImage)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
