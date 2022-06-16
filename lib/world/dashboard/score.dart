import 'package:flame/components.dart';

class Score extends TextComponent {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    positionType = PositionType.viewport;
    text = 'SCORE';
    position = Vector2(100, 100);
  }
}
