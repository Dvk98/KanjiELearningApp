import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' hide Image, Draggable;

import 'dart:developer' as dev;

import 'common.dart';

class Word extends PositionComponent with Tappable {
  final Vector2 velocity;
  final delta = Vector2.zero();
  late final Circle circle;
  final shapePaint = BasicPalette.red.paint()..style = PaintingStyle.stroke;
  final shapePaintMarked = BasicPalette.green.paint()
    ..style = PaintingStyle.stroke;
  final String word;
  final List<String> readings;
  late final TextComponent textComponent;
  bool _isMarked = false;

  Word(
    Vector2 position,
    Vector2 size,
    this.word,
    this.readings,
    this.velocity,
  ) {
    this.position = position;
    this.size = size;
    anchor = Anchor.center;
    circle = Circle(radius: 50, position: position);
    textComponent = TextComponent(word,
        position: position, size: size, textRenderer: Common.regular)
      ..anchor = Anchor.center;
  }

  @override
  bool onTapUp(_) {
    dev.log("Up");
    return true;
  }

  @override
  bool onTapDown(_) {
    dev.log("Down");
    textComponent.textRenderer = TextPaint(
        config: Common.regularTextConfig.withColor(BasicPalette.red.color));

    _isMarked = _isMarked == true ? false : true;
    return true;
  }

  @override
  bool onTapCancel() {
    dev.log("Cancel");
    return true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(textComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    delta.setFrom(velocity * dt);
    position.add(delta);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    circle.render(canvas, _isMarked ? shapePaintMarked : shapePaint);
  }
}
