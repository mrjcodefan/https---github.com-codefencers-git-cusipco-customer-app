import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget(
      {Key? key, required this.child, required this.onPressed})
      : super(key: key);
  final Widget child;

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: child,
      onPressed: () {
        onPressed();
      },
    );
  }
}
