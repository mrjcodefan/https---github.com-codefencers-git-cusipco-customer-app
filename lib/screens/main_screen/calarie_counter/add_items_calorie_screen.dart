import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/calarie_counter/model/item_list_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';

class AddItemsCalorieScreen extends StatefulWidget {
  AddItemsCalorieScreen({Key? key, required this.slug, required this.date})
      : super(key: key);
  final String slug;
  final String date;

  @override
  State<AddItemsCalorieScreen> createState() => _AddItemsCalorieScreenState();
}

class _AddItemsCalorieScreenState extends State<AddItemsCalorieScreen> {
  CarouselController buttonCarouselController = CarouselController();
  var _futureCall;
  @override
  void initState() {
    super.initState();
    _futureCall = _loadData();
  }

  Future<List<CalorieItem>?> _loadData() async {
    try {
      Map<String, String> queryParameters = {"calorie_category": widget.slug};

      var response = await HttpService.httpPost(
          "calorie-items", queryParameters,
          context: context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        CalorieItemListModel data = CalorieItemListModel.fromJson(body);

        if (data != null && data.status == "200") {
          print(data.data);
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
        ;
      } else {
        throw e.toString();
      }
    }
  }

  TextEditingController _searchController = TextEditingController();
  _filterList(String value) {
    setState(() {});
    print("------------- ${value}");
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
                title: "Add Items",
              )),
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFiledWidget(
                        onChange: (value) {
                          _filterList(value);
                        },
                        backColor: ThemeClass.whiteDarkshadow,
                        hinttext: "Search",
                        controllers: _searchController,
                        radius: 10,
                        oniconTap: () {
                          _filterList(_searchController.text);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        icon: "assets/images/search_icon.png",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                          future: _futureCall,
                          builder: (context,
                              AsyncSnapshot<List<CalorieItem>?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                if (snapshot.data != null) {
                                  if (snapshot.data!.isNotEmpty) {
                                    var list = snapshot.data!.where((element) =>
                                        element.title!
                                            .toLowerCase()
                                            .contains(_searchController.text));

                                    return Column(
                                      children: list
                                          .map(
                                            (e) => _buildListTile(e),
                                          )
                                          .toList(),
                                    );
                                  } else {
                                    return _buildDataNotFound1(
                                        "Data Not Found!");
                                  }
                                } else {
                                  return _buildDataNotFound1("Data Not Found!");
                                }
                              } else if (snapshot.hasError) {
                                return _buildDataNotFound1(
                                    snapshot.error.toString());
                              } else {
                                return _buildDataNotFound1("Data Not Found!");
                              }
                            } else {
                              return Container(
                                padding: EdgeInsets.only(
                                    top: height / 3, bottom: height / 3),
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: ThemeClass.blueColor),
                                ),
                              );
                            }
                          }),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Center _buildDataNotFound1(
    String text,
  ) {
    return Center(child: Text("$text"));
  }

  Column _buildListTile(CalorieItem data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    data.subTitle.toString(),
                    style: TextStyle(
                        fontSize: 10,
                        color: ThemeClass.greyColor,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      data.count.toString() + " Cal",
                      style: TextStyle(
                          fontSize: 14,
                          color: ThemeClass.blueColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      _addItem(data.id.toString());
                    },
                    icon: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: ThemeClass.blueColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 12,
                        color: ThemeClass.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(
          height: 30,
          thickness: 1,
          color: ThemeClass.greyLightColor1,
        ),
      ],
    );
  }

  _addItem(itemId) async {
    EasyLoading.show();
    try {
      Map<String, String> queryParameters = {
        "item_id": itemId,
        "date": widget.date
      };

      var response = await HttpService.httpPost(
          "save-calorie-item", queryParameters,
          context: context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          showToast("added Successfully");
          Navigator.pop(context, true);
        } else {
          showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else if (response.statusCode == 500) {
        showToast(GlobalVariableForShowMessage.internalservererror);
      } else {
        showToast(GlobalVariableForShowMessage.internalservererror);
      }
    } catch (e) {
      if (e is SocketException) {
        showToast(GlobalVariableForShowMessage.socketExceptionMessage);
      } else if (e is TimeoutException) {
        showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
        ;
      } else {
        showToast(e.toString());
      }
    }
    EasyLoading.dismiss();
  }
}
