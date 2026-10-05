import 'package:flutter/material.dart';
import 'package:mediafarnetcc/controller/auth_controller.dart';
import 'package:mediafarnetcc/view/screens/splash/splash2.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';
import 'package:mediafarnetcc/services/api_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final authController = AuthController();

  bool _carregando = false;     // true enquanto espera o servidor
  String? _mensagemErro;

  Widget erroAutenticacao() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
        child: Text(
          _mensagemErro!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> irMain() async {
    if (_carregando) return; // evita tocar duas vezes

    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final usuarioVerificado = await authController.realizaLogin(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (usuarioVerificado == null) {
        // O Laravel respondeu 401/422: e-mail ou senha errados
        setState(() => _mensagemErro = 'Usuário ou senha inválidos');
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Splash2()),
        );
      }
    } on ApiException catch (e) {
      // Sem conexão, erro 500 etc.
      if (!mounted) return;
      setState(() => _mensagemErro = e.message);
    } catch (e, stack) {
      debugPrint('ERRO NO LOGIN: $e');
      debugPrint('$stack');
      if (!mounted) return;
      setState(() => _mensagemErro = 'Erro inesperado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 60),

              // logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E90FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),

              const SizedBox(height: 20),

              // titulo
              const Text(
                'MediaFarne',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 6),


              const SizedBox(height: 50),



              // input email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,

                style: const TextStyle(color: AppColors.white),

                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: "E-Mail",
                  labelStyle: const TextStyle(color: AppColors.white),
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.white),
                  filled: true,
                  fillColor: AppColors.dark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.azulPrincipal, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // input senha
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Senha',
                  labelStyle: const TextStyle(color: AppColors.white),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  filled: true,
                  fillColor: AppColors.dark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.azulPrincipal, width: 2),
                  ),
                ),
              ),


              if (_mensagemErro != null) erroAutenticacao(),
              const SizedBox(height: 36),

              // ---- BOTÃO ENTRAR ----
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _carregando ? null : irMain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azulForms,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _carregando
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),


            ],
          ),
        ),
      ),
    );
  }

}