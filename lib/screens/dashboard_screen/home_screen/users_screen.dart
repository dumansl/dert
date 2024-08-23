import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/services/dert_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_dert_card.dart';

class UsersScreen extends StatefulWidget {
  final UserModel? user;
  const UsersScreen({super.key, required this.user});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    final dertProvider = Provider.of<DertService>(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenPadding.padding4px,
        vertical: ScreenPadding.padding8px,
      ),
      child: StreamBuilder<List<DertModel>>(
        stream: dertProvider.streamDerts(widget.user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final derts = snapshot.data ?? [];
            if (derts.isEmpty) {
              return _usersEmpty(context);
            }
            return ListView.builder(
              // scrollDirection: Axis.horizontal,
              itemCount: derts.length,
              itemBuilder: (context, index) {
                final dert = derts[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: ScreenPadding.padding8px),
                  child: CustomDertCard(dert: dert),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _usersEmpty(BuildContext context) {
    return Column(
      children: [
        _optionTitleContent(
          context,
          title: "DERT",
          iconPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DertAddScreen()),
            );
          },
          listPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DertListScreen(user: widget.user),
              ),
            );
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 16),
        _usersEmptyCard(
          context,
          path: ImagePath.drawing1,
          text: DertText.usersEmptyDertTitle,
        ),
        _optionTitleContent(
          context,
          title: DertText.derman,
          iconPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DermanAddScreen()),
            );
          },
          listPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DermanListScreen(),
              ),
            );
          },
        ),
        _usersEmptyCard(
          context,
          path: ImagePath.drawing2,
          text: DertText.usersEmptyDermanTitle,
        )
      ],
    );
  }

  Widget _optionTitleContent(
    BuildContext context, {
    required String title,
    required VoidCallback listPressed,
    required VoidCallback iconPressed,
  }) {
    return Row(
      children: [
        Text(title, style: DertTextStyle.roboto.t24w600darkpurple),
        const Spacer(),
        IconButton(
          onPressed: listPressed,
          icon: Icon(
            Icons.menu,
            size: 30,
            color: DertColor.icon.darkpurple,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: iconPressed,
          icon: Icon(
            Icons.add_circle,
            size: 30,
            color: DertColor.icon.darkpurple,
          ),
        ),
      ],
    );
  }

  Widget _usersEmptyCard(BuildContext context,
      {required String path, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenPadding.padding16px,
          vertical: ScreenPadding.padding32px),
      decoration: BoxDecoration(
        color: DertColor.card.purple,
        borderRadius: BorderRadius.all(Radius.circular(SizeRadius.radius5px)),
      ),
      child: Row(
        children: [
          Container(
            height: 95,
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: DertTextStyle.roboto.t12w400white,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
