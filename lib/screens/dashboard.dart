import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'navbar.dart';
import '../models/vocab.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({required Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 300,
        height: 100,
        child: Center(
          child: TextField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            autofocus: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: ''),
          ),
        ),
      ),
    );
  }
}

void test() {
  print("Test");
}