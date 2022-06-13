import 'package:charlie_chicken/actors/charlie.dart';
import 'package:charlie_chicken/actors/fruit.dart';
import 'package:charlie_chicken/world/dashboard/score_dashboard.dart';
import 'package:charlie_chicken/world/game_controls/game_joystick.dart';
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
  // wrap with MaterialApp and Scaffold for Flutter
  // widget system on score overlay
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
          overlayBuilderMap: {
            'ScoreDashboard': (BuildContext context, ChickenGame game) =>
                const ScoreDashboard()
          },
          game: ChickenGame(),
        ),
      ),
    ),
  );
}

class ChickenGame extends FlameGame with HasDraggables, HasCollisionDetection {
  double chickenScaleFactor = 3.0;

  late Charlie chicken;
  late final JoystickComponent joystick;
  late SpriteComponent background;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print('2. load the assets for the game');

    print('3. load map');
    var homeMap = await TiledComponent.load('level_1.tmx', Vector2(16, 16));
    print('4. add map to game');
    add(homeMap);
    double mapHeight = 16.0 * homeMap.tileMap.map.height;

    // get fruit
    List<TiledObject> fruitObjects =
        homeMap.tileMap.getLayer<ObjectGroup>('Fruit')!.objects;

    for (var fruit in fruitObjects) {
      add(Fruit(fruit));
    }

    List<TiledObject> obstacles =
        homeMap.tileMap.getLayer<ObjectGroup>('Obstacles')!.objects;
    for (var obstacle in obstacles) {
      add(Obstacle(obstacle));
    }
    camera.viewport = FixedResolutionViewport(Vector2(1280, mapHeight));
    print('5. load charlie chicken image');
    Image chickenImage = await images.load('chicken.png');
    var chickenAnimation = SpriteAnimation.fromFrameData(
        chickenImage,
        SpriteAnimationData.sequenced(
            amount: 14, stepTime: 0.1, textureSize: Vector2(32, 34)));
    chicken = Charlie()
      ..animation = chickenAnimation
      ..size = Vector2(32, 34) * chickenScaleFactor
      ..position = Vector2(300, 100);
    add(chicken);

    add(joystick = GameJoystick());
    overlays.add('ScoreDashboard');
  }
}
