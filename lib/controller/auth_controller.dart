import 'package:mediafarnetcc/model/auth_local_storage_service.dart';
import 'package:mediafarnetcc/model/classes/auth_user.dart';
import 'package:mediafarnetcc/model/classes/user_profile.dart';
import 'package:mediafarnetcc/model/user_local_storage_service.dart';

class AuthController {

  Future<Map<String, dynamic>?> _apiAuth(String email, String senha) async {
    if (email == 'lucas@teste.com' && senha == '123456') {
      return {
        'auth': AuthUser(
          email: email,
          tokenAuth: 'tokenFake',
          dataHoraLogin: DateTime.now().toIso8601String(),
        ),
        'profile': UserProfile(
          email: email,
          name: 'Lucas Farnese',
          username: 'Farnesinho',
          dataNascimento: '1998-03-15',
          qtdPosts: 3,
          qtdSeguidores: 67,
          qtdSeguindo: 67,
          urlFotoPerfil: '',
          dataCriacao: '18/02/2066',
        ),
      };
    }
    return null;
  }

  Future<AuthUser?> verificaLogin() async {
    return await AuthLocalStorageService.carregarAuthUser();
  }

  Future<AuthUser?> realizaLogin(String email, String senha) async {
    final respostaApi = await _apiAuth(email, senha);

    if (respostaApi == null) {
      return null;
    }

    final AuthUser usuarioAutenticado = respostaApi['auth'];
    final UserProfile perfilUsuario = respostaApi['profile'];

    await AuthLocalStorageService.salvarAuthUser(usuarioAutenticado);
    await UserLocalStorageService.salvarUserProfile(perfilUsuario);

    return usuarioAutenticado;
  }

  Future<void> logout() async {
    await AuthLocalStorageService.removerAuthUser();
    await UserLocalStorageService.removerUserProfile();
  }

}