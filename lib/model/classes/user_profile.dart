import 'dart:convert';

class UserProfile {
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

  String encode() => json.encode(toMap());

  static UserProfile decode(String userProfileJson) =>
      UserProfile.fromMap(json.decode(userProfileJson) as Map<String, dynamic>);
}