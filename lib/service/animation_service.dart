import 'package:auto_animated/auto_animated.dart';

class AnimationService {
  static final animationOption = LiveOptions(
    delay: Duration(milliseconds: 100),
    showItemInterval: Duration(milliseconds: 100),
    showItemDuration: Duration(milliseconds: 300),
    visibleFraction: 0.05,
    reAnimateOnVisibility: false,
  );
}
