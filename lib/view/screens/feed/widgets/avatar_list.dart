import 'package:flutter/material.dart';
import 'package:mediafarnetcc/controller/profile_controller.dart';
import 'package:mediafarnetcc/model/classes/user_profile.dart';
import 'package:mediafarnetcc/services/api_client.dart';

class AvatarList extends StatefulWidget {
  final UserProfile? meuPerfil;
  final List<UserProfile>? amigos;

  const AvatarList({
    super.key,
    this.meuPerfil,
    this.amigos,
  });

  @override
  State<AvatarList> createState() => _AvatarListState();
}

class _AvatarListState extends State<AvatarList> {
  final _profileController = ProfileController();

  // Perfil carregado aqui dentro, usado quando meuPerfil não é informado
  UserProfile? _meuPerfilCarregado;

  @override
  void initState() {
    super.initState();
    if (widget.meuPerfil == null) {
      _carregarMeuPerfil();
    }
  }

  Future<void> _carregarMeuPerfil() async {
    // 1) Mostra rápido o que está salvo no aparelho
    final local = await _profileController.carregarPerfilLocal();
    if (!mounted) return;
    if (local != null) {
      setState(() => _meuPerfilCarregado = local);
    }

    // 2) Atualiza com os dados do servidor
    try {
      final perfil = await _profileController.atualizarPerfil();
      if (!mounted) return;
      setState(() => _meuPerfilCarregado = perfil);
    } on ApiException {
      // mantém o perfil local se o servidor falhar
    }
  }

  Widget _avatarPadrao({bool isOwner = false}) {
    return Container(
      color: isOwner ? Colors.blue.shade50 : Colors.black,
      child: Icon(
        Icons.person,
        color: isOwner ? Colors.blue : Colors.white,
        size: 30,
      ),
    );
  }

  void _abrirInfos(BuildContext context, UserProfile amigo) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.person, color: Colors.blue),
            const SizedBox(width: 10),
            const Text('Infos Perfil'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _linhaInfo(Icons.badge, 'Nome',
                amigo.name.isNotEmpty ? amigo.name : amigo.username),
            const Divider(),
            _linhaInfo(Icons.alternate_email, 'Usuário', '@${amigo.username}'),
            const Divider(),
            _linhaInfo(Icons.article_outlined, 'Quantidade de Posts',
                amigo.qtdPosts.toString()),
            const Divider(),
            _linhaInfo(
                Icons.group, 'Seguidores', amigo.qtdSeguidores.toString()),
            const Divider(),
            _linhaInfo(Icons.calendar_today, 'Conta criada em',
                amigo.contaCriadaFormatada),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _linhaInfo(IconData icone, String titulo, String valor) {
    return Row(
      children: [
        Icon(icone, color: Colors.black54),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text(
                valor,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Amigos: construtor ou lista estática do controller
    final listaAmigos = widget.amigos ?? ProfileController.amigosCarregados;

    // 2. "Você": construtor > perfil carregado aqui > perfil padrão
    final perfilVoce = widget.meuPerfil ??
        _meuPerfilCarregado ??
        UserProfile(
          email: '',
          name: 'Você',
          username: 'voce',
          dataNascimento: '',
          qtdPosts: 0,
          qtdSeguidores: 0,
          qtdSeguindo: 0,
          urlFotoPerfil: '',
          dataCriacao: '',
        );

    // 3. Lista unificada ("Você" + Amigos)
    final List<UserProfile> listaExibicao = [perfilVoce, ...listaAmigos];

    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: listaExibicao.length,
        itemBuilder: (context, index) {
          final bool isOwner = index == 0;
          final perfil = listaExibicao[index];

          final bool temFoto = perfil.urlFotoPerfil.isNotEmpty &&
              perfil.urlFotoPerfil != 'null';

          return GestureDetector(
            // Abre modal apenas se for amigo (isOwner não abre modal)
            onTap: isOwner ? null : () => _abrirInfos(context, perfil),
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Anel / Borda em volta do Avatar
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isOwner
                              ? const LinearGradient(
                            colors: [Colors.blue, Colors.lightBlueAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : null,
                          border: !isOwner
                              ? Border.all(
                              color: Colors.grey.shade300, width: 2)
                              : null,
                        ),
                        child: ClipOval(
                          child: SizedBox(
                            width: 54,
                            height: 54,
                            child: temFoto
                                ? Image.network(
                              perfil.urlFotoPerfil,
                              webHtmlElementStrategy:
                              WebHtmlElementStrategy.prefer,
                              fit: BoxFit.cover,
                              errorBuilder: (context, erro, stack) =>
                                  _avatarPadrao(isOwner: isOwner),
                            )
                                : _avatarPadrao(isOwner: isOwner),
                          ),
                        ),
                      ),

                      // Estrelinha no canto para o seu perfil
                      if (isOwner)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.star,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isOwner ? 'Você' : perfil.primeiroNome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isOwner ? FontWeight.bold : FontWeight.normal,
                      color: isOwner ? Colors.blue : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}