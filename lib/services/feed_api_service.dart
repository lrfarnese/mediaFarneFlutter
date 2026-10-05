import 'package:mediafarnetcc/model/classes/post.dart';
import 'package:mediafarnetcc/services/api_client.dart';

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
}