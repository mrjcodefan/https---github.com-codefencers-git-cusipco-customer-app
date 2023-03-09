import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:heal_u/model/general_information_model.dart';
import 'package:heal_u/service/prowider/general_information_service.dart';
import 'package:heal_u/service/prowider/main_navigaton_prowider_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  CarouselController buttonCarouselController = CarouselController();

  @override
  void initState() {
    super.initState();
  }

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
              child: AppBarWithTextAndBackWidget(
                onbackPress: () {
                  Provider.of<MainNavigationProwider>(context, listen: false)
                      .chaneIndexOfNavbar(0);
                },
                title: "Support",
                isShowCart: true,
                // isFalseBack
              )),
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      "assets/images/support_image.png",
                      height: height * 0.4,
                    ),
                    Consumer<GeneralInfoService>(
                        builder: (context, generalInfoService, child) {
                      return Column(
                        children: [
                          _buildBox(context, generalInfoService.generalData),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: ButtonWidget(
                                title: "Call Us",
                                color: ThemeClass.blueColor,
                                callBack: () {
                                  _launchURL(generalInfoService
                                      .generalData!.contactNo
                                      .toString());
                                }),
                          ),
                        ],
                      );
                    }),
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

  Padding _buildBox(BuildContext context, GeneralInformation? data) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: ThemeClass.skyblueColor1),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Emergency Help Needed?',
              style: TextStyle(
                  color: ThemeClass.blueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Divider(
                height: 1,
                thickness: 1,
                color: ThemeClass.blueColor,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/telephone_icon.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      data!.contactNo.toString(),
                      style: TextStyle(
                          color: ThemeClass.blueColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/email_icon.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      data.contactEmail.toString(),
                      style: TextStyle(
                          color: ThemeClass.blueColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String _url) async {
    try {
      if (!await launch("tel://${_url}")) throw 'Could not launch $_url';
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
