import 'package:charlie_chicken/main.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Charlie extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<ChickenGame> {
  bool chickenFlipped = false;

  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    debugMode = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    bool moveLeft = gameRef.joystick.relativeDelta[0] < 0;
    bool moveRight = gameRef.joystick.relativeDelta[0] > 0;
    bool moveUp = gameRef.joystick.relativeDelta[1] < 0;
    bool moveDown = gameRef.joystick.relativeDelta[1] > 0;
    double chickenVectorX = (gameRef.joystick.relativeDelta * 300 * dt)[0];
    double chickenVectorY = (gameRef.joystick.relativeDelta * 300 * dt)[1];

    // chicken is moving horizontally
    if ((moveLeft && x > 0) || (moveRight && x < size[0])) {
      position.add(Vector2(chickenVectorX, 0));
    }
    // chicken is moving vertically
    if ((moveUp && y > 0) || (moveDown && y < size[1] - height)) {
      position.add(Vector2(0, chickenVectorY));
    }

    if (gameRef.joystick.relativeDelta[0] < 0 && chickenFlipped) {
      chickenFlipped = false;
      flipHorizontallyAroundCenter();
    }

    if (gameRef.joystick.relativeDelta[0] > 0 && !chickenFlipped) {
      chickenFlipped = true;
      flipHorizontallyAroundCenter();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
  }
}
