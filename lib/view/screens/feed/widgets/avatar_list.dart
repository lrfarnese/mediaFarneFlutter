import 'package:flutter/material.dart';

class AvatarList extends StatefulWidget {
  const AvatarList({super.key});

  @override
  State<StatefulWidget> createState() => _AvatarListState();
}

class _AvatarListState extends State<AvatarList> {
  final List<String> _names = [
    'Ana', 'Carlos', 'Beatriz', 'Diego', 'Fernanda', 'Gabriel', 'Helena',
  ];

  void _alertPerfil(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(Icons.person, color: Colors.blue),
            SizedBox(width: 10),
            Text(
              "Informações Perfil",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              leading: Icon(Icons.badge),
              title: Text("Nome"),
              subtitle: Text("Lucas Farnese"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.portrait_sharp),
              title: Text('Quantidade de Posts'),
              subtitle: Text('12'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Seguidores"),
              subtitle: Text("1.234"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Conta criada em"),
              subtitle: Text("10/03/2024"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _names.length,
        itemBuilder: (context, index) {
          return Padding(

            padding: const EdgeInsets.only(right: 12,top: 5),
            child: GestureDetector(
              onTap:() => _alertPerfil(context),
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  _names[index],
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
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