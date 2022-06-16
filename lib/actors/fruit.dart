import 'package:charlie_chicken/actors/charlie.dart';
import 'package:charlie_chicken/main.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tiled/tiled.dart';

class Fruit extends SpriteComponent
    with HasGameRef<ChickenGame>, CollisionCallbacks {
  final TiledObject fruit;

  Fruit(this.fruit);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('world/pineapple_3x.png')
      ..srcSize = Vector2.all(96);
    size = Vector2.all(96);
    position = Vector2(fruit.x, fruit.y);

    add(
      RectangleHitbox(
        size: Vector2(fruit.width, fruit.height),
        anchor: Anchor.center,
        position: size / 2,
      ),
    );

    debugMode = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Charlie) {
      gameRef.charlieEnergy += 1;
      removeFromParent();
    }
  }
}
