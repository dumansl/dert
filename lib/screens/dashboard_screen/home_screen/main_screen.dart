import 'package:dert/model/dert_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/services/dert_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  final UserModel? user;
  const MainScreen({
    super.key,
    required this.user,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Stream<List<DertModel>> followedDertsStream;

  @override
  void initState() {
    super.initState();
    followedDertsStream = Provider.of<DertService>(context, listen: false)
        .streamFollowedUsersDerts(widget.user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ScreenPadding.padding16px),
      child: StreamBuilder<List<DertModel>>(
        stream: followedDertsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: _mainEmpty(context));
          } else {
            final derts = snapshot.data!;

            return ListView.builder(
              itemCount: derts.length,
              itemBuilder: (context, index) {
                final dert = derts[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(dert.content),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bips: ${dert.bips}'),
                        Text('Kapalı mı?: ${dert.isClosed ? 'Evet' : 'Hayır'}'),
                      ],
                    ),
                    onTap: () {
                      // Dert detaylarına gitmek için tıklama işlevi ekleyin.
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

Widget _mainEmpty(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: ScreenUtil.getHeight(context) * 0.4,
        width: ScreenUtil.getHeight(context) * 0.4,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.onboardImage),
          ),
        ),
      ),
      SizedBox(height: ScreenPadding.padding16px),
      Text(
        DertText.mainEmptyText,
        textAlign: TextAlign.center,
        style: DertTextStyle.roboto.t16w700darkpurple,
      ),
    ],
  );
}
