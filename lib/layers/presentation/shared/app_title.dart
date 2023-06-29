import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rickmorty/layers/presentation/styles.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key, required this.stateManagement});

  final String stateManagement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: Offset(-(TextStyles.h1.letterSpacing! * .5), 0),
                child: Text('RICK & ', style: TextStyles.h1),
              ),
            ],
          ).animate().fadeIn(delay: .8.seconds, duration: .7.seconds),
          Text('MORTY ($stateManagement)', style: TextStyles.h2)
              .animate()
              .fadeIn(delay: 1.seconds, duration: .7.seconds),
        ],
      ),
    );
  }
}
