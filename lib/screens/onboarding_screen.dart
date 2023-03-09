import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/screens/authentication_screen/login_screen.dart';
import 'package:heal_u/service/shared_pref_service/onboaring_pref_service.dart';
import 'package:heal_u/themedata.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<OnboardingModel> images = [
    OnboardingModel(
        image: "assets/images/onbording_image1.png",
        title: "Onboarding Title 01",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"),
    OnboardingModel(
        image: "assets/images/onbording_image1.png",
        title: "Onboarding Title 02",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"),
    OnboardingModel(
        image: "assets/images/onbording_image1.png",
        title: "Onboarding Title 03",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"),
  ];
  CarouselController buttonCarouselController = CarouselController();
  int _activePage = 0;
  bool isEnableNav = false;

  bool isshowButton = false;
  _navigat() {
    EasyLoading.show();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      EasyLoading.dismiss();
    });
  }

  @override
  void initState() {
    _disableOnBoading();
    super.initState();
  }

  _disableOnBoading() async {
    await OnBoadingPrefService.setOnBoaringScreenDisable(false);
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
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(
                        child: CarouselSlider(
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            aspectRatio: 1,
                            viewportFraction: 1,
                            disableCenter: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: false,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                const Duration(seconds: 1),
                            autoPlayInterval: const Duration(seconds: 3),
                            onPageChanged: (index, reason) {
                              // ignore: avoid_print
                              print("onPageChanged index : $index");
                              setState(
                                () {
                                  if (isEnableNav) {
                                    _navigat();
                                  } else {
                                    _activePage = index;
                                    EasyLoading.dismiss();
                                    if (index == images.length - 1) {
                                      isEnableNav = true;
                                    }
                                  }
                                },
                              );
                            },
                          ),
                          items: <Widget>[
                            for (var i = 0; i < images.length; i++)
                              _buildOnboardingDetails(height, i),
                          ],
                        ),
                      ),
                      _buildBottomDots(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _buildBottomButton(),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Align _buildBottomButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                _navigat();
              },
              child: Text(
                "SKIP",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  if (isEnableNav) {
                    _navigat();
                  } else {
                    buttonCarouselController.nextPage();
                    _activePage = _activePage + 1;
                    EasyLoading.dismiss();
                    if (_activePage == images.length - 1) {
                      isEnableNav = true;
                    }
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      ThemeClass.blueColor,
                      ThemeClass.blueColor3,
                    ],
                  ),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: ThemeClass.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingDetails(double height, int i) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height * 0.1,
        ),
        Container(
          height: height * 0.27,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(images[i].image.toString()),
              // fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(
          height: height * 0.07,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            images[i].title.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            images[i].description.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: ThemeClass.greyColor),
          ),
        ),
      ],
    );
  }

  Container _buildBottomDots() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: images.map((url) {
                    int index = images.indexOf(url);
                    return Container(
                      width: 10,
                      height: 10,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            _activePage == index
                                ? ThemeClass.blueColor
                                : ThemeClass.greyLightColor,
                            _activePage == index
                                ? ThemeClass.blueColor3
                                : ThemeClass.greyLightColor,
                          ],
                        ),
                        shape: BoxShape.circle,
                        color: _activePage == index
                            ? ThemeClass.blueColor
                            : ThemeClass.greyLightColor,
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingModel {
  String? image;
  String? title;
  String? description;

  OnboardingModel({this.image, this.title, this.description});
}
