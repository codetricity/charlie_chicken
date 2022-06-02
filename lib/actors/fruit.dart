import 'dart:ui';

import 'package:charlie_chicken/actors/charlie.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:tiled/tiled.dart';

class Fruit extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final TiledObject fruit;
  Fruit(this.fruit);
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('world/Pineapple.png')
      ..srcSize = Vector2.all(32);

    size = Vector2.all(96);
    position = Vector2(fruit.x, fruit.y);
    debugMode = true;
    add(
      RectangleHitbox(
          size: Vector2(fruit.width, fruit.height),
          anchor: Anchor.center,
          position: size / 2),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Charlie) {
      removeFromParent();
    }

    super.onCollision(intersectionPoints, other);
  }
}
