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
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          children: [Expanded(child: Text("TODO"))],
        ),
      ),
    );
  }
}
