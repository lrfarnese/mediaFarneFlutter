import 'package:mediafarnetcc/model/classes/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorageService {

  static const USER_PROFILE = 'user_profile';

  // Salvar o perfil do usuário
  static Future<void> salvarUserProfile(UserProfile userProfile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = userProfile.encode();
    await prefs.setString(USER_PROFILE, encodedData);
  }

  // Recuperar o perfil do usuário (ou null se não houver nada salvo)
  static Future<UserProfile?> carregarUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userProfileJson = prefs.getString(USER_PROFILE);

    if (userProfileJson == null) return null;

    return UserProfile.decode(userProfileJson);
  }

  // Remover o perfil do usuário (logout)
  static Future<void> removerUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(USER_PROFILE);
  }

}