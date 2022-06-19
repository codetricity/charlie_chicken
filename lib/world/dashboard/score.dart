import 'package:charlie_chicken/main.dart';
import 'package:flame/components.dart';

class Score extends TextComponent with HasGameRef<ChickenGame> {
  late String score;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    score = gameRef.charlieEnergy.toString();
    positionType = PositionType.viewport;
    text = 'SCORE: $score';
    position = Vector2(100, 20);
    scale = Vector2(2.5, 2.5);
  }

  @override
  void update(double dt) {
    super.update(dt);
    score = gameRef.charlieEnergy.toString();
    text = 'SCORE: $score';
  }
}
