import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';

import '../input/flick_component.dart';

class KanjiLearningGame extends FlameGame
    with HasDraggableComponents, HasCollidables {
  late final FlickUI flickUI;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    flickUI = FlickUI(
      background:
          Rectangle(position: Vector2(0, 0), size: Vector2(100, 100), angle: 0)
              .toComponent(paint: backgroundPaint),
      position: Vector2(200, 200),
    );

    add(flickUI);
  }
}
