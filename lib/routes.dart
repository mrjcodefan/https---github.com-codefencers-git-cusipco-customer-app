import 'package:flutter/cupertino.dart';
import 'package:heal_u/screens/authentication_screen/login_screen.dart';
import 'package:heal_u/screens/authentication_screen/register_screen.dart';
import 'package:heal_u/screens/authentication_screen/verify_mobile_screen.dart';
import 'package:heal_u/screens/main_screen/main_screen.dart';
import 'package:heal_u/screens/onboarding_screen.dart';
import 'package:heal_u/screens/splash_screen.dart';

class Routes {
  static const String mainRoute = "/main";
  static const String mainRouteforLoading = "/";

  static const String splashRoute = "/splash";
  static const String onBoardingScreen = "/onBoardingScreen";
  static const String loginScreen = "/loginScreen";
  // static const String verifyMobileScreen = "/verifyMobileScreen";
  static const String registerScreen = "/registerScreen";
  static Map<String, Widget Function(BuildContext)> globalRoutes = {
    mainRoute: (context) => MainScreen(),
    splashRoute: (context) => SplashScreen(),
    onBoardingScreen: (context) => OnBoardingScreen(),
    // verifyMobileScreen: (context) => VerifyMobileScreen(),
    registerScreen: (context) => RegisterScreen(),
    loginScreen: (context) => LoginScreen(),
  };
}
