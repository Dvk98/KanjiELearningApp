// ignore_for_file: implementation_imports
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'dart:math';
import 'package:flutter/rendering.dart' show EdgeInsets;
import 'package:flame/geometry.dart';
import 'dart:developer' as dev;

import 'package:flame/src/gestures/events.dart';
import 'package:flame/src/components/input/hud_margin_component.dart';

enum FlickDirection { up, right, down, left, push, idle }

final _regularTextConfig = TextPaintConfig(
    color: BasicPalette.white.color, fontFamily: "Togalite", fontSize: 30);
final _regular =
    TextPaint(config: _regularTextConfig.withFontFamily("Togalite"));

class FlickComponent extends HudMarginComponent with Draggable {
  late final PositionComponent
      background; //TODO might change this to SpriteComponent
  late final TextComponent textComponent;
  late final List<String> trblc;

  final threshold = 0.05;
  final Vector2 delta = Vector2.zero();

  FlickDirection lastDir = FlickDirection.idle;

  FlickComponent({
    required this.background,
    EdgeInsets? margin,
    Vector2? position,
    Vector2? size,
    required String text,
    required this.trblc,
    Anchor anchor = Anchor.center,
  })  : assert(
          margin != null || position != null,
          'Either margin or position must be defined',
        ),
        super(margin: margin, position: position, size: size, anchor: anchor) {
    Vector2 offset = size! / 2;

    textComponent = TextComponent(
      text,
      textRenderer: _regular,
      position: background.position + offset,
      size: size,
    )..anchor = Anchor.center;
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
  late final List<FlickComponent> flickComponents;
  String reading = "";

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
            trblc: [],
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

  @override
  void update(double dt) {
    for (final elem in flickComponents) {
      if (elem.lastDir != FlickDirection.idle) {
        String char = elem.trblc[elem.lastDir.index];
        if (char == "shoot") {
          dev.log('data: $reading');
          //TODO: Shooting Logic
          reading = "";
        } else if (char == "‘") {
          //TODO: Rendaku Logic
        } else {
          reading += elem.trblc[elem.lastDir.index];
        }
        elem.lastDir = FlickDirection.idle;
      }
    }
    super.update(dt);
  }

  void createUI() {
    final Vector2 position = Vector2(0, 0);
    const double margin = 0.2;
    const double offset = margin / 2;
    final Vector2 elementSize = Vector2(
        background.size.x / (3 + margin), background.size.y / (4 + margin));
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    flickComponents = [
      FlickComponent(
          trblc: ["う", "え", "お", "い", "あ"],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "あ",
          position: position,
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["く", "け", "こ", "き", "か"],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "か",
          position: position + Vector2(elementSize.x * (1 + (1 * offset)), 0),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["す", "せ", "そ", "し", "さ"],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "さ",
          position: position + Vector2(elementSize.x * (2 + (2 * offset)), 0),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["つ", "て", "と", "ち", "た"],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "た",
          position: position + Vector2(0, elementSize.y * (1 + (1 * offset))),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["ぬ", "ね", "の", "に", "な"],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "な",
          position: position +
              Vector2(elementSize.x * (1 + (1 * offset)),
                  elementSize.y * (1 + (1 * offset))),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["ふ", "へ", "ほ", "ひ", "は"],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "は",
          position: position +
              Vector2(elementSize.x * (2 + (2 * offset)),
                  elementSize.y * (1 + (1 * offset))),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["む", "め", "も", "み", "ま"],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "ま",
          position: position +
              Vector2(elementSize.x * (0 + (0 * offset)),
                  elementSize.y * (2 + (2 * offset))),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["ゆ", "", "よ", "", "や"],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "や",
          position: position +
              Vector2(elementSize.x * (1 + (1 * offset)),
                  elementSize.y * (2 + (2 * offset))),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["る", "れ", "ろ", "り", "ら"],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "ら",
          position: position +
              Vector2(elementSize.x * (2 + (2 * offset)),
                  elementSize.y * (2 + (2 * offset))),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["", "", "", "", "‘"], //TODO: Rendaku?
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "‘",
          position: position +
              Vector2(elementSize.x * (0 + (0 * offset)),
                  elementSize.y * (3 + (3 * offset))),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["ん", "", "", "を", "わ"],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "わ",
          position: position +
              Vector2(elementSize.x * (1 + (1 * offset)),
                  elementSize.y * (3 + (3 * offset))),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["", "", "", "", "shoot"],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          text: "Fire",
          position: position +
              Vector2(elementSize.x * (2 + (2 * offset)),
                  elementSize.y * (3 + (3 * offset))),
          size: elementSize,
          anchor: Anchor.topLeft),
    ];

    addAll(flickComponents);
  }
}
