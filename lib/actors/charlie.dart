import 'package:charlie_chicken/main.dart';
import 'package:charlie_chicken/world/obstacle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Charlie extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<ChickenGame> {
  bool chickenFlipped = false;
  bool collided = false;
  JoystickDirection collisionDirection = JoystickDirection.idle;

  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    debugMode = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // bool moveLeft = gameRef.joystick.relativeDelta[0] < 0;
    // bool moveRight = gameRef.joystick.relativeDelta[0] > 0;
    // bool moveUp = gameRef.joystick.relativeDelta[1] < 0;
    // bool moveDown = gameRef.joystick.relativeDelta[1] > 0;
    bool moveLeft = gameRef.joystick.direction == JoystickDirection.left;
    bool moveRight = gameRef.joystick.direction == JoystickDirection.right;
    bool moveUp = gameRef.joystick.direction == JoystickDirection.up;
    bool moveDown = gameRef.joystick.direction == JoystickDirection.down;
    double chickenVectorX = (gameRef.joystick.relativeDelta * 300 * dt)[0];
    double chickenVectorY = (gameRef.joystick.relativeDelta * 300 * dt)[1];

    // charley moving left
    if (moveLeft && x > 0) {
      if (!collided || collisionDirection == JoystickDirection.right) {
        x += chickenVectorX;
      }
    }

    //charley moving right
    if (moveRight && x < gameRef.size[0]) {
      if (!collided || collisionDirection == JoystickDirection.left) {
        x += chickenVectorX;
      }
    }

    // chicken is moving up
    if (moveUp && y > 0) {
      if (!collided || collisionDirection == JoystickDirection.down) {
        y += chickenVectorY;
      }
    }

    // chicken is moving down
    if (moveDown && y < gameRef.size[1] - height) {
      if (!collided || collisionDirection == JoystickDirection.up) {
        y += chickenVectorY;
      }
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
    if (other is Obstacle) {
      if (!collided) {
        collided = true;
        collisionDirection = gameRef.joystick.direction;
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    collisionDirection = JoystickDirection.idle;
    collided = false;
    super.onCollisionEnd(other);
  }
}
