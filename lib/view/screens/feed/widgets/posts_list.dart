import 'package:flutter/material.dart';
import 'package:mediafarnetcc/controller/feed_controller.dart';
import 'package:mediafarnetcc/model/classes/post.dart';
import 'package:mediafarnetcc/services/api_client.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<StatefulWidget> createState() => _PostlistState();
}

class _PostlistState extends State<PostsList> {
  Future<void> _atualizar() async {
    try {
      await FeedController().carregarFeed();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final posts = FeedController.postsCarregados;

    return Expanded(
      child: Container(
        color: const Color(0xFFF4F6F8),
        child: RefreshIndicator(
          onRefresh: _atualizar,
          color: AppColors.azulPrincipal,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              // ---- CABEÇALHO ----
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 14),
                child: Text(
                  'Feed Cronológico',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: Colors.black87,
                  ),
                ),
              ),

              // ---- LISTA VAZIA ----
              if (posts.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.inbox_outlined,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum post para mostrar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              // ---- POSTS ----
              for (final post in posts)
                PostItem(
                  key: ValueKey(
                    '${post.id}-${post.qtdLikes}-${post.qtdDislikes}-${post.minhaReacao}',
                  ),
                  post: post,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// POST INDIVIDUAL
// ============================================================

class PostItem extends StatefulWidget {
  final Post post;

  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late bool _curtida;
  late bool _descurtida;
  late int _qtdLikes;
  late int _qtdDislikes;

  @override
  void initState() {
    super.initState();
    // Estado e quantidades informados pelo Laravel
    _curtida = widget.post.curtiu;
    _descurtida = widget.post.descurtiu;
    _qtdLikes = widget.post.qtdLikes;
    _qtdDislikes = widget.post.qtdDislikes;
  }

  // Por enquanto só muda na tela. Ainda não envia ao Laravel.
  void _estadoCurtida() {
    setState(() {
      if (_curtida) {
        _curtida = false;
        _qtdLikes--;
        return;
      }
      if (_descurtida) {
        _descurtida = false;
        _qtdDislikes--;
      }
      _curtida = true;
      _qtdLikes++;
    });
  }

  void _estadoDescurtida() {
    setState(() {
      if (_descurtida) {
        _descurtida = false;
        _qtdDislikes--;
        return;
      }
      if (_curtida) {
        _curtida = false;
        _qtdLikes--;
      }
      _descurtida = true;
      _qtdDislikes++;
    });
  }

  Widget _avatarPadrao() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.person, color: Colors.grey[500], size: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ---- AUTOR + TEMPO ----
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 42,
                    height: 42,
                    child: post.autor.urlFotoPerfil.isNotEmpty
                        ? Image.network(
                      post.autor.urlFotoPerfil,
                      webHtmlElementStrategy:
                      WebHtmlElementStrategy.prefer,
                      fit: BoxFit.cover,
                      errorBuilder: (context, erro, stack) =>
                          _avatarPadrao(),
                    )
                        : _avatarPadrao(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.autor.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      if (post.tempoRelativo.isNotEmpty)
                        Text(
                          post.tempoRelativo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---- IMAGEM ----
          if (post.imagens.isNotEmpty)
            Image.network(
              post.imagens.first,
              webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
              height: 340,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progresso) {
                if (progresso == null) return child;
                return Container(
                  height: 340,
                  color: Colors.grey[100],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, erro, stack) => Container(
                height: 340,
                color: Colors.grey[100],
                child: Center(
                  child: Icon(Icons.broken_image_outlined,
                      size: 48, color: Colors.grey[400]),
                ),
              ),
            ),

          // ---- CURTIR / DESCURTIR ----
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              children: [
                _BotaoReacao(
                  iconeAtivo: Icons.favorite,
                  iconeInativo: Icons.favorite_border,
                  corAtiva: Colors.redAccent,
                  ativo: _curtida,
                  quantidade: _qtdLikes,
                  onTap: _estadoCurtida,
                ),
                const SizedBox(width: 10),
                _BotaoReacao(
                  iconeAtivo: Icons.heart_broken,
                  iconeInativo: Icons.heart_broken_outlined,
                  corAtiva: Colors.blueAccent,
                  ativo: _descurtida,
                  quantidade: _qtdDislikes,
                  onTap: _estadoDescurtida,
                ),
              ],
            ),
          ),

          // ---- LEGENDA ----
          if (post.conteudo.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: '${post.autor.username} ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: post.conteudo),
                  ],
                ),
              ),
            )
          else
            const SizedBox(height: 14),
        ],
      ),
    );
  }
}



class _BotaoReacao extends StatelessWidget {
  final IconData iconeAtivo;
  final IconData iconeInativo;
  final Color corAtiva;
  final bool ativo;
  final int quantidade;
  final VoidCallback onTap;

  const _BotaoReacao({
    required this.iconeAtivo,
    required this.iconeInativo,
    required this.corAtiva,
    required this.ativo,
    required this.quantidade,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cor = ativo ? corAtiva : Colors.black54;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: ativo
              ? corAtiva.withValues(alpha: 0.12)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: ativo ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                ativo ? iconeAtivo : iconeInativo,
                color: cor,
                size: 24,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$quantidade',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: cor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}