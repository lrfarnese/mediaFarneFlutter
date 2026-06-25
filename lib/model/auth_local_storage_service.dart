import 'package:mediafarnetcc/model/classes/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorageService {

  static const  AUTH_USER = 'auth_user';

  // Salvar o usuário autenticado
  static Future<void> salvarAuthUser(AuthUser auth) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = auth.encode();
    await prefs.setString(AUTH_USER, encodedData);
  }

  // Recuperar o usuário autenticado (ou null se não houver login salvo)
  static Future<AuthUser?> carregarAuthUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authJson = prefs.getString(AUTH_USER);

    if (authJson == null) return null;

    return AuthUser.decode(authJson);
  }

  // Remover o usuário autenticado (logout)
  static Future<void> removerAuthUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(AUTH_USER);
  }
}