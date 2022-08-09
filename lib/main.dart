import 'package:charlie_chicken/actors/charlie.dart';
import 'package:charlie_chicken/actors/fruit.dart';
import 'package:charlie_chicken/world/dashboard.dart/score.dart';
import 'package:charlie_chicken/world/obstacle.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:tiled/tiled.dart';

void main() {
  print('setup game orientation');
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  print('1. load the GameWidget with runApp');
  runApp(GameWidget(game: ChickenGame()));
}

class ChickenGame extends FlameGame with HasDraggables, HasCollisionDetection {
  double chickenScaleFactor = 3.0;

  late Charlie chicken;
  late final JoystickComponent joystick;
  late SpriteComponent background;
  int charlieEnergy = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print('2. load the assets for the game');

    print('3. load map');
    final homeMap = await TiledComponent.load('level_1.tmx', Vector2(16, 16));
    print('4. add map to game');
    add(homeMap);
    final double mapHeight = 16.0 * homeMap.tileMap.map.height;

    // get fruit
    final List<TiledObject> fruitObjects =
        homeMap.tileMap.getLayer<ObjectGroup>('Fruit')!.objects;

    for (final fruit in fruitObjects) {
      add(Fruit(fruit));
    }

    final List<TiledObject> obstacles =
        homeMap.tileMap.getLayer<ObjectGroup>('Obstacles')!.objects;
    for (final TiledObject obstacle in obstacles) {
      add(Obstacle(obstacle));
    }
    camera.viewport = FixedResolutionViewport(Vector2(1280, mapHeight));
    print('5. load charlie chicken image');
    final Image chickenImage = await images.load('chicken.png');
    final chickenAnimation = SpriteAnimation.fromFrameData(
      chickenImage,
      SpriteAnimationData.sequenced(
        amount: 14,
        stepTime: 0.1,
        textureSize: Vector2(32, 34),
      ),
    );
    chicken = Charlie()
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
    add(Score());
    add(
      SpriteComponent(
        sprite: await loadSprite('menu/trophy.png'),
        size: Vector2.all(100),
        position: size - Vector2.all(120),
      ),
    );
  }
}
