import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/my_recommandation_model.dart';

import 'package:heal_u/screens/main_screen/home/Food/restaurant_manu_list_screen.dart';
import 'package:heal_u/screens/main_screen/home/fitness/membership_details_screen.dart';
import 'package:heal_u/screens/main_screen/home/skin_and_care/global_product_detail_screen.dart';
import 'package:heal_u/screens/main_screen/home/store/store_product_details_screen.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';

import 'package:heal_u/widgets/button_widget/small_blue_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MyRecommendationScreen extends StatefulWidget {
  MyRecommendationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyRecommendationScreen> createState() => _MyRecommendationScreenState();
}

class _MyRecommendationScreenState extends State<MyRecommendationScreen> {
  var _futureCall;
  @override
  void initState() {
    super.initState();
    _futureCall = _loadData();
  }

  Future<List<RecommandationData>?> _loadData() async {
    try {
      Map<String, String> queryParameters = {"id": ""};

      var response = await HttpService.httpGet("myrecommendations-list");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        MyRecommandationModel data = MyRecommandationModel.fromJson(body);

        if (data != null && data.status == "200") {
          return data.data;
        } else {
          throw GlobalVariableForShowMessage.internalservererror;
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else if (response.statusCode == 500) {
        throw GlobalVariableForShowMessage.internalservererror;
      } else {
        throw GlobalVariableForShowMessage.internalservererror;
      }
    } catch (e) {
      if (e is SocketException) {
        throw GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        throw GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        throw e.toString();
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
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBarWithTextAndBackWidget(
                onbackPress: () {
                  Navigator.pop(context);
                },
                title: "My Recommendations",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: FutureBuilder(
                future: _futureCall,
                builder: (context,
                    AsyncSnapshot<List<RecommandationData>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        if (snapshot.data!.isNotEmpty) {
                          return _buildview(snapshot.data);
                        } else {
                          return _buildDataNotFound1("Data Not Found!");
                        }
                      } else {
                        return _buildDataNotFound1("Data Not Found!");
                      }
                    } else if (snapshot.hasError) {
                      return _buildDataNotFound1(snapshot.error.toString());
                    } else {
                      return _buildDataNotFound1("Data Not Found!");
                    }
                  } else {
                    return Container(
                      // padding: EdgeInsets.only(
                      //     top: height / 3, bottom: height / 3),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: ThemeClass.blueColor),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  Center _buildDataNotFound1(
    String text,
  ) {
    return Center(child: Text("$text"));
  }

  _buildview(List<RecommandationData>? data) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data!.map((e) => _buildCard(e, data.indexOf(e))).toList(),
      ),
    );
  }

  Container _buildCard(RecommandationData data, index) {
    return Container(
      color: index % 2 != 0 ? ThemeClass.skyblueColor1 : ThemeClass.whiteColor,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardDateTime(data.date.toString(), data.time.toString()),
          SizedBox(
            height: 10,
          ),
          _buildCardTitle(data.title.toString()),
          SizedBox(
            height: 10,
          ),
          _buildCardDesc(data.description.toString()),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            width: 100,
            child: ButtonSmallWidget(
              color: ThemeClass.blueColor,
              title: "Check now",
              callBack: () {
                _navigateToNewScreen(data);
              },
            ),
          ),
        ],
      ),
    );
  }

  Text _buildCardDesc(String desc) {
    return Text(
      desc,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 10,
          color: ThemeClass.greyDarkColor),
    );
  }

  Text _buildCardTitle(String title) {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: ThemeClass.blueColor),
    );
  }

  Row _buildCardDateTime(String date, String time) {
    return Row(
      children: [
        Container(
            height: 16,
            width: 16,
            child: Image.asset("assets/images/calender_simple.png")),
        Text(
          date,
          style: TextStyle(fontSize: 10, color: ThemeClass.greyDarkColor),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
            height: 16,
            width: 16,
            child: Image.asset("assets/images/timer.png")),
        Text(
          time,
          style: TextStyle(fontSize: 10, color: ThemeClass.greyDarkColor),
        )
      ],
    );
  }

  _navigateToNewScreen(RecommandationData data1) {
    print(data1.productTitle.toString());
    print(data1.typeId.toString());
    print(data1.type.toString());

    if (data1.type.toString() == "Fitness") {
      pushNewScreen(
        context,
        screen: MemberShipDetailsScreen(
          productId: data1.typeId.toString(),
        ),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } else if (data1.type.toString() == "Store") {
      pushNewScreen(
        context,
        screen: StoreProductDetailsScreen(id: data1.typeId.toString()),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } else if (data1.type.toString() == "Restaurant") {
      pushNewScreen(
        context,
        screen: ResturantManuListScreen(
            resturentName: data1.productTitle.toString(),
            resturentId: data1.typeId.toString()),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } else if (data1.type.toString() == "DentalCare" ||
        data1.type.toString() == "LabTest" ||
        data1.type.toString() == "Therapy") {
      pushNewScreen(
        context,
        screen: GlobalProductdetails(
          id: data1.typeId.toString(),
          urlPerameter: data1.type.toString(),
          title: data1.productTitle.toString(),
        ),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    }

    // pushNewScreen(
    //   context,
    //   screen: GlobalProductdetails(
    //     id: data.typeId.toString(),
    //     urlPerameter: data.type.toString(),
    //     title: data.productTitle.toString(),
    //   ),
    //   withNavBar: true,
    //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // );
  }
}
