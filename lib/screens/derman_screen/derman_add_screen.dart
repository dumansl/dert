import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_button.dart';
import 'package:dert/screens/dashboard_screen/widgets/warning_button.dart';
import 'package:dert/screens/dert_screen/widgets/custom_dialog.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DermanAddScreen extends StatefulWidget {
  const DermanAddScreen({super.key});

  @override
  State<DermanAddScreen> createState() => _DertAddScreenState();
}

class _DertAddScreenState extends State<DermanAddScreen> {
  final FocusNode _focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String _derman = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  WarningButton(size: 24, onPressed: () {}),
                  // DertCard(dert: dert),
                ],
              ),
              TextFormField(
                autofocus: true,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: DertText.toBeDerman.toUpperCase(),
                  isDense: true,
                  labelStyle: DertTextStyle.roboto.t20w500darkpurple,
                  border: InputBorder.none,
                ),
                maxLines: 7,
                maxLength: 100,
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
              const SizedBox(height: 24),
              DertButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      DialogUtils.showMyDialog(
                          context, DertText.dermanSendApproval, () => null);
                    }
                    debugPrint(_derman);
                  },
                  text: DertText.send,
                  style: DertTextStyle.roboto.t20w500white),
            ],
          ),
        ),
      ),
    );
  }
}
