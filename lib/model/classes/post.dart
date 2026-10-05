class PostAutor {
  final int id;
  final String name;
  final String username;
  final String urlFotoPerfil;

  PostAutor({
    required this.id,
    required this.name,
    required this.username,
    required this.urlFotoPerfil,
  });

  factory PostAutor.fromMap(Map<String, dynamic> map) {
    return PostAutor(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      urlFotoPerfil: Post.montarUrl(map['url_foto_perfil']),
    );
  }
}

class Post {
  final int id;
  final String conteudo;
  final PostAutor autor;
  final List<String> imagens;
  final int qtdLikes;
  final int qtdDislikes;
  final String? minhaReacao; 
  final String dataCriacao;

  Post({
    required this.id,
    required this.conteudo,
    required this.autor,
    required this.imagens,
    required this.qtdLikes,
    required this.qtdDislikes,
    required this.minhaReacao,
    required this.dataCriacao,
  });

  bool get curtiu => minhaReacao == 'Like';
  bool get descurtiu => minhaReacao == 'Deslike';

  static const String _storageUrl = 'http://mediafarne.test/storage/';


  static String montarUrl(dynamic caminho) {
    if (caminho == null || caminho.toString().isEmpty) return '';
    final texto = caminho.toString();
    return texto.startsWith('http') ? texto : '$_storageUrl$texto';
  }
  String get tempoRelativo {
    final data = DateTime.tryParse(dataCriacao);
    if (data == null) return '';

    final diff = DateTime.now().toUtc().difference(data.toUtc());

    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'há ${diff.inHours} h';
    if (diff.inDays < 7) return 'há ${diff.inDays} d';

    final local = data.toLocal();
    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');
    return '$dia/$mes/${local.year}';
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    final listaImagens = (map['images'] as List? ?? [])
        .map((img) => montarUrl(img['path'] ?? img['url'] ?? img['caminho']))
        .where((url) => url.isNotEmpty)
        .toList();

    return Post(
      id: map['id'] ?? 0,
      conteudo: map['content'] ?? map['conteudo'] ?? map['texto'] ?? '',
      autor: PostAutor.fromMap(map['user'] as Map<String, dynamic>? ?? {}),
      imagens: listaImagens,
      qtdLikes: map['likes_count'] ?? 0,
      qtdDislikes: map['dislikes_count'] ?? 0,
      minhaReacao: map['user_reaction'],
      dataCriacao: map['created_at'] ?? '',
    );
  }
}