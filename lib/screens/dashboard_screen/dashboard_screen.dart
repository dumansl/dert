import 'package:dert/screens/screens.dart';
import 'package:flutter/material.dart';

import 'package:dert/model/user_model.dart';
import 'package:dert/utils/constant/constants.dart';

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
      HomeScreen(
        user: widget.user,
      ),
      const DrendScreen(),
      const NotificationScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(ScreenUtil.getWidth(context).toString());
    return Scaffold(
      drawer: _drawer(context),
      appBar: _appBar(context),
      bottomNavigationBar: bottomNavigationBar(),
      body: _pages[_selectedIndex],
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
        const BottomNavigationBarItem(
          icon: Icon(Icons.notifications_sharp),
          label: '',
        ),
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
            onPressed: () {},
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
                    const CircleAvatar(
                      backgroundColor: Colors.white,
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
                            builder: (context) => const ProfileScreen(),
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
                            builder: (context) => const DertListScreen(),
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
                            builder: (context) => const DermanListScreen(),
                          ),
                        );
                      },
                    ),
                    _drawerOption(
                      assetName: ImagePath.notificationLogo,
                      title: DertText.myNotifications,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      },
                    ),
                    _drawerOption(
                      assetName: ImagePath.phoneLogo,
                      title: DertText.contact,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactScreen(),
                          ),
                        );
                      },
                    ),
                    _drawerOption(
                      assetName: ImagePath.logOutLogo,
                      title: DertText.logOut,
                      onPressed: () {},
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
