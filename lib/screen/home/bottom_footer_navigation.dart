import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/learn_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/menu_screen.dart';

import '../../helpers/socket_helper.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../dashboard/dashboard.dart';
import 'homework_screen.dart';

class BottomNavPage {
  final String label;
  final Widget widget;
  final Color color;
  final String activeIcon;
  final String inactiveIcon;

  BottomNavPage(this.label, this.widget, this.color, this.activeIcon, this.inactiveIcon);
}

class BottomFooterNavigation extends StatefulWidget {
  const BottomFooterNavigation({Key? key, this.selectedIndex = 0}) : super(key: key);
  final int selectedIndex;

  @override
  _BottomFooterNavigationState createState() => _BottomFooterNavigationState();
}

class _BottomFooterNavigationState extends State<BottomFooterNavigation> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final List _pages = [
    BottomNavPage(
      'Dashboard',
      const DashboardPage(),
      colorSky,
      imageAssets + 'footer/dashboard_icon_active.svg',
      imageAssets + 'footer/dashboard_icon_inactive.svg',
    ),
    BottomNavPage(
      'Learn',
      const LearnPage(),
      colorPink,
      imageAssets + 'footer/learn.svg',
      imageAssets + 'footer/learn_inactive_icon.svg',
    ),
    BottomNavPage(
      'Homework',
      const Homeworkscreen(title: ""),
      colorPurple,
      imageAssets + 'footer/homework_active_icon.svg',
      imageAssets + 'footer/homework_inactive_icon.svg',
    ),
    // BottomNavPage(
    //   'Tests',
    //   const TestsPage(title: ""),
    //   colorOrange,
    //   imageAssets + 'footer/test.svg',
    //   imageAssets + 'footer/test_inactive_icon.svg',
    // ),
    // BottomNavPage(
    //   'Worksheet',
    //   const WorksheetPage(title: ""),
    //   colorGreen,
    //   imageAssets + 'footer/worksheet.svg',
    //   imageAssets + 'footer/worksheet_inactive_icon.svg',
    // ),
    BottomNavPage(
      'Menu',
      const MenuScreenPage(),
      colorGreen,
      imageAssets + 'footer/menu_active_icon.svg',
      imageAssets + 'footer/menu_inactive_icon.svg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // init all socket
    Future.delayed(Duration.zero, () {
      initSocketConnectionForApp();
    });

    setState(() {
      _selectedIndex = widget.selectedIndex;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        connectToAnalyticsSocketServer();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        disconnectAnalyticsSocket();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex].widget,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _pages[_selectedIndex].color,
        selectedLabelStyle: textTitle10BoldStyle,
        unselectedLabelStyle: textTitle10BoldStyle,
        items: _pages.mapIndexed((index, page) {
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == index ? page.activeIcon : page.inactiveIcon,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
            label: page.label,
          );
        }).toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
