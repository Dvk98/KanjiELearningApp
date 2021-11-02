import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';

import '../input/flick_component.dart';

class KanjiLearningGame extends FlameGame
    with HasDraggableComponents, HasCollidables {
  late final FlickUI flickUI;
  late final TextComponent test;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    flickUI = FlickUI(
      background:
          Rectangle(position: Vector2(0, 0), size: Vector2(300, 300), angle: 0)
              .toComponent(paint: backgroundPaint),
      position: Vector2(size.x / 2, size.y - 200.0),
    );
    add(flickUI);
  }
}
