import 'package:flutter/material.dart';
import 'package:mediafarnetcc/view/screens/feed/widgets/avatar_list.dart';
import 'package:mediafarnetcc/view/screens/feed/widgets/posts_list.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        // 1. AvatarList com altura fixa
        AvatarList(),

        // 2. Expanded obriga o PostsList a ocupar todo o espaço restante na tela
        Expanded(
          child: PostsList(),
        ),
      ],
    );
  }
}