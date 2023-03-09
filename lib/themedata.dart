import 'package:flutter/material.dart';

class ThemeClass {
  ThemeClass();
  static final Color whiteColor = Color(0xFFFFFFFF);
  static final Color whiteColorgrey = Color(0xFFF5F5F5);

  static final Color whiteDarkColor = Color(0xFFFBFBFB);
  static final Color whiteDarkshadow = Color(0xFFF3FAFF);

  static final Color skyblueColor = Color(0xFFD5F4FF);
  static final Color skyblueColor1 = Color(0xFFF3FAFF);
  static final Color skyblueColor2 = Color(0xFFDCFFEF);

  static final Color blueColor = Color(0xFF36D1DC);
  static final Color blueColor3 = Color(0xFF5B86E5);
  static final Color blueDarkColor = Color(0xFF124C61);
  static final Color blueDarkColor1 = Color(0xFFD5DBFF);
  static final Color blueDarkColor2 = Color(0xFFD9FFFE);
  static final Color blueColor2 = Color(0xFFDCF6FF);

  static final Color redColor = Color(0xFFD70222);
  static final Color pinkColor = Color(0xFFF8E5FF);

  static final Color pinkColor1 = Color(0xFFFFFFDC);
  static final Color pinkColor2 = Color(0xFFFFE2D5);

  static final Color greenColor = Color(0xFF178E00);
  static final Color orangeColor = Color(0xFFF0A500);

  static final Color yellowColor = Color(0xFFFFFF00);

  static final Color blackColor = Color(0xFF1E1E1E);
  static final Color blackColor1 = Color(0xFF292929);

  static final Color greyDarkColor = Color(0xFF5B5B5B);
  static final Color greyColor = Color(0xFF757575);
  static final Color greyColorBackgorund = Color(0xFFF1F1F1);
  static final Color greyMediumColor = Color(0xFF707070);
  static final Color greyLightColor = Color(0xFFD0D0D0);
  static final Color greyLightColor1 = Color(0xFFE8E8E8);

  static final Color safeareBackGround = blueColor;

  static final themeData = ThemeData(
      primaryColor: ThemeClass.blueColor,
      fontFamily: 'Poppins',
      splashColor: ThemeClass.greyLightColor);
}
