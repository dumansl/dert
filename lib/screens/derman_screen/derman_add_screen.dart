import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/derman_screen/widgets/derman_dialog.dart';
import 'package:dert/services/services.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/derman_alert_button.dart';
import 'widgets/derman_bips_button.dart';
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
  final FocusNode _focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String _derman = "";

  UserModel? user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final userService = Provider.of<UserService>(context, listen: false);
    user = await userService.getUserById(widget.dert.userId);
    setState(() {});
  }

  void _submitForm() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: DertAppbar(
        title: DertText.derman,
      ),
      body: Padding(
        padding: EdgeInsets.all(ScreenPadding.padding16px),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DermanAlertButton(size: IconSize.size24px, onPressed: () {}),
                  Expanded(
                    child: DermansDertCard(
                      dert: widget.dert,
                      bottomWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DermanBipsButon(bips: widget.dert.bips),
                          user == null
                              ? const CircularProgressIndicator()
                              : Row(
                                  children: [
                                    Text(
                                      "@${user!.username}",
                                      style: DertTextStyle.roboto.t14w700white,
                                    ),
                                    SizedBox(width: ScreenPadding.padding8px),
                                    DermanCircleAvatar(
                                      profileImageUrl: user!.profileImageUrl,
                                      gender: user!.gender,
                                      radius: 15,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TextFormField(
                  autofocus: true,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: DertText.toBeDerman.toUpperCase(),
                    isDense: true,
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
              ),
              SizedBox(height: ScreenPadding.padding24px),
              CustomDermanButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    DermanDialogUtils.showMyDialog(
                        context, DertText.dermanSendApproval, _submitForm);
                  }
                  debugPrint(_derman);
                },
                text: DertText.send,
                style: DertTextStyle.roboto.t20w500white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
