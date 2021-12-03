import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'navbar.dart';
import '../models/vocab.dart';

class Settings extends StatefulWidget {
  const Settings({required Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  double _currentDifficulty = 5;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentDifficulty,
      min: 0,
      max: 5,
      divisions: 4,
      label: "N" + _currentDifficulty.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentDifficulty = value;
        });
      },
    );
  }
}
