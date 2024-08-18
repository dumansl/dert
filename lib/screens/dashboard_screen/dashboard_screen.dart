import 'package:dert/screens/screens.dart';
import 'package:flutter/material.dart';

import 'package:dert/model/user_model.dart';
import 'package:dert/utils/constant/constants.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel? user;
  const DashboardScreen({
    super.key,
    this.user,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const DrendScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: DertColor.background.darkpurple,
    );
  }
}
