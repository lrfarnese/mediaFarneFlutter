import 'package:mediafarnetcc/model/classes/user_profile.dart';
import 'package:mediafarnetcc/services/api_client.dart';

class ProfileApiService {
  final ApiClient _api = ApiClient();


  Future<List<UserProfile>> listarSeguindo() async {
    final resposta = await _api.get('/user/seguindo');

    final lista = resposta['data'] as List;

    return lista
        .map((item) => UserProfile.fromApi(item as Map<String, dynamic>))
        .toList();
  }
}