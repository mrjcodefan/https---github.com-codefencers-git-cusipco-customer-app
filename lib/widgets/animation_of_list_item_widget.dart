import 'package:flutter/cupertino.dart';

class AnimatedListTileItem extends StatelessWidget {
  const AnimatedListTileItem(
      {Key? key, required this.child, required this.animation})
      : super(key: key);
  final Widget child;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.25, -0.01),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      ),
    );
  }
}
