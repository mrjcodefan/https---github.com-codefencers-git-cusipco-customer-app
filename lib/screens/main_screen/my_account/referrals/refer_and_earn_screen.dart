import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/screens/main_screen/my_account/referrals/referrals_service.dart';
import 'package:heal_u/screens/main_screen/my_account/referrals/share_reference_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/general_button.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

import 'package:url_launcher/url_launcher.dart';

enum Share {
  facebook,
  messenger,

  whatsapp,
  gmail,

  share_telegram,
  share
}

class ReferAndEarnScreen extends StatefulWidget {
  ReferAndEarnScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  @override
  void initState() {
    super.initState();
  }

  String refCode = "";
  String refLink = "";

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
                  Navigator.pop(context);
                },
                title: "Refer And Earn",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: Consumer<ReferralsService>(
                builder: (context, refdataService, child) {
              if (refdataService.referralsData == null) {
                return _reloadWidget();
              } else {
                if (refCode == "") {
                  refCode = refdataService.referralsData!.title.toString();
                }

                return _buildView(height, refdataService.referralsData);
              }
            }),
          ),
        ),
      ),
    );
  }

  _reloadWidget() {
    return TextButtonWidget(
      onPressed: () async {
        EasyLoading.show();

        var providerForRef =
            Provider.of<ReferralsService>(context, listen: false);
        await providerForRef.getReferralData();
        EasyLoading.dismiss();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.replay_outlined,
            size: 30,
            color: ThemeClass.blueColor,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Please Reload",
            style: TextStyle(color: ThemeClass.blackColor),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _buildView(
      double height, ShareAndReferralsData? referralsData) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildbackImage(height),
            _buildTitle(),
            _buildSubtitle(),
            SizedBox(
              height: 20,
            ),
            _buildDottedBox(referralsData!.code.toString()),
            SizedBox(
              height: 30,
            ),
            _buildDivider(),
            _buildShareTitle(),
            SizedBox(
              height: 10,
            ),
            _buildSocialIcon2(),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  TextButtonWidget _buildSocialBox(String image, Share type) {
    return TextButtonWidget(
      onPressed: () {
        print(type);
        shereTo(type);
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Row _buildSocialIcon2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialBox('assets/images/whatsapp.png', Share.whatsapp),
        SizedBox(
          width: 20,
        ),
        _buildSocialBox('assets/images/gmail.png', Share.gmail),
        SizedBox(
          width: 20,
        ),
        _buildSocialBox('assets/images/shaer.png', Share.share),
      ],
    );
  }

  Padding _buildShareTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Center(
        child: Text(
          "Share your Referral Code via",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: ThemeClass.blueColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  DottedBorder _buildDottedBox(String code) {
    return DottedBorder(
      color: ThemeClass.blueColor,
      borderType: BorderType.RRect,
      radius: Radius.circular(12),
      strokeWidth: 2,
      dashPattern: [10, 2],
      child: Container(
        decoration: BoxDecoration(
            color: ThemeClass.skyblueColor1,
            borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your referral code",
                        style: TextStyle(
                          fontSize: 10,
                          color: ThemeClass.greyDarkColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        code,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 15,
                    height: 40,
                    // height: 50,
                    padding: EdgeInsets.symmetric(vertical: 1),
                    child: VerticalDivider(
                      color: ThemeClass.greyMediumColor,
                      thickness: 1,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      print(code);

                      Clipboard.setData(ClipboardData(text: code))
                          .then((value) {
                        showToast("$code code copied");
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/two_squre.png",
                          height: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Copy",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: ThemeClass.greyDarkColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "Code",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: ThemeClass.greyDarkColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Padding _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Center(
        child: Text(
          "Your Friend gets 50 HealU points on signup and, you get 100 HealU points too everytime!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: ThemeClass.greyColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 5),
      child: Center(
        child: Text(
          "Refer your friend and earn",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: ThemeClass.blueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Container _buildbackImage(double height) {
    return Container(
      height: height * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/refer_image.png"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Divider(
        thickness: 1,
        color: ThemeClass.greyLightColor1,
      ),
    );
  }

  Future<void> shereTo(
    Share share,
  ) async {
    String msg = refCode;

    String? response;
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    switch (share) {
      case Share.whatsapp:
        try {
          response = await flutterShareMe.shareToWhatsApp(msg: msg).then((
            value,
          ) {
            if (value!.contains("PlatformException")) {
              showToast("Whatsapp is not installed");
            } else {
              showToast(value.toString().replaceAll("false:", ""));
            }
          }, onError: (err) {
            showToast(err.toString());
          });
        } catch (e) {
          print("object4");

          showToast(e.toString());
        }
        break;
      case Share.messenger:
        var uri = 'sms:?body=$msg';
        if (await canLaunch(uri)) {
          await launch(uri);
        }
        break;
      case Share.facebook:
        try {
          FlutterShareMe()
              .shareToFacebook(url: 'https://github.com/lizhuoyuan', msg: msg);
          // print("------------------------------------1");
          // response =
          //     await flutterShareMe.shareToFacebook(msg: msg).then((value) {
          //   print("------------------------------------$value");
          //   // showToast(value.toString());
          // });
          // print("------------------------------------2");
        } catch (e) {
          showToast(e.toString());
        }
        break;

      case Share.share_telegram:
        try {
          response =
              await flutterShareMe.shareToTelegram(msg: msg).then((value) {
            print(value);
            showToast(value.toString().replaceAll("false:", ""));
          });
        } catch (e) {
          showToast(e.toString());
        }
        break;
      case Share.gmail:
        sendUrlGmail(msg);
        break;
      case Share.share:
        response = await flutterShareMe.shareToSystem(msg: msg);
        break;
    }
    debugPrint("------->${response}");
  }

  sendUrlGmail(String code) async {
    try {
      if (Platform.isAndroid) {
        launch("mailto:?subject=${code}&body=${code}");
      } else {
        final Uri params = Uri(
          scheme: 'mailto',
          path: '',
          query: 'subject=${code}&body=${code}', //add subject and body here
        );
        var url = params.toString();
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }
    } catch (e) {
      showToast(e.toString());
    }
  }
}
