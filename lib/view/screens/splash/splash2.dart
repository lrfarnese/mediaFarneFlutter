import 'package:flutter/material.dart';
import 'package:mediafarnetcc/controller/auth_controller.dart';
import 'package:mediafarnetcc/controller/feed_controller.dart';
import 'package:mediafarnetcc/view/screens/auth/login_screen.dart';
import 'package:mediafarnetcc/view/screens/main/main_screen.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';
import 'package:mediafarnetcc/services/api_client.dart';
import 'package:mediafarnetcc/controller/profile_controller.dart';

class Splash2 extends StatefulWidget {
  const Splash2({super.key});

  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  final authController = AuthController();
  final feedController = FeedController();
  final profileController = ProfileController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      await carregaDadosAPI();
    });
  }

  Future<void> carregaDadosAPI() async {
    final usuario = await authController.verificaLogin();
    if (!mounted) return;

    if (usuario == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }

    try {
      final posts = await feedController.carregarFeed();
      debugPrint('Posts carregados: ${posts.length}');
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        // Token inválido: limpa a sessão e volta ao login
        await authController.logout();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      }
      debugPrint('ERRO AO CARREGAR FEED: ${e.message}');
    } catch (e, stack) {
      debugPrint('ERRO AO CARREGAR FEED: $e');
      debugPrint('$stack');
    }try {
      final amigos = await profileController.carregarAmigos();
      debugPrint('Amigos carregados: ${amigos.length}');
    } catch (e) {
      // Se falhar, o carrossel só fica vazio e o app continua normalmente
      debugPrint('ERRO AO CARREGAR AMIGOS: $e');
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
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