import 'package:app/game/kanji_learning_game.dart';
import 'package:flutter/material.dart';
import 'game/kanji_learning_game.dart';
import 'screens/dashboard.dart';
import 'screens/navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: NavBar(),
    );
  }
}
