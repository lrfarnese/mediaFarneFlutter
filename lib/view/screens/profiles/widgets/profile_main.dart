import 'package:flutter/material.dart';
import 'package:mediafarnetcc/model/user_local_storage_service.dart';
import 'package:mediafarnetcc/model/classes/user_profile.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({super.key});

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  UserProfile? _userProfile;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final perfil = await UserLocalStorageService.carregarUserProfile();
    setState(() {
      _userProfile = perfil;
      _carregando = false;
    });
  }

  // Converte 1200 -> "1,2K", 950 -> "950"
  String _formatarContador(int valor) {
    if (valor >= 1000) {
      final double milhar = valor / 1000;
      return '${milhar.toStringAsFixed(1).replaceAll('.', ',')}K';
    }
    return valor.toString();
  }

  // Converte "1998-03-15" -> "15/03/1998"
  String _formatarData(String dataIso) {
    try {
      final data = DateTime.parse(dataIso);
      return '${data.day.toString().padLeft(2, '0')}/'
          '${data.month.toString().padLeft(2, '0')}/'
          '${data.year}';
    } catch (_) {
      return dataIso;
    }
  }

  // Converte "2023-01-01T00:00:00.000" -> "Jan 2023"
  String _formatarMesAno(String dataIso) {
    const meses = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    try {
      final data = DateTime.parse(dataIso);
      return '${meses[data.month - 1]} ${data.year}';
    } catch (_) {
      return dataIso;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_userProfile == null) {
      return const Center(child: Text('Nenhum perfil encontrado.'));
    }

    final perfil = _userProfile!;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          // ---- AVATAR + NOME ----
          Row(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.black,
                backgroundImage: perfil.urlFotoPerfil.isNotEmpty
                    ? NetworkImage(perfil.urlFotoPerfil)
                    : null,
                child: perfil.urlFotoPerfil.isEmpty
                    ? const Icon(Icons.person, color: Colors.white, size: 45)
                    : null,
              ),

              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    perfil.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${perfil.username}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ---- DIVISOR ----
          const Divider(height: 1, color: AppColors.dark),

          const SizedBox(height: 16),

          // ---- STATS: POSTS | SEGUIDORES | SEGUINDO ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _status(_formatarContador(perfil.qtdPosts), 'Posts'),
              _status(_formatarContador(perfil.qtdSeguidores), 'Seguidores'),
              _status(_formatarContador(perfil.qtdSeguindo), 'Seguindo'),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.dark),
          const SizedBox(height: 12),

          // ---- INFORMAÇÕES ----
          _informacoes(Icons.cake, 'Nascimento: ${_formatarData(perfil.dataNascimento)}'),
          _informacoes(Icons.calendar_today, 'Membro desde: ${_formatarMesAno(perfil.dataCriacao)}'),

        ],
      ),
    );
  }

  Widget _status(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _informacoes(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}