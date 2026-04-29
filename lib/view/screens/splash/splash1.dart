import 'package:flutter/material.dart';
import 'package:mediafarnetcc/view/screens/auth/login_screen.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';


class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
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