import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/category_model.dart';
import 'package:heal_u/screens/main_screen/home/global_product_list_screen.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/grid_list_tile_widget.dart';
import 'package:heal_u/widgets/slider_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DentalCareCategoryScreen extends StatefulWidget {
  DentalCareCategoryScreen({Key? key}) : super(key: key);

  @override
  State<DentalCareCategoryScreen> createState() =>
      _DentalCareCategoryScreenState();
}

class _DentalCareCategoryScreenState extends State<DentalCareCategoryScreen> {
  CarouselController buttonCarouselController = CarouselController();

  var _futureCall;
  @override
  void initState() {
    super.initState();
    _futureCall = getCategoryData();
  }

  Future<List<CategoryData>?> getCategoryData() async {
    try {
      Map<String, String> queryParameters = {
        "module": "DentalCare",
      };

      var response = await HttpService.httpPost("categories", queryParameters,
          context: context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        CategoryModel data = CategoryModel.fromJson(body);

        if (data != null && data.status == "200") {
          return data.data;
        } else {
          throw GlobalVariableForShowMessage.internalservererror;
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        throw GlobalVariableForShowMessage.internalservererror;
      }
    } catch (e) {
      if (e is SocketException) {
        throw GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        throw GlobalVariableForShowMessage.timeoutExceptionMessage;
        ;
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
                title: "Dental Care",
                isShowCart: true,
              )),
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SliderWidget(
                      type: "dentalCare",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                        future: _futureCall,
                        builder: (context,
                            AsyncSnapshot<List<CategoryData>?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              if (snapshot.data != null) {
                                if (snapshot.data!.isNotEmpty) {
                                  var list = snapshot.data!;

                                  return _buildGrid(width, context, list);
                                } else {
                                  return Container(
                                    // height: height,
                                    child:
                                        _buildDataNotFound1("Data Not Found!"),
                                  );
                                }
                              } else {
                                return _buildDataNotFound1("Data Not Found!");
                              }
                            } else if (snapshot.hasError) {
                              // return Center(child: Text(snapshot.error.toString()));
                              return _buildDataNotFound1(
                                  snapshot.error.toString());
                            } else {
                              return _buildDataNotFound1("Data Not Found!");
                            }
                          } else {
                            return Container(
                              padding: EdgeInsets.only(top: height / 5),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ThemeClass.blueColor,
                                ),
                              ),
                            );
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "assets/images/dental_care_bg.png",
                      width: width * 0.9,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Container _buildDataNotFound1(
    String text,
  ) {
    return Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width / 3,
            bottom: MediaQuery.of(context).size.width / 3),
        child: Center(child: Text("$text")));
  }

  Padding _buildGrid(
      double width, BuildContext context, List<CategoryData> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio:
                  (width - 60) / (MediaQuery.of(context).size.height / 1.8),
              crossAxisSpacing: 0,
              mainAxisSpacing: 0),
          itemCount: data.length,
          itemBuilder: (BuildContext ctx, index) {
            return GridListTileWidget(
                data: data[index],
                callback: () {
                  pushNewScreen(
                    context,
                    screen: productListScreen(
                      categoryId: data[index].id.toString(),
                      routeName: "DentalCare",
                    ),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                });
            // _buildCardItem(data[index]);
          }),
    );
  }

  InkWell _buildCardItem(CategoryData data) {
    return InkWell(
      onTap: () {
        // data.onPress();
        pushNewScreen(
          context,
          screen: productListScreen(
            categoryId: data.id.toString(),
            routeName: "DentalCare",
          ),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
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
                    image: NetworkImage(data.image.toString()),
                    fit: BoxFit.fill,
                  ),
                ),
                // child: Image.network(
                //   data.image.toString(),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
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
            ),
          )
        ],
      ),
    );
  }
}
