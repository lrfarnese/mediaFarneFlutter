import 'package:mediafarnetcc/model/classes/user_profile.dart';
import 'package:mediafarnetcc/model/user_local_storage_service.dart';
import 'package:mediafarnetcc/services/auth_api_service.dart';
import 'package:mediafarnetcc/services/profile_api_service.dart';

class ProfileController {
  final AuthApiService _authApi = AuthApiService();
  final ProfileApiService _perfilApi = ProfileApiService();

  Future<UserProfile?> carregarPerfilLocal() {
    return UserLocalStorageService.carregarUserProfile();
  }


  Future<UserProfile> atualizarPerfil() async {
    final perfil = await _authApi.me();
    await UserLocalStorageService.salvarUserProfile(perfil);
    return perfil;
  }

  static List<UserProfile> amigosCarregados = [];

  Future<List<UserProfile>> carregarAmigos() async {
    final amigos = await _perfilApi.listarSeguindo();
    amigosCarregados = amigos;
    return amigos;
  }

  static void limpar() {
    amigosCarregados = [];
  }


}