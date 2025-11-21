/// Main navigation wrapper with bottom navigation bar
library;

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../features/restaurant/presentation/screens/home_screen.dart';
import '../../features/order/presentation/screens/my_orders_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  
  const MainNavigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;
  
  final List<Widget> _screens = const [
    HomeScreen(),
    MyOrdersScreen(),
    ProfileScreen(),
  ];
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    AppLogger.lifecycle('MainNavigation', 'initState - starting at index $_currentIndex');
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            AppLogger.navigation(
              'MainNavigation',
              _getScreenName(index),
            );
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDarkMode
              ? AppColors.darkCardBackground
              : Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: isDarkMode
              ? AppColors.darkTextSecondary
              : AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
  
  String _getScreenName(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Orders';
      case 2:
        return 'Profile';
      default:
        return 'Unknown';
    }
  }
}

