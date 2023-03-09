import 'package:flutter/material.dart';
import 'package:heal_u/themedata.dart';

class ButtonSmallWidget extends StatelessWidget {
  ButtonSmallWidget(
      {Key? key,
      this.isLoading = false,
      required this.title,
      required this.color,
      this.fontSize = 10,
      this.verticalPadding,
      this.horizontalPadding,
      required this.callBack});

  final bool isLoading;
  final String title;
  final Function callBack;
  final Color color;
  final double fontSize;
  final double? verticalPadding;
  final double? horizontalPadding;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      // minWidth: MediaQuery.of(context).size.width,
      padding: EdgeInsets.zero,
      height: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0,
          vertical: verticalPadding ?? 02,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: fontSize,
          ),
        ),
      ),
      color: color,
      onPressed: () {
        callBack();
      },
    );
  }
}
