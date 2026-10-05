import 'dart:convert';
import 'package:mediafarnetcc/model/classes/post.dart';

class UserProfile {
  final int id;
  final String email;
  final String name;
  final String username;
  final String dataNascimento;
  final int qtdPosts;
  final int qtdSeguidores;
  final int qtdSeguindo;
  final String urlFotoPerfil;
  final String dataCriacao;

  UserProfile({
    this.id = 0,
    required this.email,
    required this.name,
    required this.username,
    required this.dataNascimento,
    required this.qtdPosts,
    required this.qtdSeguidores,
    required this.qtdSeguindo,
    required this.urlFotoPerfil,
    required this.dataCriacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'dataNascimento': dataNascimento,
      'qtdPosts': qtdPosts,
      'qtdSeguidores': qtdSeguidores,
      'qtdSeguindo': qtdSeguindo,
      'urlFotoPerfil': urlFotoPerfil,
      'dataCriacao': dataCriacao,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? 0,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      dataNascimento: map['dataNascimento'] ?? '',
      qtdPosts: map['qtdPosts'] ?? 0,
      qtdSeguidores: map['qtdSeguidores'] ?? 0,
      qtdSeguindo: map['qtdSeguindo'] ?? 0,
      urlFotoPerfil: map['urlFotoPerfil'] ?? '',
      dataCriacao: map['dataCriacao'] ?? '',
    );
  }

  factory UserProfile.fromApi(Map<String, dynamic> json) {
    // Tratamento seguro da URL da foto de perfil
    final rawFoto = json['url_foto_perfil'];
    final String fotoUrlTratada = (rawFoto != null && rawFoto.toString().isNotEmpty)
        ? Post.montarUrl(rawFoto.toString())
        : '';

    return UserProfile(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',                  // Não vem no /seguindo
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      dataNascimento: json['data_nascimento'] ?? '', // Não vem no /seguindo
      qtdPosts: json['posts_count'] ?? 0,
      qtdSeguidores: json['seguidores_count'] ?? 0,
      qtdSeguindo: json['seguindo_count'] ?? 0,
      urlFotoPerfil: fotoUrlTratada,
      dataCriacao: json['created_at'] ?? '',
    );
  }

  String get primeiroNome {
    final partes = name.trim().split(' ');
    return partes.first.isEmpty ? username : partes.first;
  }

  String get contaCriadaFormatada {
    final d = DateTime.tryParse(dataCriacao);
    if (d == null) return '-';
    final local = d.toLocal();
    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');
    return '$dia/$mes/${local.year}';
  }

  String encode() => json.encode(toMap());

  static UserProfile decode(String userProfileJson) =>
      UserProfile.fromMap(json.decode(userProfileJson) as Map<String, dynamic>);
}