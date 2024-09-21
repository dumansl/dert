import 'package:dert/screens/dashboard_screen/widgets/drend_card.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/services/user_service.dart';

class DrendScreen extends StatefulWidget {
  const DrendScreen({super.key});

  @override
  State<DrendScreen> createState() => _DrendScreenState();
}

class _DrendScreenState extends State<DrendScreen> {
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = UserService().getUsersByPoints();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: _usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Hata oluştu: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Kullanıcı verisi bulunamadı'),
          );
        }

        List<UserModel> users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            UserModel user = users[index];
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenPadding.padding24px,
                  vertical: ScreenPadding.padding8px),
              child: DrendCard(user: user),
            );
          },
        );
      },
    );
  }
}
