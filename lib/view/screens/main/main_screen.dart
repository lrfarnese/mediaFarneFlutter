import 'package:flutter/material.dart';
import 'package:mediafarnetcc/view/screens/feed/feed_screen.dart';
import 'package:mediafarnetcc/view/screens/main/widgets/app_bar_widget.dart';
import 'package:mediafarnetcc/view/screens/main/widgets/bottom_navigation_widget.dart';
import 'package:mediafarnetcc/view/screens/profiles/profile_screen.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(),

      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),

    );
  }
}