import 'package:flutter/material.dart';
import 'package:dashbook/dashbook.dart';
import 'test.dart';

void main() {
  //TODO: Proper Menu, throw out Dashbook, enforce Portrait Mode
  final dashbook = Dashbook.dualTheme(
    light: ThemeData.light(),
    dark: ThemeData.dark(),
    initWithLight: false,
    title: "Menu",
  );

  addGame(dashbook);
  runApp(dashbook);
}
