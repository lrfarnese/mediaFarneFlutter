import 'package:mediafarnetcc/model/classes/post.dart';
import 'package:mediafarnetcc/services/api_client.dart';

/// Resultado de POST /posts/{id}/interaction
class ReacaoResultado {
  final int postId;
  final int likes;
  final int dislikes;

  /// 'Like', 'Deslike' ou null (reação removida)
  final String? userReaction;

  const ReacaoResultado({
    required this.postId,
    required this.likes,
    required this.dislikes,
    required this.userReaction,
  });

  factory ReacaoResultado.fromMap(Map<String, dynamic> map) {
    return ReacaoResultado(
      postId: (map['post_id'] as num).toInt(),
      likes: (map['likes'] as num).toInt(),
      dislikes: (map['dislikes'] as num).toInt(),
      userReaction: map['user_reaction'] as String?,
    );
  }

  bool get curtiu => userReaction == 'Like';
  bool get descurtiu => userReaction == 'Deslike';
}

class FeedApiService {
  final ApiClient _api = ApiClient();

  /// GET /posts: lista de posts, do mais recente para o mais antigo.
  Future<List<Post>> listarPosts() async {
    final resposta = await _api.get('/posts');

    final lista = resposta['data'] as List;

    return lista
        .map((item) => Post.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  /// POST /posts/{id}/interaction
  ///  deve ser 'Like' ou 'Deslike' (como o Laravel valida).
  /// Enviar o mesmo tipo duas vezes remove a reação (toggle no servidor).
  Future<ReacaoResultado> reagir(int postId, String tipo) async {
    final resposta = await _api.post(
      '/posts/$postId/interaction',
      body: {'type': tipo},
    );

    return ReacaoResultado.fromMap(
      resposta['data'] as Map<String, dynamic>,
    );
  }
}