import 'package:mediafarnetcc/model/classes/auth_user.dart';
import 'package:mediafarnetcc/model/classes/user_profile.dart';
import 'package:mediafarnetcc/services/api_client.dart';

class AuthApiService {
  final ApiClient _api = ApiClient();

  /// Faz login. Devolve o AuthUser (com o token) e o UserProfile.
  Future<({AuthUser auth, UserProfile profile})> login({
    required String email,
    required String password,
  }) async {
    final resposta = await _api.post(
      '/login',
      body: {
        'email': email,
        'password': password,
      },
      comAuth: false, // ainda não temos token, então não envia
    );

    // O Laravel coloca tudo dentro de "data"
    final dados = resposta['data'] as Map<String, dynamic>;

    final auth = AuthUser(
      email: email,
      tokenAuth: dados['token'] as String,
      dataHoraLogin: DateTime.now().toIso8601String(),
    );

    final profile = _montarPerfil(dados['user'] as Map<String, dynamic>);

    return (auth: auth, profile: profile);
  }

  /// Busca os dados do usuário logado. O token vai sozinho (interceptor).
  Future<UserProfile> me() async {
    final resposta = await _api.get('/me');

    // Aceita {data: {user: {...}}}, {data: {...}} ou {user: {...}}
    final dados = (resposta['data'] ?? resposta) as Map<String, dynamic>;
    final usuario = (dados['user'] ?? dados) as Map<String, dynamic>;

    return _montarPerfil(usuario);
  }

  /// Avisa o Laravel para invalidar o token. O token vai sozinho.
  Future<void> logout() async {
    await _api.post('/logout');
  }

  /// Converte o JSON do Laravel para o seu UserProfile.
  UserProfile _montarPerfil(Map<String, dynamic> json) {
    return UserProfile.fromMap({
      'email': json['email'],
      'name': json['name'],
      'username': json['username'],
      'dataNascimento': json['data_nascimento'],
      'qtdPosts': json['posts_count'],
      'qtdSeguidores': json['seguidores_count'],   // era followers_count
      'qtdSeguindo': json['seguindo_count'],
      'urlFotoPerfil': _montarUrlFoto(json['url_foto_perfil']),
      'dataCriacao': json['created_at'],
    });
  }

  /// O Laravel devolve só o caminho ("foto_perfis/abc.jpg").
  /// O app precisa do endereço completo para mostrar a imagem.
  String _montarUrlFoto(dynamic caminho) {
    if (caminho == null || caminho.toString().isEmpty) return '';
    final texto = caminho.toString();
    return texto.startsWith('http')
        ? texto
        : 'http://mediafarne.test/storage/$texto';
  }
}