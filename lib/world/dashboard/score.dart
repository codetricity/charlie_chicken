import 'package:charlie_chicken/main.dart';
import 'package:flame/components.dart';

class Score extends TextComponent with HasGameRef<ChickenGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    String score = gameRef.charlieEnergy.toString();
    positionType = PositionType.viewport;
    text = 'SCORE: $score';
    position = Vector2(100, 20);
  }
}
