import 'package:flutter/material.dart';

import 'navbar.dart';
import '../models/vocab.dart';

class Home extends StatefulWidget {
  const Home({required Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
