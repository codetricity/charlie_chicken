import 'package:charlie_chicken/main.dart';
import 'package:flutter/material.dart';

class ScoreDashboard extends StatelessWidget {
  final ChickenGame game;
  const ScoreDashboard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'ENERGY: ${game.charlieEnergy}',
          style: const TextStyle(fontSize: 36, color: Colors.white),
        ),
      ],
    );
  }
}
