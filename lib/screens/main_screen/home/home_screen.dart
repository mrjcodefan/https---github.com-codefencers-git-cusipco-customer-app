import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/home/Dental_care/dental_care_category_scree.dart';
import 'package:heal_u/screens/main_screen/home/Diet/diet_grid_screen.dart';

import 'package:heal_u/screens/main_screen/home/Doctor/doctors_category_screen.dart';
import 'package:heal_u/screens/main_screen/home/Food/food_grid_screen.dart';

import 'package:heal_u/screens/main_screen/home/fitness/fitness_category_screen.dart';
import 'package:heal_u/screens/main_screen/home/lab_category/lab_category_screen.dart';
import 'package:heal_u/screens/main_screen/home/skin_and_care/skin_grid_screen.dart';
import 'package:heal_u/screens/main_screen/home/store/store_grid_screen.dart';
import 'package:heal_u/screens/main_screen/home/therapy/therapy_screen.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_for_home.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_location.dart';

import 'package:heal_u/widgets/slider_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<HomeGridModel> GridItems = [];
  @override
  void initState() {
    super.initState();
    GridItems = [
      HomeGridModel(
        image: "assets/images/food_img.png",
        title: "Food",
        color: ThemeClass.pinkColor,
        id: "1",
        onPress: () {
          pushNewScreen(
            context,
            screen: FoodGridScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
      ),
      HomeGridModel(
        image: "assets/images/diet_img.png",
        title: "Diet",
        color: ThemeClass.skyblueColor2,
        id: "2",
        onPress: () {
          pushNewScreen(
            context,
            screen: DietGridScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
      ),
      HomeGridModel(
        image: "assets/images/fitness_img.png",
        title: "Fitness",
        color: ThemeClass.blueDarkColor1,
        id: "3",
        onPress: () {
          pushNewScreen(
            context,
            screen: FitnessGridScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
      ),
      HomeGridModel(
        image: "assets/images/store_img.png",
        title: "Store",
        color: ThemeClass.pinkColor1,
        id: "4",
        onPress: () {
          pushNewScreen(
            context,
            screen: StoreGridScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
      ),
      HomeGridModel(
          image: "assets/images/doctor_img.png",
          title: "Consult With Doctor",
          color: ThemeClass.blueDarkColor2,
          id: "5",
          onPress: () {
            pushNewScreen(
              context,
              screen: DoctorsCategoryScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          }),
      HomeGridModel(
        image: "assets/images/care_img.png",
        title: "Skin &  Hair Care",
        color: ThemeClass.pinkColor2,
        id: "6",
        onPress: () {
          pushNewScreen(
            context,
            screen: SkinCareGridScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
      ),
      HomeGridModel(
        image: "assets/images/dental_img.png",
        title: "Dental Care",
        color: ThemeClass.blueDarkColor1,
        id: "7",
        onPress: () {
          pushNewScreen(
            context,
            screen: DentalCareCategoryScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
      ),
      HomeGridModel(
        image: "assets/images/lab_img.png",
        title: "Lab Test",
        color: ThemeClass.pinkColor,
        id: "8",
        onPress: () {
          pushNewScreen(
            context,
            screen: LabCategoryScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
      ),
      HomeGridModel(
        image: "assets/images/therapy_img.png",
        title: "Therapy",
        color: ThemeClass.skyblueColor2,
        id: "9",
        onPress: () {
          pushNewScreen(
            context,
            screen: TherapyGridScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
      ),
    ];
  }

  CarouselController buttonCarouselController = CarouselController();
  int _activePage = 0;

  @override
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppbarForHomeWidget()),
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SliderWidget(
                      type: "home",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: (width - 60) /
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.8),
                                        crossAxisSpacing: 0,
                                        mainAxisSpacing: 0),
                                itemCount: GridItems.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return _buildCardItem(GridItems[index]);
                                }),
                          ]),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  InkWell _buildCardItem(HomeGridModel data) {
    return InkWell(
      onTap: () {
        data.onPress();
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(data.image.toString()),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                child: Text(
                  "${data.title.toString()}",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomeGridModel {
  String image;
  String title;
  Color color;
  String id;
  Function onPress;

  HomeGridModel(
      {required this.image,
      required this.title,
      required this.onPress,
      required this.color,
      required this.id});
}
