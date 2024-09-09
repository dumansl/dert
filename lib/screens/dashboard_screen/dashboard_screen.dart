import 'package:dert/model/dert_model.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/services/auth_service.dart';
import 'package:dert/services/dert_service.dart';
import 'package:dert/services/shared_preferences_service.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'widgets/dashboard_circle_avatar.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel? user;
  const DashboardScreen({
    super.key,
    required this.user,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(user: widget.user),
      const DrendScreen(),
      // const NotificationScreen(),
      ProfileScreen(
        userId: widget.user!.uid,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> logout(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final sharedPreferencesService = SharedPreferencesService();

    bool? confirmLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            DertText.logOutAlertDialog,
            style: DertTextStyle.roboto.t18w700purple,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(DertText.logOutNo,
                  style: DertTextStyle.roboto.t16w600darkPurple),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(DertText.logOutYes,
                  style: DertTextStyle.roboto.t16w600darkPurple),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      try {
        await authService.signOut();
        await sharedPreferencesService.clearLoggedInStatus();
        await clearUserBox();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } catch (error) {
        snackBar(context, error.toString());
      }
    }
  }

  Future<void> clearUserBox() async {
    var box = Hive.box<UserModel>('userBox');
    await box.clear();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(ScreenUtil.getWidth(context).toString());
    debugPrint(ScreenUtil.getHeight(context).toString());
    return Scaffold(
      drawer: _drawer(context),
      appBar: _appBar(context),
      bottomNavigationBar: bottomNavigationBar(),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return _buildBottomDialog(context);
            },
          );
        },
        backgroundColor: DertColor.button.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomDialog(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenPadding.padding24px),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DertText.create,
                  style: DertTextStyle.roboto.t20w500darkpurple),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: ScreenUtil.getWidth(context) * 0.06,
                  height: ScreenUtil.getWidth(context) * 0.06,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagePath.closeLogo),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: ScreenPadding.padding16px),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DertAddScreen(
                    user: widget.user,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  width: ScreenUtil.getWidth(context) * 0.06,
                  height: ScreenUtil.getWidth(context) * 0.06,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagePath.warningLogo),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(width: ScreenPadding.padding20px),
                Text(
                  DertText.tellYourProblem,
                  style: DertTextStyle.roboto.t16w500darkpurple,
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenPadding.padding16px),
          InkWell(
            onTap: () async {
              final dertService =
                  Provider.of<DertService>(context, listen: false);
              DertModel? dert =
                  await dertService.findRandomDert(widget.user!.uid);
              if (dert != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DermanAddScreen(
                      dert: dert,
                      user: widget.user!,
                    ),
                  ),
                );
              } else {
                snackBar(context, "No dert found!");
              }
            },
            child: Row(
              children: [
                Container(
                  width: ScreenUtil.getWidth(context) * 0.06,
                  height: ScreenUtil.getWidth(context) * 0.06,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagePath.checkLogo),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(width: ScreenPadding.padding20px),
                Text(
                  DertText.toBeDerman,
                  style: DertTextStyle.roboto.t16w500darkpurple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      iconSize: IconSize.size30px,
      selectedIconTheme: IconThemeData(
        color: DertColor.icon.darkpurple,
      ),
      unselectedIconTheme: IconThemeData(
        color: DertColor.icon.purple,
      ),
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            ImagePath.dertLogo,
            width: IconSize.size25px,
            height: IconSize.size25px,
          ),
          label: '',
        ),
        // const BottomNavigationBarItem(
        //   icon: Icon(Icons.notifications_sharp),
        //   label: '',
        // ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_sharp),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: DertColor.icon.darkpurple,
      ),
      title: SizedBox(
        height: ScreenUtil.getHeight(context) * 0.065,
        width: ScreenUtil.getWidth(context) * 0.25,
        child: Image.asset(
          ImagePath.logo,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: ScreenPadding.padding8px),
          child: IconButton(
            onPressed: () => logout(context),
            icon: Icon(
              Icons.exit_to_app,
              size: IconSize.size25px,
            ),
          ),
        ),
      ],
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      backgroundColor: DertColor.card.purple,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenPadding.padding32px,
            left: ScreenPadding.padding32px,
            bottom: ScreenPadding.padding8px,
            right: ScreenPadding.padding12px,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DashboardCircleAvatar(
                      profileImageUrl: widget.user?.profileImageUrl,
                      gender: widget.user!.gender,
                      radius: 65,
                    ),
                    SizedBox(height: ScreenPadding.padding16px),
                    Text(
                      "@${widget.user!.username}",
                      style: DertTextStyle.roboto.t24w400white,
                    ),
                    SizedBox(height: ScreenPadding.padding32px),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _drawerOption(
                      assetName: ImagePath.homeLogo,
                      title: DertText.home,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DashboardScreen(user: widget.user),
                          ),
                        );
                      },
                    ),
                    _drawerOption(
                      assetName: ImagePath.userLogo,
                      title: DertText.myProfile,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              showScaffold: true,
                              userId: widget.user!.uid,
                            ),
                          ),
                        );
                      },
                    ),
                    _drawerOption(
                      assetName: ImagePath.warningLogo,
                      title: DertText.myDert,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DertListScreen(user: widget.user),
                          ),
                        );
                      },
                    ),
                    _drawerOption(
                      assetName: ImagePath.checkLogo,
                      title: DertText.myDerman,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DermanListScreen(user: widget.user),
                          ),
                        );
                      },
                    ),
                    // _drawerOption(
                    //   assetName: ImagePath.notificationLogo,
                    //   title: DertText.myNotifications,
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) =>
                    //             const NotificationScreen(showScaffold: true),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // _drawerOption(
                    //   assetName: ImagePath.phoneLogo,
                    //   title: DertText.contact,
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const ContactScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    _drawerOption(
                      assetName: ImagePath.logOutLogo,
                      title: DertText.logOut,
                      onPressed: () => logout(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerOption({
    required assetName,
    required title,
    onPressed,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(assetName),
                  ),
                ),
              ),
              SizedBox(width: ScreenPadding.padding8px),
              Text(
                title,
                style: DertTextStyle.roboto.t24w400white,
              )
            ],
          ),
        ),
        SizedBox(height: ScreenPadding.padding30px),
      ],
    );
  }
}
