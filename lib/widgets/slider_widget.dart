import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:heal_u/model/slider_list_model.dart';
import 'package:heal_u/model/slider_model.dart';
import 'package:heal_u/service/prowider/initial_data_prowider.dart';
import 'package:heal_u/themedata.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SliderWidget extends StatefulWidget {
  SliderWidget({Key? key, required this.type}) : super(key: key);
  final String type; // home,fitness
  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Consumer<InitialDataService>(
        builder: (context, initdataService, child) {
      var sliderData = initdataService.globalSliderList;
      List<SlideData>? slider = [];
      if (sliderData != null) {
        if (widget.type == "home") {
          slider = [];
          if (sliderData.home != null) {
            slider.addAll(sliderData.home!.toList());
          }
        } else if (widget.type == "diet") {
          slider = [];
          if (sliderData.diet != null) {
            slider.addAll(sliderData.diet!.toList());
          }
        } else if (widget.type == "food") {
          slider = [];
          if (sliderData.food != null) {
            slider.addAll(sliderData.food!.toList());
          }
        } else if (widget.type == "fitness") {
          slider = [];

          if (sliderData.fitness != null) {
            slider.addAll(sliderData.fitness!.toList());
          }
        } else if (widget.type == "store") {
          slider = [];
          if (sliderData.store != null) {
            slider.addAll(sliderData.store!.toList());
          }
        } else if (widget.type == "skincare") {
          slider = [];

          if (sliderData.skincare != null) {
            slider.addAll(sliderData.skincare!.toList());
          }
        } else if (widget.type == "Therapy") {
          slider = [];

          if (sliderData.therapy != null) {
            slider.addAll(sliderData.therapy!.toList());
          }
        } else if (widget.type == "labtest") {
          slider = [];

          if (sliderData.labtest != null) {
            slider.addAll(sliderData.labtest!.toList());
          }
        } else if (widget.type == "dentalCare") {
          slider = [];

          if (sliderData.dentalCare != null) {
            slider.addAll(sliderData.dentalCare!.toList());
          }
        } else if (widget.type == "ConsultWithDoctor") {
          slider = [];

          if (sliderData.consultWithDoctor != null) {
            slider.addAll(sliderData.consultWithDoctor!.toList());
          }
        }
      }

      return slider.isEmpty
          ? SizedBox()
          : Container(
              height: height * 0.2,
              width: width,
              padding: EdgeInsets.only(top: 10),
              child: Stack(
                children: [
                  Container(
                    height: height * 0.2,
                    width: width,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 1,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        viewportFraction: 0.92,
                        scrollDirection: Axis.horizontal,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _activePage = index;
                          });
                        },
                      ),
                      items: <Widget>[
                        for (var i = 0; i < slider.length; i++)
                          _buildSliderImage(i, height, width, slider),
                      ],
                    ),
                  ),
                  Transform.translate(
                      offset: Offset(0, 10), child: _buildIndicator(slider))
                ],
              ),
            );
    });
  }

  void _launchURL(String _url) async {
    try {
      if (!await launch(_url)) throw 'Could not launch $_url';
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  InkWell _buildSliderImage(
      int i, double height, double width, List<SlideData>? globalSlider) {
    return InkWell(
      onTap: () {
        if (globalSlider![i].isClickable != null &&
            (globalSlider[i].isClickable.toString().toLowerCase() == "yes" ||
                globalSlider[i].isClickable.toString().toLowerCase() ==
                    "true" ||
                globalSlider[i].isClickable.toString().toLowerCase() == "1")) {
          _launchURL(globalSlider[i].redirectTo.toString());
        } else {}
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              CachedNetworkImage(
                height: height * 0.2,
                width: width,
                fit: BoxFit.cover,
                imageUrl: globalSlider![i].image.toString(),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(
                    child:
                        CircularProgressIndicator(color: ThemeClass.blueColor)),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
              Container(
                color: ThemeClass.blackColor.withOpacity(0.43),
                height: height * 0.2,
                width: width,
              ),
              Container(
                height: height * 0.2,
                width: width,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          globalSlider[i].title.toString(),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ThemeClass.whiteColor,
                            fontFamily: 'Oswald',
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        globalSlider[i].tagline.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ThemeClass.yellowColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Oswald',
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        globalSlider[i].description.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeClass.whiteColor,
                          fontFamily: 'Oswald',
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: ThemeClass.blueColor,
                        ),
                        child: Text(
                          "Learn More",
                          style: TextStyle(
                            color: ThemeClass.whiteColor,
                            fontSize: 8,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Align _buildIndicator(List<SlideData>? globalSlider) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 20,
          color: ThemeClass.skyblueColor,
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: globalSlider!.map((e) {
                  int index = globalSlider.indexOf(e);
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: _activePage == index
                            ? ThemeClass.whiteColor
                            : ThemeClass.blueColor,
                        shape: BoxShape.circle),
                    height: 10,
                    width: 10,
                  );
                }).toList()),
          ),
        ),
      ),
    );
  }
}
