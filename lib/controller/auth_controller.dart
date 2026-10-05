import 'package:mediafarnetcc/controller/profile_controller.dart';
import 'package:mediafarnetcc/model/auth_local_storage_service.dart';
import 'package:mediafarnetcc/model/classes/auth_user.dart';
import 'package:mediafarnetcc/model/user_local_storage_service.dart';
import 'package:mediafarnetcc/services/api_client.dart';
import 'package:mediafarnetcc/services/auth_api_service.dart';
import 'package:mediafarnetcc/controller/feed_controller.dart';

class AuthController {
  final AuthApiService _authApi = AuthApiService();

  /// Usado pela Splash: existe uma sessão válida?
  Future<AuthUser?> verificaLogin() async {
    final authLocal = await AuthLocalStorageService.carregarAuthUser();

    // Nunca logou neste aparelho
    if (authLocal == null) return null;

    try {
      // Pergunta ao Laravel se o token ainda vale
      final perfil = await _authApi.me();
      await UserLocalStorageService.salvarUserProfile(perfil); // atualiza o cache
      return authLocal;
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        // Token expirado ou revogado: limpa tudo
        await _limparSessaoLocal();
        return null;
      }
      // Sem conexão ou erro do servidor: segue com os dados salvos
      return authLocal;
    }
  }

  /// Retorna o AuthUser se logou, ou null se e-mail/senha estão errados.
  Future<AuthUser?> realizaLogin(String email, String senha) async {
    try {
      final resultado = await _authApi.login(email: email, password: senha);

      // Só chega aqui se o login deu certo
      await AuthLocalStorageService.salvarAuthUser(resultado.auth);
      await UserLocalStorageService.salvarUserProfile(resultado.profile);

      return resultado.auth;
    } on ApiException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 422) {
        return null; // credenciais inválidas
      }
      rethrow; // sem conexão, erro 500 etc.: a tela decide o que mostrar
    }
  }

  Future<void> logout() async {
    try {
      // IMPORTANTE: antes de apagar o token local, pois o interceptor lê dele
      await _authApi.logout();
    } catch (_) {
      // Se a API falhar, o logout local acontece mesmo assim
    }
    await _limparSessaoLocal();
  }

  Future<void> _limparSessaoLocal() async {
    await AuthLocalStorageService.removerAuthUser();
    await UserLocalStorageService.removerUserProfile();
    FeedController.limpar();
    ProfileController.limpar();
  }
}