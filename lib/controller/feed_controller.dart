import 'package:mediafarnetcc/model/classes/post.dart';
import 'package:mediafarnetcc/services/feed_api_service.dart';

class FeedController {
  final FeedApiService _feedApi = FeedApiService();

  /// Lista guardada na memória para qualquer tela ler depois de carregada.
  static List<Post> postsCarregados = [];

  /// Busca os posts no Laravel e guarda em postsCarregados.
  /// Não precisa receber o token: o ApiClient já o envia sozinho.
  Future<List<Post>> carregarFeed() async {
    final posts = await _feedApi.listarPosts();
    postsCarregados = posts;
    return posts;
  }
  static void limpar() {
    postsCarregados = [];
  }

}