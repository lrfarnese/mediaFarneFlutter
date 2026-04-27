import 'package:flutter/material.dart';
import 'package:mediafarnetcc/view/screens/profiles/widgets/profile_main.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ProfileMain(),
      ],
    );

  }
}