import 'package:flutter/material.dart';
import 'package:mediafarnetcc/controller/auth_controller.dart';
import 'package:mediafarnetcc/model/classes/auth_user.dart';
import 'package:mediafarnetcc/view/screens/auth/login_screen.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';
import 'package:mediafarnetcc/view/screens/splash/splash2.dart';


class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {

  final authController = AuthController();

  @override
  void initState() {
    super.initState();
    _iniciar();
  }
  Future<void> _iniciar() async {
    final tempoMinimo = Future.delayed(const Duration(seconds: 4));

    AuthUser? usuario;
    try {
      usuario = await authController.verificaLogin();
    } catch (_) {
      usuario = null; // qualquer erro inesperado: manda para o login
    }

    await tempoMinimo; // garante que a splash apareça pelo menos 4s
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
        usuario == null ? const LoginScreen() : const Splash2(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E90FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // ---- LOGO ----
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.play_circle_fill_rounded,
                color: AppColors.azulPrincipal,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            // ---- NOME DO APP ----
            const Text(
              'MediaFarne',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 8),



            const SizedBox(height: 50),

            // ---- BARRA DE PROGRESSO ----
            const CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 3,
            ),

          ],
        ),
      ),
    );
  }
}