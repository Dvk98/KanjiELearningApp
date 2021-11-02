// ignore_for_file: implementation_imports
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'dart:math';
import 'package:flutter/rendering.dart' show EdgeInsets;
import 'package:flame/geometry.dart';

import 'package:flame/src/gestures/events.dart';
import 'package:flame/src/components/input/hud_margin_component.dart';

enum FlickDirection { up, right, down, left, push, idle }

class FlickComponent extends HudMarginComponent with Draggable {
  late final PositionComponent background;
  late final TextComponent textComponent;

  final threshold = 0.05;
  final Vector2 delta = Vector2.zero();

  FlickDirection lastDir = FlickDirection.idle;

  FlickComponent({
    required this.background,
    EdgeInsets? margin,
    Vector2? position,
    Vector2? size,
    required String text,
    Anchor anchor = Anchor.center,
  })  : assert(
          margin != null || position != null,
          'Either margin or position must be defined',
        ),
        super(margin: margin, position: position, size: size, anchor: anchor) {
    textComponent = TextComponent(text, position: position, size: size);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(background);
    add(textComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  bool onDragStart(int pointerId, DragStartInfo info) {
    return false;
  }

  @override
  bool onDragUpdate(_, DragUpdateInfo info) {
    delta.add(info.delta.global);
    return false;
  }

  @override
  bool onDragEnd(int id, __) {
    onDragCancel(id);
    return false;
  }

  @override
  bool onDragCancel(_) {
    lastDir = direction;
    delta.setZero();
    return false;
  }

  static const double _eighthOfPi = pi / 8;
  FlickDirection get direction {
    if (delta.isZero() || delta.length < threshold) {
      return FlickDirection.push;
    } else {
      var angle = delta.screenAngle();
      angle = angle < 0 ? 2 * pi + angle : angle;

      if (angle >= 0 && angle <= 2 * _eighthOfPi) {
        return FlickDirection.up;
      } else if (angle > 2 * _eighthOfPi && angle <= 6 * _eighthOfPi) {
        return FlickDirection.right;
      } else if (angle > 6 * _eighthOfPi && angle <= 10 * _eighthOfPi) {
        return FlickDirection.down;
      } else if (angle > 10 * _eighthOfPi && angle <= 14 * _eighthOfPi) {
        return FlickDirection.left;
      } else if (angle > 14 * _eighthOfPi) {
        return FlickDirection.up;
      }
    }
    return FlickDirection.idle;
  }
}

class FlickUI extends FlickComponent {
  FlickUI(
      {required PositionComponent background,
      EdgeInsets? margin,
      Vector2? position,
      double? size,
      Anchor anchor = Anchor.center})
      : assert(
          margin != null || position != null,
          'Either margin or position must be defined',
        ),
        super(
            text: "",
            background: background,
            margin: margin,
            position: position,
            size: background.size,
            anchor: anchor);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    createUI();
  }

  void createUI() {
    final Vector2 position = Vector2(0, 0);
    final Vector2 size = Vector2(100, 100);
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    final children = [
      FlickComponent(
        background: Rectangle(position: position, size: size, angle: 0)
            .toComponent(paint: backgroundPaint),
        text: "a",
        position: position,
        size: size,
      ),
    ];

    addAll(children);
  }
}
