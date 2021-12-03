import 'package:flutter/cupertino.dart';

class Vocab {
  String kanji = "";
  List<String> reading = [""];
  List<String> meaning = [""];
  int level = 0;
  List<String> type = [""];
  double correctCount = 0;
  double falseCount = 0;

  Vocab(List<dynamic> data) {
    kanji = data[0];
    reading = data[1];
    level = data[2];
    type = data[3];
    meaning = data[4];
  }

  Vocab.c(List<dynamic> data, this.correctCount, this.falseCount) {
    kanji = data[0];
    reading = data[1];
    level = data[2];
    type = data[3];
    meaning = data[4];
  }
}

List<Vocab> testVocabs = [
  Vocab([
    "近日",
    ["きんじつ"],
    5,
    ["n"],
    ["soon, in a few days"]
  ]),
  Vocab([
    "最近",
    ["さいきん"],
    5,
    ["n"],
    ["recently"]
  ])
];
