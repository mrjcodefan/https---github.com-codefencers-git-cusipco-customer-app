import 'package:flutter/material.dart';
import 'package:heal_u/themedata.dart';

class TextFiledWidget extends StatefulWidget {
  const TextFiledWidget(
      {Key? key,
      required this.hinttext,
      required this.controllers,
      this.validator,
      required this.icon,
      this.oniconTap,
      this.radius = 15,
      this.isReadOnly = false,
      this.onChange,
      this.isObcurs = false,
      required this.backColor,
      this.isClickable = false,
      this.onTap,
      this.isShowEnableBorder = false,
      this.isNumber = false})
      : super(
          key: key,
        );
  final String hinttext;
  final double radius;
  final TextEditingController controllers;
  final String? Function(String?)? validator;
  final bool isNumber;
  final String icon;
  final bool isObcurs;
  final bool isClickable;
  final bool isReadOnly;
  final Function? oniconTap;

  final Function? onTap;

  final Function(String)? onChange;
  final Color? backColor;
  final bool isShowEnableBorder;
  @override
  State<TextFiledWidget> createState() => _TextFiledWidgetState();
}

class _TextFiledWidgetState extends State<TextFiledWidget> {
  double padding = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backColor,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: padding),
        child: TextFormField(
          onChanged: (value) {
            if (widget.onChange != null) {
              widget.onChange!(value);
            }
          },
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          readOnly: widget.isReadOnly,
          controller: widget.controllers,
          obscureText: widget.isObcurs,
          keyboardType:
              widget.isNumber ? TextInputType.number : TextInputType.text,
          autovalidateMode: AutovalidateMode.disabled,
          validator: (value) {
            if (widget.validator!(value) != null) {
              setState(() {
                padding = 10;
              });
            } else {
              setState(() {
                padding = 0;
              });
            }
            return widget.validator!(value);
          },
          style: TextStyle(
            color: ThemeClass.greyDarkColor,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.3,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),

            hintText: widget.hinttext,
            hintStyle: TextStyle(
              color: ThemeClass.greyDarkColor,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            suffixIcon: InkWell(
              onTap: () {
                if (widget.oniconTap != null) {
                  widget.oniconTap!();
                }
              },
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.icon),
                    ),
                  ),
                ),
              ),
            ),
            // errorStyle: TextStyle(fontSize: 9, height: 0.3),
            prefixStyle: TextStyle(color: ThemeClass.greyDarkColor),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(
                color: widget.isShowEnableBorder
                    ? ThemeClass.greyLightColor
                    : Colors.transparent,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(
                color: ThemeClass.greyDarkColor,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
