
import 'package:mediafarnetcc/model/auth_local_storage_service.dart';
import 'package:mediafarnetcc/model/classes/auth_user.dart';

class AuthController {


  Future<AuthUser?> _apiAuth(String email, String senha) async{

    if(email == 'lucas@teste.com' && senha == '123456'){
      return AuthUser(
        id: 1,
        email: email,
        tokenAuth: 'tokenFake',
        dataHoraLogin: DateTime.now().toIso8601String(),
      );
    }
    return null;

  }

  Future<AuthUser?> verificaLogin() async {
    return await AuthLocalStorageService.carregarAuthUser();
  }

  Future<AuthUser?> realizaLogin(String email, String senha) async {
    final AuthUser? usuarioAutenticado = await _apiAuth(email, senha);

    if (usuarioAutenticado == null) {
      return null;
    }
    await AuthLocalStorageService.salvarAuthUser(usuarioAutenticado);
    return usuarioAutenticado;
  }

}