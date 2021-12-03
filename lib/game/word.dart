import 'dart:math';

import 'package:app/models/vocab.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart' hide Image, Draggable;

import 'dart:developer' as dev;

import 'common.dart';

class Word extends PositionComponent with Tappable {
  final Vector2 velocity;
  final delta = Vector2.zero();
  final shapePaint = BasicPalette.red.paint()..style = PaintingStyle.stroke;
  final shapePaintMarked = BasicPalette.green.paint()
    ..style = PaintingStyle.stroke;
  late final Vocab vocabComponent;
  late final TextComponent textComponent;
  bool isMarked = false;
  bool isActive = false;

  Word(
    Vector2 position,
    Vector2 size,
    this.vocabComponent,
    this.velocity,
  ) : super(position: position, size: size) {
    textComponent =
        TextComponent(vocabComponent.kanji, textRenderer: Common.regular);
  }

  changeColor() {
    if (isMarked) {
      textComponent.textRenderer = TextPaint(
          config: Common.regularTextConfig.withColor(BasicPalette.red.color));
    } else {
      textComponent.textRenderer = TextPaint(config: Common.regularTextConfig);
    }
  }

  @override
  bool onTapUp(_) {
    return true;
  }

  @override
  bool onTapDown(_) {
    isMarked = isMarked == true ? false : true;
    changeColor();
    return true;
  }

  @override
  bool onTapCancel() {
    return true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(textComponent);
  }

  @override
  void update(double dt) {
    if (isActive) {
      super.update(dt);
      delta.setFrom(velocity * dt);
      position.add(delta);
    }
  }

  bool checkReading(String input) {
    for (String reading in vocabComponent.reading) {
      if (input == reading) {
        return true;
      }
    }
    return false;
  }
}
