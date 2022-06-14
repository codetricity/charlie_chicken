import 'package:charlie_chicken/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScoreDashboard extends StatelessWidget {
  final ChickenGame game;
  const ScoreDashboard({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'ENERGY: ${game.charlieEnergy}',
          style: TextStyle(fontSize: 36, color: Colors.white),
        ),
      ],
    );
  }
}
