import 'dart:html';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import '../input/flick_component.dart';

class Player extends SpriteComponent with HasGameRef {
  double maxSpeed = 3000.0;

  final JoystickComponent joystick;
  final FlickUI flick;

  Player(this.joystick, this.flick)
      : super(
          size: Vector2.all(100.0),
        ) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('TODO');
    position = gameRef.size / 2; //TODO
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
    if (flick.lastDir != FlickDirection.idle) {}
  }
}
