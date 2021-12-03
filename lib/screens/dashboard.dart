import 'package:flutter/cupertino.dart';
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
  late int level = 0;
  late int maxExp = 1000;
  late int currentExp = 0;
  late int lastResult = 55;
  late int totalKanji = 0;
  late String lastBigKanji = "近";
  late String lastSmallKanji = "日";
  late String lastKanjiLevel = "N2";

  int levelUp() {
    return level++;
  }

  void gainExp(int exp) {
    currentExp += currentExp + exp;
    if (currentExp >= maxExp) {
      levelUp();
      currentExp -= maxExp;
    }
  }

  void percentageRight(int right, int total) {
    lastResult = (right ~/ total) * 100;
  }

  void setLastKanji(String bigKanji, String smallKanji, String kanjiLevel) {
    lastBigKanji = bigKanji;
    lastSmallKanji = smallKanji;
    lastKanjiLevel = kanjiLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0099a9),
        ),
        body: Column(children: <Widget>[
          Row(
            children: [
              Container(
                color: Colors.black38,
                margin: EdgeInsets.all(50.0),
                height: 400,
                width: 400,
                child: Text(
                    '\n Level ${level} \n\n'
                    '${currentExp}/${maxExp}EP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'Roboto',
                      color: Color(0xFF26C6DA),
                    )),
              ),
              Container(
                color: Colors.black38,
                margin: EdgeInsets.all(50.0),
                height: 400,
                width: 400,
                child: Text(
                    '\n Results of your last game \n\n'
                    '${lastResult}%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'Roboto',
                      color: Color(0xFF26C6DA),
                    )),
              ),
            ],
          ),
          Column(//ROW 2
              children: [
            Container(
              color: Colors.black38,
              margin: EdgeInsets.all(50.0),
              height: 400,
              width: 400,
              child: Text(
                  'Your last Kanji\n'
                  '${lastBigKanji}\n\n'
                  '${lastSmallKanji}\n\n'
                  'Level: ${lastKanjiLevel}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Roboto',
                    color: Color(0xFF26C6DA),
                  )),
            ),
          ]),
        ]));
  }
}
