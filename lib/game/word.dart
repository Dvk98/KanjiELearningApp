import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flame/extensions.dart';

import 'common.dart';

class Word extends PositionComponent with Hitbox, Collidable {
  final Vector2 velocity;
  final delta = Vector2.zero();

  final String word;
  final List<String> readings;
  late final TextComponent textComponent;

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
    textComponent = TextComponent(word,
        position: position, size: size, textRenderer: Common.regular);
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
    renderHitboxes(canvas);
  }
}
