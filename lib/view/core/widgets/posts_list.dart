import 'package:flutter/material.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<StatefulWidget> createState() => _PostlistState();
}

class _PostlistState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Feed Cronológico",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          PostItem(username: 'usuario1', location: 'São Paulo, Brasil',   imageColor: Colors.red,      likes: 123, caption: 'Que dia incrível! '),
          PostItem(username: 'usuario2', location: 'Rio de Janeiro',       imageColor: Colors.green,    likes: 456, caption: 'Natureza é tudo '),
          PostItem(username: 'usuario3', location: 'Belo Horizonte',       imageColor: Colors.blue,     likes: 789, caption: 'Céu azul demais '),
          PostItem(username: 'usuario4', location: 'Curitiba',             imageColor: Colors.orange,   likes: 321, caption: 'Pôr do sol incrível '),
          PostItem(username: 'usuario5', location: 'Salvador',             imageColor: Colors.blueGrey, likes: 654, caption: 'Saudade do mar '),
        ],
      ),
    );
  }
}

// cada post tem seu próprio estado
class PostItem extends StatefulWidget {
  final String username;
  final String location;
  final Color imageColor;
  final int likes;
  final String caption;

  const PostItem({
    super.key,
    required this.username,
    required this.location,
    required this.imageColor,
    required this.likes,
    required this.caption,
  });

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool _curtida = false;
  bool _descurtida = false;

  void _estadoCurtida() {
    setState(() {
      _curtida = !_curtida;
      if (_curtida) _descurtida = false;
    });
  }

  void _estadoDescurtida() {
    setState(() {
      _descurtida = !_descurtida;
      if (_descurtida) _curtida = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Avatar + nome
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.username, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),

          // Imagem do post
          Container(height: 300, color: widget.imageColor),

          // Botões curtir / descurtir
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _estadoCurtida,
                  child: Icon(
                    _curtida ? Icons.favorite : Icons.favorite_border,
                    size: 28,
                    color: _curtida ? Colors.red : Colors.grey,
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: _estadoDescurtida,
                  child: Icon(
                    _descurtida ? Icons.heart_broken : Icons.heart_broken_outlined,
                    size: 26,
                    color: _descurtida ? Colors.blue : Colors.grey,
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),
          ),

          // Curtidas
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('${widget.likes} curtidas', style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          SizedBox(height: 4),

          // Legenda
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(text: '${widget.username} ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: widget.caption),
                ],
              ),
            ),
          ),

          SizedBox(height: 12),
        ],
      ),
    );
  }
}