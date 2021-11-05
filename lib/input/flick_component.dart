// ignore_for_file: implementation_imports
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/geometry.dart';

import 'package:flame/src/gestures/events.dart';
import 'package:flame/src/components/input/hud_margin_component.dart';

import 'package:flutter/rendering.dart' show EdgeInsets;
import 'dart:math';
import 'dart:developer' as dev;

import '../game/common.dart';

enum FlickDirection { up, right, down, left, push, idle }

class FlickComponent extends HudMarginComponent with Draggable {
  late final PositionComponent
      background; //TODO might change this to SpriteComponent
  late final List<TextComponent> texts;
  late final List<PositionComponent> hightlights;
  late final List<bool> activated;
  late final List<String> trblc;

  final threshold = 10;
  final Vector2 delta = Vector2.zero();

  bool drag = false;
  FlickDirection lastDir = FlickDirection.idle;

  FlickComponent({
    required this.background,
    EdgeInsets? margin,
    Vector2? position,
    required Vector2 size,
    required this.trblc,
    required this.activated,
    Anchor anchor = Anchor.center,
  })  : assert(
          margin != null || position != null,
          'Either margin or position must be defined',
        ),
        super(margin: margin, position: position, size: size, anchor: anchor) {
    Vector2 offset = size / 2;

    if (trblc.isNotEmpty && activated.isNotEmpty) {
      final smallCharConfig =
          TextPaint(config: Common.regularTextConfig.withFontSize(10));
      Vector2 xOffset = Vector2(size.x / 3, 0);
      Vector2 yOffset = Vector2(0, size.y / 3);
      texts = [
        TextComponent(
          trblc[0],
          textRenderer: smallCharConfig,
          position: background.position + offset - yOffset,
        )..anchor = Anchor.center,
        TextComponent(
          trblc[1],
          textRenderer: smallCharConfig,
          position: background.position + offset + xOffset,
        )..anchor = Anchor.center,
        TextComponent(
          trblc[2],
          textRenderer: smallCharConfig,
          position: background.position + offset + yOffset,
        )..anchor = Anchor.center,
        TextComponent(
          trblc[3],
          textRenderer: smallCharConfig,
          position: background.position + offset - xOffset,
        )..anchor = Anchor.center,
        TextComponent(
          trblc[4],
          textRenderer: Common.regular,
          position: background.position + offset,
          size: size,
        )..anchor = Anchor.center,
      ];
      Vector2 length = Vector2(size.x, size.y);
      double thickness = 6.0;
      yOffset = Vector2(0, (size.y / 2) - (thickness / 2));
      xOffset = Vector2((size.x / 2) - (thickness / 2), 0);
      hightlights = [
        Rectangle(
                position: background.position + offset - yOffset,
                size: Vector2(length.x, thickness),
                angle: 0)
            .toComponent(paint: Common.backgroundPaint)
          ..anchor = Anchor.center,
        Rectangle(
                position: background.position + offset + xOffset,
                size: Vector2(thickness, length.y),
                angle: 0)
            .toComponent(paint: Common.backgroundPaint)
          ..anchor = Anchor.center,
        Rectangle(
                position: background.position + offset + yOffset,
                size: Vector2(length.x, thickness),
                angle: 0)
            .toComponent(paint: Common.backgroundPaint)
          ..anchor = Anchor.center,
        Rectangle(
                position: background.position + offset - xOffset,
                size: Vector2(thickness, length.y),
                angle: 0)
            .toComponent(paint: Common.backgroundPaint)
          ..anchor = Anchor.center,
        Rectangle(position: background.position + offset, size: size, angle: 0)
            .toComponent(paint: Common.backgroundPaint)
          ..anchor = Anchor.center,
      ];
    } else {
      hightlights = <PositionComponent>[];
      texts = <TextComponent>[];
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(background);
    if (texts.isNotEmpty) {
      addAll(texts);
    }
  }

  @override
  void update(double dt) {
    if (hightlights.isNotEmpty) {
      var dir = direction;
      remove(hightlights[0]);
      remove(hightlights[1]);
      remove(hightlights[2]);
      remove(hightlights[3]);
      remove(hightlights[4]);
      if (dir == FlickDirection.up && activated[0]) {
        add(hightlights[0]);
      } else if (direction == FlickDirection.right && activated[1]) {
        add(hightlights[1]);
      } else if (direction == FlickDirection.down && activated[2]) {
        add(hightlights[2]);
      } else if (direction == FlickDirection.left && activated[3]) {
        add(hightlights[3]);
      } else if (direction == FlickDirection.push && activated[4]) {
        add(hightlights[4]);
      }
    }
    super.update(dt);
  }

  @override
  bool onDragStart(int pointerId, DragStartInfo info) {
    drag = true;
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
    drag = false;
    delta.setZero();
    return false;
  }

  static const double _eighthOfPi = pi / 8;
  FlickDirection get direction {
    if (delta.isZero() || delta.length < threshold) {
      if (drag) {
        return FlickDirection.push;
      } else {
        return FlickDirection.idle;
      }
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
  TextComponent readingT = TextComponent("");

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
            trblc: [],
            activated: [],
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
        if (char == "fire") {
          dev.log('data: $reading');
          //TODO: Shooting Logic
          reading = "";
          readingT.text = "";
        } else if (char == "‘") {
          //TODO: Rendaku Logic
        } else if (char == "小") {
          if (reading.endsWith("つ")) {
            reading = reading.substring(0, reading.length - 1) + "っ";
          } else if (reading.endsWith("や")) {
            reading = reading.substring(0, reading.length - 1) + "ゃ";
          } else if (reading.endsWith("ゆ")) {
            reading = reading.substring(0, reading.length - 1) + "ゅ";
          } else if (reading.endsWith("よ")) {
            reading = reading.substring(0, reading.length - 1) + "ょ";
          }
          readingT.text = reading;
        } else {
          reading += elem.trblc[elem.lastDir.index];
          readingT.text = reading;
        }
        elem.lastDir = FlickDirection.idle;
      }
    }
    super.update(dt);
  }

  void createUI() {
    final Vector2 position = Vector2(0, 0);
    readingT = TextComponent("", textRenderer: Common.regular)
      ..position =
          position + Vector2(background.size.x - background.size.x / 2, 35 / 2)
      ..size = Vector2(background.size.x, 35)
      ..anchor = Anchor.center;

    final Vector2 flickControlSize =
        Vector2(background.size.x, background.size.y - readingT.size.y);
    final Vector2 margin = Vector2(10, 10);
    final Vector2 startOffset = Vector2(0, readingT.size.y);
    final Vector2 elementSize = Vector2((flickControlSize.x - 2 * margin.x) / 3,
        (flickControlSize.y - 3 * margin.y) / 4);
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

    flickComponents = [
      FlickComponent(
          trblc: ["う", "え", "お", "い", "あ"],
          activated: [true, true, true, true, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position + startOffset + Vector2(0, 0),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["く", "け", "こ", "き", "か"],
          activated: [true, true, true, true, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position +
              startOffset +
              Vector2((elementSize.x * 1) + (1 * margin.x), 0),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["す", "せ", "そ", "し", "さ"],
          activated: [true, true, true, true, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position +
              startOffset +
              Vector2((elementSize.x * 2) + (2 * margin.x), 0),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["つ", "て", "と", "ち", "た"],
          activated: [true, true, true, true, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position +
              startOffset +
              Vector2(0, (elementSize.y * 1) + (1 * margin.y)),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["ぬ", "ね", "の", "に", "な"],
          activated: [true, true, true, true, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position +
              startOffset +
              Vector2((elementSize.x * 1) + (1 * margin.x),
                  (elementSize.y * 1) + (1 * margin.y)),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["ふ", "へ", "ほ", "ひ", "は"],
          activated: [true, true, true, true, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position +
              startOffset +
              Vector2((elementSize.x * 2) + (2 * margin.x),
                  (elementSize.y * 1) + (1 * margin.y)),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["む", "め", "も", "み", "ま"],
          activated: [true, true, true, true, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position +
              startOffset +
              Vector2(0, (elementSize.y * 2) + (2 * margin.y)),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["ゆ", "", "よ", "", "や"],
          activated: [true, false, true, false, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position +
              startOffset +
              Vector2((elementSize.x * 1) + (1 * margin.x),
                  (elementSize.y * 2) + (2 * margin.y)),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["る", "れ", "ろ", "り", "ら"],
          activated: [true, true, true, true, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position +
              startOffset +
              Vector2((elementSize.x * 2) + (2 * margin.x),
                  (elementSize.y * 2) + (2 * margin.y)),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["小", "", "", "", "‘"],
          activated: [true, false, false, false, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position +
              startOffset +
              Vector2(0, (elementSize.y * 3) + (3 * margin.y)),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["ん", "", "", "を", "わ"],
          activated: [true, false, false, true, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position +
              startOffset +
              Vector2((elementSize.x * 1) + (1 * margin.x),
                  (elementSize.y * 3) + (3 * margin.y)),
          size: elementSize,
          anchor: Anchor.topLeft),
      FlickComponent(
          trblc: ["", "", "", "", "fire"],
          activated: [false, false, false, false, true],
          background: Rectangle(position: position, size: elementSize, angle: 0)
              .toComponent(paint: backgroundPaint),
          position: position +
              startOffset +
              Vector2((elementSize.x * 2) + (2 * margin.x),
                  (elementSize.y * 3) + (3 * margin.y)),
          size: elementSize,
          anchor: Anchor.topLeft),
    ];

    addAll(flickComponents);
    add(readingT);
  }
}
