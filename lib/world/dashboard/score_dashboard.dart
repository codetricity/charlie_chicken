import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScoreDashboard extends StatelessWidget {
  const ScoreDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'ENERGY: ',
          style: TextStyle(fontSize: 36, color: Colors.white),
        ),
      ],
    );
  }
}
