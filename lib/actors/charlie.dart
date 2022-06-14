import 'package:charlie_chicken/main.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

import '../world/obstacle.dart';

class Charlie extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<ChickenGame> {
  final double chickenScaleFactor = 3.0;

  bool chickenFlipped = false;
  bool collided = false;
  JoystickDirection collidedDirection = JoystickDirection.idle;

  Future<void> onLoad() async {
    await super.onLoad();
    print('5. load charlie chicken image');
    Image chickenImage = await gameRef.images.load('chicken.png');
    var chickenAnimation = SpriteAnimation.fromFrameData(
        chickenImage,
        SpriteAnimationData.sequenced(
            amount: 14, stepTime: 0.1, textureSize: Vector2(32, 34)));
    add(RectangleHitbox());
    debugMode = true;
    animation = chickenAnimation;
    size = Vector2(32, 34) * chickenScaleFactor;
    position = Vector2(300, 100);
  }

  @override
  void update(double dt) {
    super.update(dt);
    bool moveLeft = gameRef.joystick.direction == JoystickDirection.left;
    bool moveRight = gameRef.joystick.direction == JoystickDirection.right;
    bool moveUp = gameRef.joystick.direction == JoystickDirection.up;
    bool moveDown = gameRef.joystick.direction == JoystickDirection.down;
    double chickenVectorX = (gameRef.joystick.relativeDelta * 300 * dt)[0];
    double chickenVectorY = (gameRef.joystick.relativeDelta * 300 * dt)[1];

    // chicken is moving left
    if (moveLeft && x > 0) {
      if (!collided || collidedDirection == JoystickDirection.right) {
        x += chickenVectorX;
      }
    }
// chicken is moving right
    if (moveRight && x < gameRef.size[0]) {
      if (!collided || collidedDirection == JoystickDirection.left) {
        x += chickenVectorX;
      }
    }

    // chicken s moving up
    if (moveUp && y > 0) {
      if (!collided || collidedDirection == JoystickDirection.down) {
        y += chickenVectorY;
      }
    }

    // chicken s moving down
    if (moveDown && y < gameRef.size[1] - height) {
      if (!collided || collidedDirection == JoystickDirection.up) {
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
    super.onCollision(intersectionPoints, other);
    if (other is Obstacle) {
      if (!collided) {
        collided = true;
        collidedDirection = gameRef.joystick.direction;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    collidedDirection = JoystickDirection.idle;
    collided = false;
  }
}
