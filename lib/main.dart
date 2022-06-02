import 'package:charlie_chicken/actors/charlie.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:tiled/tiled.dart';

import 'actors/fruit.dart';

void main() {
  print('setup game orientation');
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  print('1. load the GameWidget with runApp');
  runApp(GameWidget(game: ChickenGame()));
}

class ChickenGame extends FlameGame with HasDraggables, HasCollisionDetection {
  late final JoystickComponent joystick;
  bool chickenFlipped = false;
  late SpriteComponent background;
  late Charlie charlie;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print('2. load the assets for the game');

    print('3. load map');
    var homeMap = await TiledComponent.load('level_1.tmx', Vector2(16, 16));
    print('4. add non-interactive map to game');
    add(homeMap);
    double mapHeight = 16.0 * homeMap.tileMap.map.height;

    // get fruit
    List<TiledObject> fruitObjects =
        homeMap.tileMap.getLayer<ObjectGroup>('Fruit')!.objects;

    for (var fruit in fruitObjects) {
      add(Fruit(fruit));
    }

    camera.viewport = FixedResolutionViewport(Vector2(1280, mapHeight));

    charlie = Charlie();

    add(charlie);

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);
    bool moveLeft = joystick.relativeDelta[0] < 0;
    bool moveRight = joystick.relativeDelta[0] > 0;
    bool moveUp = joystick.relativeDelta[1] < 0;
    bool moveDown = joystick.relativeDelta[1] > 0;
    double chickenVectorX = (joystick.relativeDelta * 300 * dt)[0];
    double chickenVectorY = (joystick.relativeDelta * 300 * dt)[1];

    // chicken is moving horizontally
    if ((moveLeft && charlie.x > 0) || (moveRight && charlie.x < size[0])) {
      charlie.position.add(Vector2(chickenVectorX, 0));
    }
    // chicken is moving vertically
    if ((moveUp && charlie.y > 0) ||
        (moveDown && charlie.y < size[1] - charlie.height)) {
      charlie.position.add(Vector2(0, chickenVectorY));
    }

    if (joystick.relativeDelta[0] < 0 && chickenFlipped) {
      chickenFlipped = false;
      charlie.flipHorizontallyAroundCenter();
    }

    if (joystick.relativeDelta[0] > 0 && !chickenFlipped) {
      chickenFlipped = true;
      charlie.flipHorizontallyAroundCenter();
    }
  }
}
