import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/screens/main_screen/checkout/checkout_for_other.dart';

import 'package:heal_u/screens/main_screen/home/Food/model/my_subscription_model.dart';
import 'package:heal_u/screens/main_screen/my_account/my_subscription/my_subscription_sevice.dart';
import 'package:heal_u/screens/main_screen/my_account/my_subscription/subscription_details_screen.dart';
import 'package:heal_u/service/download_server.dart';
import 'package:heal_u/service/save_file_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ActivePlansAndSubscritionScreen extends StatefulWidget {
  ActivePlansAndSubscritionScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ActivePlansAndSubscritionScreen> createState() =>
      _ActivePlansAndSubscritionScreenState();
}

class _ActivePlansAndSubscritionScreenState
    extends State<ActivePlansAndSubscritionScreen> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  bool _isLoading = false;
  getdata() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<MySubscriptionService>(context, listen: false)
        .getMySubscription();
    setState(() {
      _isLoading = false;
    });
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
                  Navigator.pop(context);
                },
                isShowCart: true,
                title: "Your Plans & Subscriptions",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: _isLoading
                ? Center(
                    child:
                        CircularProgressIndicator(color: ThemeClass.blueColor),
                  )
                : Consumer<MySubscriptionService>(
                    builder: (context, mySubscription, child) {
                    return _buildView(
                        mySubscription.dietPlans, mySubscription.restaurants);
                  }),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView _buildView(List<MySubscriptionDataDietPlan>? dietPlans,
      List<MySubscriptionDataRestaurant>? restaurants) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      // ignore: prefer_const_literals_to_create_immutables
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Subscribed by You",
              style: TextStyle(
                fontSize: 14,
                color: ThemeClass.blueColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildDivider(),
            ...restaurants!
                .map((e) => Column(
                      children: [
                        _buildFirstRow(e),
                        _buildDivider(),
                      ],
                    ))
                .toList(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Active Plans",
              style: TextStyle(
                fontSize: 14,
                color: ThemeClass.blueColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _buildDivider(),
            ...dietPlans!
                .map((e) => Column(
                      children: [
                        _buildActivePlans(e),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ))
                .toList(),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }

  Container _buildActivePlans(MySubscriptionDataDietPlan dietPlan) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeClass.skyblueColor1,
        borderRadius: BorderRadius.circular(10),
      ),
      // height: 400,
      child: Column(
        children: [
          _buildActivePlansBanner(dietPlan),
          SizedBox(
            height: 20,
          ),
          ...dietPlan.benefits!
              .map((e) => _buildCardlines(e.title.toString()))
              .toList(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _buildDivider(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: _buildInCardDate(
                      "Purchased Date", dietPlan.purchaseDate.toString(), true),
                ),
                _buildVerticalLine(),
                Expanded(
                  flex: 4,
                  child: _buildInCardDate(
                      "Expiry Date", dietPlan.expiryDate.toString(), false),
                ),
              ],
            ),
          ),
          dietPlan.dietChartUrl.toString() == ""
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      showAlertDialogProgress(
                          context, [dietPlan.dietChartUrl.toString()]);
                      // _downloadPdf(
                      //     'http://healu.codefencers.com/default/default-508X320.jpg');
                    },
                    child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            border: Border.all(color: ThemeClass.blueColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.file_download_outlined,
                                color: ThemeClass.blueColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Download Diet chart",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                  color: ThemeClass.blueColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Row _buildInCardDate(String title, String date, bool isGreen) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/calender_simple.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  overflow: TextOverflow.ellipsis,
                  color: isGreen ? ThemeClass.greenColor : ThemeClass.redColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                date,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  color: ThemeClass.blueColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Padding _buildCardlines(text) {
    return Padding(
      padding: EdgeInsets.only(left: 20, bottom: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/checked_squre.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: ThemeClass.greyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }

  Stack _buildActivePlansBanner(MySubscriptionDataDietPlan dietPlan) {
    return Stack(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(dietPlan.image.toString()),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
            // color: ThemeClass.redColor,
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.black,
                Colors.white.withOpacity(0.4),
                Colors.black,
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 30,
            left: 15,
            child: Text(
              dietPlan.title.toString(),
              style: TextStyle(
                fontSize: 20,
                color: ThemeClass.whiteColor,
                fontWeight: FontWeight.w500,
              ),
            )),
        Positioned(
            bottom: 10,
            left: 15,
            child: Text(
              "₹${dietPlan.price.toString()}",
              style: TextStyle(
                fontSize: 14,
                color: ThemeClass.whiteColor,
                fontWeight: FontWeight.w500,
              ),
            ))
      ],
    );
  }

  InkWell _buildFirstRow(MySubscriptionDataRestaurant restaurant) {
    return InkWell(
      onTap: () {
        if ((restaurant.status!.toLowerCase() == "complete" ||
                restaurant.status!.toLowerCase() == "approved") &&
            (restaurant.showPaymentOption!.toLowerCase() != "1" ||
                restaurant.isExpired!.toLowerCase() != "0")) {
          pushNewScreen(
            context,
            screen: SubscriptionDetailsScreen(
              id: restaurant.id.toString(),
            ),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }
      },
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              image: DecorationImage(
                                image:
                                    NetworkImage(restaurant.image.toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.title.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              restaurant.days.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: ThemeClass.greyColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _buildVerticalLine(),

              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(
                          fontSize: 10,
                          color: ThemeClass.greyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        restaurant.status.toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: ThemeClass.blueColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (restaurant.status!.toLowerCase() == "complete" ||
                      restaurant.status!.toLowerCase() == "approved")
                  ? _buildVerticalLine()
                  : SizedBox(),
              (restaurant.status!.toLowerCase() == "complete" ||
                      restaurant.status!.toLowerCase() == "approved")
                  ? (restaurant.showPaymentOption!.toLowerCase() == "1" &&
                          restaurant.isExpired!.toLowerCase() == "0")
                      ? Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [_buildButton(restaurant, "Pay Now")],
                            ),
                          ),
                        )
                      : Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    "View",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 12,
                                      color: ThemeClass.blueColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                restaurant.isExpired!.toLowerCase() == "1" &&
                                        restaurant.showPaymentOption!
                                                .toLowerCase() ==
                                            "1"
                                    ? _buildButton(restaurant, "Renew")
                                    : SizedBox()
                              ],
                            ),
                          ),
                        )
                  : Text("        "),
              // Expanded(
              //   flex: 1,
              //   child: Image.asset(
              //     "assets/images/three_dots.png",
              //     height: 30,
              //   ),
              // ),
            ],
          ),
          // Positioned.fill(
          //     child: Align(
          //   alignment: Alignment.bottomLeft,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 5),
          //     color: ThemeClass.redColor.withOpacity(0.7),
          //     child: Text(
          //       "Expired",
          //       style: TextStyle(fontSize: 12, color: ThemeClass.whiteColor),
          //     ),
          //   ),
          // )),
        ],
      ),
    );
  }

  InkWell _buildButton(MySubscriptionDataRestaurant restaurant, String title) {
    return InkWell(
      onTap: () {
        _payNow(restaurant);
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(1, 3),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: ThemeClass.redColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        child: Text(
          title,
          style: TextStyle(fontSize: 10, color: ThemeClass.whiteColor),
        ),
      ),
    );
  }

  Expanded _buildVerticalLine() {
    return Expanded(
      flex: 1,
      child: Container(
        width: 5,
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 22),
        child: VerticalDivider(
          color: ThemeClass.greyLightColor1,
          thickness: 1,
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

  _payNow(MySubscriptionDataRestaurant data) async {
    // --------- open checkout ----------

    var res = await pushNewScreen(
      context,
      screen: CheckoutForOtherScreen(
        moduleView: 2,
        resturentData: data,
        tax: data.tax.toString(),
      ),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );

    if (res == true) {
      getdata();
    }
    // var res2 = await Navigator.of(context, rootNavigator: true).push(
    //   MaterialPageRoute<bool>(
    //     builder: (BuildContext context) => WebViewScreen(url: value.toString()),
    //   ),
    // );

    // if (res2 == true) {
    //   showToast("Payment Successfully Done.");
    //   getdata();
    // } else {
    //   showToast("Payment Failed.");
    // }
  }

  _downloadPdf(String url) async {
    try {
      EasyLoading.show();
      var path = await SaveFileService().createFolder(url);
      final _result = await OpenFile.open(path.path);
      print(_result.message);
    } catch (e) {
      showToast(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future showAlertDialogProgress(
      BuildContext context, List<String> urlList) async {
    var permissionval = await requestPermission(Permission.storage, context);

    if (permissionval == true) {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context1) {
          return DownloadAlertDialogWidget(
            urlList: urlList,
          );
        },
      );
    } else {
      showToast(
        "Please Give Storage Permission for Download.",
      );
    }
  }
}
