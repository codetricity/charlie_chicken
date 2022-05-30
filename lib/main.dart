import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;

void main() {
  print('1. load the GameWidget with runApp');
  runApp(GameWidget(game: ChickenGame()));
}

class ChickenGame extends FlameGame with HasDraggables {
  double chickenScaleFactor = 3.0;

  late SpriteAnimationComponent chicken;
  late final JoystickComponent joystick;
  bool chickenFlipped = false;
  // late SpriteComponent background;
  late TiledComponent homeMap;
  bool chickenLeft = false;
  bool chickenRight = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print('2. load the assets for the game');
    // background = SpriteComponent()
    //   ..sprite = await loadSprite('background.png')
    //   ..size = size;
    // add(background);
    homeMap = await TiledComponent.load('level_1.tmx', Vector2.all(16));
    add(homeMap);
    double mapWidth = 16.0 * homeMap.tileMap.map.width;
    double mapHeight = 16.0 * homeMap.tileMap.map.height;

    Image chickenImage = await images.load('chicken.png');
    var chickenAnimation = SpriteAnimation.fromFrameData(
        chickenImage,
        SpriteAnimationData.sequenced(
            amount: 14, stepTime: 0.1, textureSize: Vector2(32, 34)));
    chicken = SpriteAnimationComponent()
      ..animation = chickenAnimation
      ..size = Vector2(32, 34) * chickenScaleFactor
      ..position = Vector2(300, 100);
    add(chicken);

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);
    camera.viewport = FixedResolutionViewport(Vector2(mapWidth, mapHeight));
    camera.followComponent(chicken,
        worldBounds: Rect.fromLTRB(0, 0, mapWidth, mapHeight));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (joystick.relativeDelta[0] < 0 && chickenLeft && chicken.x > 0) {
      chicken.position.add(joystick.relativeDelta * 300 * dt);
    } else if (joystick.relativeDelta[0] > 0 &&
        chickenRight &&
        chicken.x < size[0]) {
      chicken.position.add(joystick.relativeDelta * 300 * dt);
    }
    if (joystick.relativeDelta[0] < 0 && chickenFlipped) {
      chickenFlipped = false;
      chicken.flipHorizontallyAroundCenter();
      chickenLeft = true;
      chickenRight = false;
    } else if (joystick.relativeDelta[0] > 0 && !chickenFlipped) {
      chickenFlipped = true;
      chickenRight = true;
      chickenLeft = false;
      chicken.flipHorizontallyAroundCenter();
    }
  }
}
