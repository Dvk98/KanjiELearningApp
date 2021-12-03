import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

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
    return Scaffold(
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: "Kanji Learning Game\n\n\n",
                style: TextStyle(color: Colors.blue[100], fontSize: 60,),
              ),
              TextSpan(
                text: "カンジ     ",
                style: TextStyle(color: Colors.red[200], fontSize: 50,),
              ),
              TextSpan(
                text: "漢字\n\n\n",
                style: TextStyle(color: Colors.green[200], fontSize: 50,),
              ),
              TextSpan(
                text: "The Kanji Learning Game is made to teach reading\nKanji characters faster by asking to translate them\nto Hiragana characters. Get as many Kanji right as\npossible to increase your high score!",
                style: TextStyle(color: Colors.white.withOpacity(1.0), fontSize: 20,),
              ),
            ],
          ),
        )
      ),
    );
  }
}
