import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

final Random rnd = Random();
Vector2 randomCellVector2() {
  return (Vector2.random() - Vector2.random())..multiply(Vector2(1, 1));
}

T randomElement<T>(List<T> list) {
  return list[rnd.nextInt(list.length)];
}

class ExplosionFX extends PositionComponent {
  late final particleComponent;
  ExplosionFX(Vector2 position, Vector2 size)
      : super(position: position, size: size) {
    particleComponent = ParticleComponent(generate());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(particleComponent);
  }

  Particle generate() {
    final paints = [
      Colors.amber,
      Colors.amberAccent,
      Colors.red,
      Colors.redAccent,
      Colors.yellow,
      Colors.yellowAccent,
      Colors.blue,
    ].map((color) => Paint()..color = color).toList();

    return Particle.generate(
      generator: (i) {
        final initialSpeed = randomCellVector2();
        final deceleration = initialSpeed * -1;
        final gravity = Vector2(0, 40);

        return AcceleratedParticle(
          speed: initialSpeed,
          acceleration: deceleration + gravity,
          child: ComputedParticle(
            renderer: (canvas, particle) {
              final paint = randomElement(paints);
              paint.color = paint.color.withOpacity(1 - particle.progress);

              canvas.drawCircle(
                Offset.zero,
                rnd.nextDouble() * particle.progress > .6
                    ? rnd.nextDouble() * (50 * particle.progress)
                    : 2 + (3 * particle.progress),
                paint,
              );
            },
          ),
        );
      },
    );
  }
}
