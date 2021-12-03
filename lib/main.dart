import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'screens/navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Flame.device.setPortraitUpOnly();
    return MaterialApp(
      title: 'KanjiLearningApp',
      theme: ThemeData.dark(),
      home: NavBar(),
    );
  }
}
