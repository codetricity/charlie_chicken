import 'package:charlie_chicken/actors/charlie.dart';
import 'package:charlie_chicken/actors/fruit.dart';
import 'package:charlie_chicken/world/game_controls/game_joystick.dart';
import 'package:charlie_chicken/world/obstacle.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:tiled/tiled.dart';

void main() {
  print('setup game orientation');
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  print('1. load the GameWidget with runApp');
  runApp(
    GameWidget(
      game: ChickenGame(),
    ),
  );
}

class ChickenGame extends FlameGame with HasDraggables, HasCollisionDetection {
  late Charlie chicken;
  late final JoystickComponent joystick;
  // late SpriteComponent background;
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
    for (final obstacle in obstacles) {
      add(Obstacle(obstacle));
    }
    camera.viewport = FixedResolutionViewport(Vector2(1280, mapHeight));

    chicken = Charlie();

    add(chicken);

    add(joystick = GameJoystick());
  }
}
