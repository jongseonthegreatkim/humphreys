import 'package:flutter/material.dart';
import 'widgets.dart';
import 'home_screens/map_screen.dart';
import 'home_screens/routes_screen.dart';
import 'home_screens/favorites_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTab = 0;

  List<Widget> _pages = [
    const RoutesScreen(),
    const MapScreen(),
    const FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentTab],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentTab,
        // 선택된 탭의 글자 색상을 humphreysRed로 설정
        selectedItemColor: Widgets.humphreysRed,
        // 선택되지 않은 탭의 글자 색상을 humphreysBlack으로 설정
        unselectedItemColor: Widgets.humphreysBlack,
        // 선택된 탭의 글자 크기와 선택되지 않은 탭의 글자 크기를 동일하게 설정
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.route_outlined, color: Widgets.humphreysBlack),
            activeIcon: Icon(Icons.route, color: Widgets.humphreysRed),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined, color: Widgets.humphreysBlack),
            activeIcon: Icon(Icons.map, color: Widgets.humphreysRed),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, color: Widgets.humphreysBlack),
            activeIcon: Icon(Icons.favorite, color: Widgets.humphreysRed),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}