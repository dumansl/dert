import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dert_screen/widgets/dert_list_card.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/services/dert_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/dert_appbar.dart';

class DertListScreen extends StatelessWidget {
  final UserModel? user;
  const DertListScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final dertProvider = Provider.of<DertService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DertAppbar(
        title: DertText.dert,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenPadding.padding16px,
          vertical: ScreenPadding.padding16px,
        ),
        child: StreamBuilder<List<DertModel>>(
          stream: dertProvider.streamDerts(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final derts = snapshot.data ?? [];
              if (derts.isEmpty) {
                return _dertListEmpty(context);
              }
              return Column(
                children: [
                  _dertListBanner(context),
                  Expanded(
                    child: ListView.builder(
                      itemCount: derts.length,
                      itemBuilder: (context, index) {
                        final dert = derts[index];
                        return Padding(
                          padding:
                              EdgeInsets.only(bottom: ScreenPadding.padding8px),
                          child: DertListCard(dert: dert),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _dertListBanner(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.filter_alt,
            size: 30,
            color: DertColor.icon.darkpurple,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DermanAddScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.add_circle,
            size: 30,
            color: DertColor.icon.darkpurple,
          ),
        ),
      ],
    );
  }

  Widget _dertListEmpty(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add_circle,
              size: 30,
              color: DertColor.icon.darkpurple,
            ),
          ),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 250,
              width: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImagePath.drawing3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: Text(
                DertText.dertListEmptyDertTitle,
                textAlign: TextAlign.center,
                style: DertTextStyle.roboto.t14w500darkpurple,
              ),
            ),
          ],
        ))
      ],
    );
  }
}
