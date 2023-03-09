import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:heal_u/themedata.dart';

class SliderProductDetailsWidget extends StatefulWidget {
  final List<String> image;
  const SliderProductDetailsWidget({Key? key, required this.image})
      : super(key: key);

  @override
  State<SliderProductDetailsWidget> createState() =>
      _SliderProductDetailsWidgetState();
}

class _SliderProductDetailsWidgetState
    extends State<SliderProductDetailsWidget> {
  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.3,
      width: width,
      child: Stack(
        children: [
          SizedBox(
            height: height * 0.3,
            width: width,
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 1,
                autoPlay: true,
                enlargeCenterPage: false,
                viewportFraction: 1,
                scrollDirection: Axis.horizontal,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _activePage = index;
                  });
                },
              ),
              items: <Widget>[
                for (var i = 0; i < widget.image.length; i++)
                  _buildSliderImage(i, height, width),
              ],
            ),
          ),
          Transform.translate(offset: Offset(0, 30), child: _buildIndicator())
        ],
      ),
    );
  }

  Padding _buildSliderImage(int i, double height, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Image.network(
        widget.image[i].toString(),
        height: height * 0.3,
        width: width,
        fit: BoxFit.contain,
      ),
    );
  }

  Align _buildIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 20,
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.image.map((e) {
                int index = widget.image.indexOf(e);
                return Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: _activePage == index
                          ? ThemeClass.blueColor
                          : ThemeClass.greyLightColor,
                      shape: BoxShape.circle),
                  height: 8,
                  width: 8,
                );
              }).toList()),
        ),
      ),
    );
  }
}

class SliderModel {
  String? image;
  String? title;
  String? subtitle;
  String? description;

  SliderModel({this.image, this.title, this.subtitle, this.description});
}
