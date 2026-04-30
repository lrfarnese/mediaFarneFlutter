import 'package:flutter/material.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';
import 'package:mediafarnetcc/view/screens/splash/splash1.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{

  const AppBarWidget({super.key});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Splash1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.azulPrincipal,
      title: Image.asset(
        'assets/images/logo.png',
        height: kToolbarHeight * 0.8,
        fit: BoxFit.contain,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.white),
          tooltip: 'Sair',
          onPressed: () => _logout(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
