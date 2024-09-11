import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_bips_button.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/derman_screen/widgets/derman_dialog.dart';
import 'package:dert/services/services.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/horizontal_page_route.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/derman_circle_avatar.dart';
import 'widgets/custom_derman_button.dart';
import 'widgets/dermans_dert_card.dart';

class DermanAddScreen extends StatefulWidget {
  final UserModel user;
  final DertModel dert;

  const DermanAddScreen({super.key, required this.dert, required this.user});

  @override
  State<DermanAddScreen> createState() => _DermanAddScreenState();
}

class _DermanAddScreenState extends State<DermanAddScreen> {
  final formKey = GlobalKey<FormState>();
  String _derman = "";

  void _submitForm() {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();
    final derman = DermanModel(
      dertId: widget.dert.dertId!,
      isApproved: false,
      content: _derman,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      userId: widget.user.uid,
    );

    Provider.of<DertService>(context, listen: false)
        .addDermanToDert(widget.user.uid, widget.dert, derman)
        .then((_) {
      Navigator.of(context).pop();
      snackBar(
        context,
        DertText.dermanAddedSuccess,
        bgColor: DertColor.state.success,
      );
      _resetForm();
    }).catchError((error) {
      debugPrint('Derman ekleme hatası: $error');
      snackBar(
        context,
        DertText.dermanAddedError,
      );
    });
  }

  void _resetForm() {
    formKey.currentState!.reset();
    setState(() {
      _derman = "";
    });
  }

  Future<void> _onBipPressed() async {
    final dertService = Provider.of<DertService>(context, listen: false);
    try {
      await dertService.addBipToDert(widget.dert.dertId!, widget.dert.userId);
      final randomDert = await dertService.findRandomDert(widget.user.uid);
      if (randomDert != null) {
        Navigator.of(context).pushReplacement(createHorizontalPageRoute(
          DermanAddScreen(
            dert: randomDert,
            user: widget.user,
          ),
        ));
      }
    } catch (error) {
      debugPrint('Bip işlemi hatası: $error');
      snackBar(
        context,
        'Bip işlemi sırasında hata oluştu.',
        bgColor: Colors.red,
      );
    }
  }

  Future<void> _onMixPressed() async {
    final dertService = Provider.of<DertService>(context, listen: false);
    try {
      final randomDert = await dertService.findRandomDert(widget.user.uid);
      if (randomDert != null) {
        Navigator.of(context).pushReplacement(createHorizontalPageRoute(
          DermanAddScreen(
            dert: randomDert,
            user: widget.user,
          ),
        ));
      }
    } catch (error) {
      debugPrint('Karıştır işlemi hatası: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DertAppbar(
        title: DertText.derman,
      ),
      body: Padding(
        padding: EdgeInsets.all(ScreenPadding.padding16px),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _dertContent(userService),
                  _addDerman(context),
                ],
              ),
              _otherOptions(),
              SizedBox(height: ScreenPadding.padding8px),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dertContent(UserService userService) {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<UserModel?>(
            stream: userService.streamUserById(widget.dert.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Kullanıcı bilgileri yüklenemedi');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Text('Kullanıcı bulunamadı');
              }

              final user = snapshot.data!;
              return DermansDertCard(
                dert: widget.dert,
                bottomWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DashboardBipsButton(bips: widget.dert.bips),
                    Row(
                      children: [
                        Text(
                          "@${user.username}",
                          style: DertTextStyle.roboto.t14w700white,
                        ),
                        SizedBox(width: ScreenPadding.padding8px),
                        DermanCircleAvatar(
                          profileImageUrl: user.profileImageUrl,
                          gender: user.gender,
                          radius: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _addDerman(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: DertText.toBeDerman.toUpperCase(),
            labelStyle: DertTextStyle.roboto.t20w500darkpurple,
            border: InputBorder.none,
          ),
          maxLines: 7,
          maxLength: 280,
          onSaved: (newValue) {
            _derman = newValue!;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return DertText.dermanValidator;
            }
            return null;
          },
        ),
        SizedBox(height: ScreenPadding.padding8px),
        CustomDermanButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              DermanDialogUtils.showMyDialog(
                  context, DertText.dermanSendApproval, _submitForm);
            }
          },
          child: Text(
            DertText.send,
            style: DertTextStyle.roboto.t20w500white,
          ),
        ),
      ],
    );
  }

  Widget _bipLogo() {
    return Container(
      height: IconSize.size30px,
      width: IconSize.size30px,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.bipLogo),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _otherOptions() {
    return Row(
      children: [
        Expanded(
          child: CustomDermanButton(
            onPressed: _onBipPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bipLogo(),
                SizedBox(width: ScreenPadding.padding8px),
                Text(
                  DertText.bip,
                  style: DertTextStyle.roboto.t20w500white,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: ScreenPadding.padding16px),
        Expanded(
          child: CustomDermanButton(
            onPressed: _onMixPressed,
            child: Text(
              DertText.mix,
              style: DertTextStyle.roboto.t20w500white,
            ),
          ),
        ),
      ],
    );
  }
}
