import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/dert_screen/widgets/custom_button.dart';
import 'package:dert/screens/dert_screen/widgets/custom_dialog.dart';
import 'package:dert/services/dert_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DertAddScreen extends StatefulWidget {
  final UserModel? user;
  const DertAddScreen({super.key, required this.user});

  @override
  State<DertAddScreen> createState() => _DertAddScreenState();
}

class _DertAddScreenState extends State<DertAddScreen> {
  final FocusNode _focusNode = FocusNode();

  final formKey = GlobalKey<FormState>();
  String _dert = "";
  final bool _isConfirmed = false;
  final int _bip = 0;

  void _submitForm() {
    final newDert = DertModel(
      dert: _dert,
      isConfirmed: _isConfirmed,
      derman: [],
      bip: _bip,
    );

    Provider.of<DertService>(context, listen: false)
        .addDert(widget.user!.uid, newDert)
        .then((_) {
      Navigator.of(context).pop();
      snackBar(
        context,
        DertText.dertAddedSuccess,
        bgColor: DertColor.state.success,
      );
      _resetForm();
    }).catchError((error) {
      debugPrint('Dert ekleme hatası: $error');
      snackBar(
        context,
        DertText.dertAddedError,
      );
    });
  }

  void _resetForm() {
    formKey.currentState!.reset();
    setState(() {
      _dert = "";
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DertAppbar(
        title: DertText.shareDert,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                autofocus: true,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: DertText.shareDertTitle,
                  isDense: true,
                  labelStyle: DertTextStyle.roboto.t20w500darkpurple,
                  border: InputBorder.none,
                ),
                maxLines: 7,
                maxLength: 100,
                onSaved: (newValue) {
                  _dert = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return DertText.dertValidator;
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomDertButton(
                text: DertText.send,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    DialogUtils.showMyDialog(
                      context,
                      DertText.dertSendApproval,
                      _submitForm,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
