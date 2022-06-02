import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

class Charlie extends SpriteAnimationComponent with HasGameRef {
  final double chickenScaleFactor = 3.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print('5. load charlie chicken image');
    Image chickenImage = await gameRef.images.load('chicken.png');
    var chickenAnimation = SpriteAnimation.fromFrameData(
        chickenImage,
        SpriteAnimationData.sequenced(
            amount: 14, stepTime: 0.1, textureSize: Vector2(32, 34)));

    animation = chickenAnimation;
    size = Vector2(32, 34) * chickenScaleFactor;
    position = Vector2(200, 10);
    add(RectangleHitbox());
    debugMode = true;
  }
}
