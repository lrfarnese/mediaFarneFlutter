import 'package:flutter/material.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{

  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.azulPrincipal,
      title: Image.asset(
          'assets/images/logo.png',
          width: 200,
          height: 180,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}