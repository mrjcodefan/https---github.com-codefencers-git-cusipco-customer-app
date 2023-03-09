import 'package:flutter/material.dart';
import 'package:heal_u/routes.dart';
import 'package:heal_u/screens/authentication_screen/login_screen.dart';
import 'package:heal_u/screens/main_screen/main_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';
import 'package:heal_u/screens/onboarding_screen.dart';
import 'package:heal_u/service/prowider/initial_data_prowider.dart';
import 'package:heal_u/service/shared_pref_service/onboaring_pref_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // ignore: must_call_super
  void initState() {
    // _navigatxeTo();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil<void>(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => OnBoardingScreen()),
        ModalRoute.withName(Routes.onBoardingScreen),
      );
    });
  }

  _navigateTo() async {
    try {
      bool? isOnboard = await OnBoadingPrefService.getOnBoaring();
      if (isOnboard == null) {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => OnBoardingScreen()),
          ModalRoute.withName(Routes.onBoardingScreen),
        );
      } else if (!isOnboard) {
        _checkUserLogin();
      } else {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => OnBoardingScreen()),
          ModalRoute.withName(Routes.onBoardingScreen),
        );
      }
    } catch (e) {
      Navigator.pushAndRemoveUntil<void>(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => OnBoardingScreen()),
        ModalRoute.withName(Routes.onBoardingScreen),
      );
    }
  }

  _checkUserLogin() async {
    try {
      var userdata = await Provider.of<UserPrefService>(context, listen: false)
          .getUserData();

      if (userdata.data!.id != null && userdata.data!.id != "") {
        var initdataService =
            Provider.of<InitialDataService>(context, listen: false);

        try {
          var familyPro =
              Provider.of<FamilyMemberService>(context, listen: false);
          await familyPro.getFamilyMemberList(context: context);

          await initdataService.loadInitData(context);

          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => MainScreen()),
            ModalRoute.withName(Routes.mainRoute),
          );
        } catch (e) {
          if (mounted) {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => LoginScreen()),
              ModalRoute.withName(Routes.loginScreen),
            );
          }
        }
      } else {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => LoginScreen()),
          ModalRoute.withName(Routes.loginScreen),
        );
      }
    } catch (e) {
      print("splash catch -------------------");
      // print(e);
      if (mounted) {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => LoginScreen()),
          ModalRoute.withName(Routes.loginScreen),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          body: Container(
              // color: ThemeClass.blueColor,
              height: height,
              width: width,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/splash_bg1.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    child: _buildView(height),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Column _buildView(double height) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.05,
        ),
        Container(
          height: height * 0.25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_main_icon.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          height: height * 0.08,
        ),
        Container(
          height: height * 0.30,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_icon1.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
