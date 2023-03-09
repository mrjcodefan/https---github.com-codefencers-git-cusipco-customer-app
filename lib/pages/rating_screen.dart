import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_normal.dart';

class RatingScreen extends StatefulWidget {
  RatingScreen(
      {Key? key,
      required this.id,
      required this.ownerId,
      required this.isOrder})
      : super(key: key);
  final String id;
  final String ownerId;
  final bool isOrder;
  // final String? from;
  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool _isShowDeliveryRating = false;
  TextEditingController _textController = TextEditingController();
  TextEditingController _textDeliveryController = TextEditingController();
  double rating = 4.5;
  double ratingDelivery = 4.5;

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
                title: "Submit Review",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              // ignore: prefer_const_literals_to_create_immutables
              child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
                // ignore: prefer_const_literals_to_create_immutables
                child: _isShowDeliveryRating
                    ? FadeAnimationWidget(child: _buildViewDeliveryRating())
                    : _buildViewOrderRating(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewOrderRating() {
    return (Column(
      // ignore: prefer_const_literals_to_create_immutables
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rate your experience",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          unratedColor: ThemeClass.greyLightColor,
          itemPadding: EdgeInsets.only(right: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: ThemeClass.blueColor,
          ),
          onRatingUpdate: (rating1) {
            setState(() {
              rating = rating1;
            });
          },
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: ThemeClass.greyLightColor1,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Tell us something",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 15,
        ),
        TextBoxSimpleWidget(
            minLine: 6, radius: 10, hinttext: "", controllers: _textController),
        SizedBox(
          height: 40,
        ),
        _buildBottomButton(() {
          submitReview();
        })
      ],
    ));
  }

  Column _buildViewDeliveryRating() {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rate your Delivery",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
        RatingBar.builder(
          initialRating: ratingDelivery,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          unratedColor: ThemeClass.greyLightColor,
          itemPadding: EdgeInsets.only(right: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: ThemeClass.blueColor,
          ),
          onRatingUpdate: (rating1) {
            setState(() {
              ratingDelivery = rating1;
            });
          },
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: ThemeClass.greyLightColor1,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Tell us something",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 15,
        ),
        TextBoxSimpleWidget(
            minLine: 6,
            radius: 10,
            hinttext: "",
            controllers: _textDeliveryController),
        SizedBox(
          height: 40,
        ),
        _buildBottomButton(() {
          submitReview();
        })
      ],
    );
  }

  Align _buildBottomButton(Function callback) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        child: ButtonWidget(
          title: "Submit",
          color: ThemeClass.blueColor,
          callBack: () {
            // Navigator.pop(context);
            callback();
          },
        ),
      ),
    );
  }

  _showDeliveryRatingScreen() {
    setState(() {
      _isShowDeliveryRating = true;
    });
  }

  submitReview() async {
    EasyLoading.show();

    try {
      Map<String, String> queryParameters = {};

      queryParameters = {
        "owner_id": widget.ownerId.toString(),
        "item_id": widget.id.toString(),
        "rating": rating.toString(),
        "review": _textController.text.toString(),
      };

      if (widget.isOrder) {
        if (_isShowDeliveryRating == true) {
          queryParameters.addAll({
            "delivery_rating": ratingDelivery.toString(),
            "delivery_review": _textDeliveryController.text.toString()
          });
        }
      }

      var response = await HttpService.httpPost("submitReview", queryParameters,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          if (widget.isOrder) {
            if (_isShowDeliveryRating == true) {
              showToast(res['message']);
              Navigator.pop(context);
            } else {
              _showDeliveryRatingScreen();
            }
          } else {
            showToast(res['message']);
            Navigator.pop(context, true);
          }
        } else {
          showToast(res['message']);
          Navigator.pop(context);
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
      }
    } catch (e) {
      if (e is SocketException) {
        showToast(GlobalVariableForShowMessage.socketExceptionMessage);
      } else if (e is TimeoutException) {
        showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
      } else {
        showToast(e.toString());
      }
    } finally {
      EasyLoading.dismiss();
    }
  }
}

class FadeAnimationWidget extends StatefulWidget {
  FadeAnimationWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  State<FadeAnimationWidget> createState() => _FadeAnimationWidgetState();
}

class _FadeAnimationWidgetState extends State<FadeAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInBack);
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(opacity: _animation, child: widget.child));
  }
}
