import 'package:flutter/material.dart';
import 'package:mediafarnetcc/controller/auth_controller.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';
import 'package:mediafarnetcc/view/screens/auth/login_screen.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  Future<void> _logout(BuildContext context) async {
    // 1) Confirmação
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmou != true || !context.mounted) return;

    // 2) Loading enquanto o Laravel invalida o token
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    // 3) Logout (API + limpeza local)
    await AuthController().logout();

    if (!context.mounted) return;

    // 4) Vai direto ao login e remove todas as telas anteriores
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
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