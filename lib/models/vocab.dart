import 'package:flutter/cupertino.dart';

class Vocab {
  String kanji;
  String reading;
  String level;
  double correctCount;
  double falseCount;

  Vocab(
      {required this.kanji,
      required this.reading,
      required this.level,
      this.correctCount = 0,
      this.falseCount = 0});
}

List<Vocab> vocabs = [
  Vocab(
      kanji: "近日",
      reading: "きんじつ",
      level: "N5",
      correctCount: 10,
      falseCount: 2),
  Vocab(
      kanji: "最近",
      reading: "さいきん",
      level: "N5",
      correctCount: 8,
      falseCount: 0),
  Vocab(
      kanji: "上げる",
      reading: "あげる",
      level: "N5",
      correctCount: 5,
      falseCount: 13)
];
