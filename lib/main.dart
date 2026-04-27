import 'package:flutter/material.dart';
import 'package:mediafarnetcc/view/screens/auth/login_screen.dart';
import 'package:mediafarnetcc/view/screens/feed/feed_screen.dart';
import 'package:mediafarnetcc/view/screens/main/main_screen.dart';
import 'package:mediafarnetcc/view/screens/splash/splash1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.white),
      ),

      home: const Splash1(),
    );
  }
}


