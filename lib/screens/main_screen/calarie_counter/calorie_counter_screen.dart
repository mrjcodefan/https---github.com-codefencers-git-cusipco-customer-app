import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/calarie_counter/add_items_calorie_screen.dart';
import 'package:heal_u/screens/main_screen/calarie_counter/model/calorie_dashboard_model.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/edit_family_member.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';
import 'package:heal_u/screens/main_screen/my_account/profile/my_profile_screen.dart';

import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/prowider/main_navigaton_prowider_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/general_button.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CalorieCounterScreen extends StatefulWidget {
  CalorieCounterScreen({Key? key}) : super(key: key);

  @override
  State<CalorieCounterScreen> createState() => _CalorieCounterScreenState();
}

class _CalorieCounterScreenState extends State<CalorieCounterScreen> {
  CarouselController buttonCarouselController = CarouselController();
  String _currentDataToDisplay = "";
  String _currentDataToSend = "";

  DateTime currentDate = DateTime.now();
  String _currentDateToComapare = "";
  var _futureCall;

  @override
  void initState() {
    super.initState();
    _setDAta();
  }

  _setDAta() {
    setState(() {
      _currentDataToDisplay = DateFormat('dd MMMM yyyy').format(currentDate);
      _currentDataToSend = DateFormat('yyyy-MM-dd').format(currentDate);
      _currentDateToComapare = _currentDataToSend;
    });

    _futureCall =
        _loadData(_currentDataToDisplay, _currentDataToSend, currentDate);
  }

  Future<CalorieDashboardData?> _loadData(
      String dataToDis, String dataToSend, DateTime pickedDat1) async {
    try {
      Map<String, String> queryParameters = {"date": dataToSend};

      print(queryParameters);

      var response = await HttpService.httpPost(
          "calorie-dashboard", queryParameters,
          context: context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        CalorieDashboardModel data = CalorieDashboardModel.fromJson(body);

        // if (data != null && data.status == "200") {
        //   setState(() {
        //     currentDate = pickedDat1;
        //     _currentDataToSend = dataToSend;
        //     _currentDataToDisplay = dataToDis;
        //   });
        //   return data.data;
        // } else {
        //   throw GlobalVariableForShowMessage.internalservererror;
        // }

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          setState(() {
            currentDate = pickedDat1;
            _currentDataToSend = dataToSend;
            _currentDataToDisplay = dataToDis;
          });
          return data.data;
        } else {
          throw body['message'].toString();
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
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 7,
      ),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeClass.blueColor, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: ThemeClass.blueColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        var _currentDataToDisplay =
            DateFormat('dd MMMM yyyy').format(pickedDate);
        var _currentDataToSend = DateFormat('yyyy-MM-dd').format(pickedDate);

        _futureCall =
            _loadData(_currentDataToDisplay, _currentDataToSend, pickedDate);
      });
    }
  }

  showAlertDialog(bool isMember, data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Text("Update Your Profile"),
          content: Text("Height,Weight and Activity require for calory."),
          actions: [
            TextButtonWidget(
              child: Text("Ok"),
              onPressed: () async {
                print("called");

                if (isMember) {
                  await pushNewScreen(
                    context1,
                    screen: EditFamilyMemberScreen(
                      familyData: data,
                    ),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                } else {
                  await pushNewScreen(
                    context,
                    screen: MyProfileScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                }

                Navigator.pop(context1);
              },
            ),
            TextButtonWidget(
              child: Text("Cancel"),
              onPressed: () {
                Provider.of<MainNavigationProwider>(context1, listen: false)
                    .chaneIndexOfNavbar(0);
                Navigator.pop(context1);
              },
            )
          ],
        );
      },
    );
  }

  bool isShowError = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return VisibilityDetector(
      key: Key("callory"),
      onVisibilityChanged: (info) {
        bool isVisible = info.visibleFraction != 0;

        if (isVisible) {
          var familyprowider =
              Provider.of<FamilyMemberService>(context, listen: false);
          var user = Provider.of<UserPrefService>(context, listen: false);
          if (familyprowider.isSelectFamilyMember == true) {
            if (familyprowider.currentFamilyMember!.height == "" ||
                familyprowider.currentFamilyMember!.weight == "" ||
                familyprowider.currentFamilyMember!.activity == "") {
              print("member not valid");

              setState(() {
                isShowError = false;
              });
              showAlertDialog(true, familyprowider.currentFamilyMember);
            } else {
              setState(() {
                isShowError = true;
              });
              print("member is valid");
            }
          } else {
            if (user.globleUserModel!.data!.height == "" ||
                user.globleUserModel!.data!.weight == "" ||
                user.globleUserModel!.data!.activity == "") {
              print("user not valid");
              setState(() {
                isShowError = false;
              });
              showAlertDialog(false, user.globleUserModel!.data!);
            } else {
              setState(() {
                isShowError = true;
              });
              print("user is valid");
            }
          }
        }
      },
      child: Container(
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
                title: "Calorie Counter",
              ),
            ),
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
                        _buildRowTitle(),
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                            future: _futureCall,
                            builder: (context,
                                AsyncSnapshot<CalorieDashboardData?> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  if (snapshot.data != null) {
                                    return Column(
                                      children: [
                                        _buildBox(
                                            context,
                                            snapshot.data!.caloriesEaten
                                                .toString()),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        ...snapshot.data!.list!
                                            .map(
                                              (e) => _buildListTile(e),
                                            )
                                            .toList(),
                                        SizedBox(
                                          height: 40,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return _buildDataNotFound1(
                                        "Data Not Found!");
                                  }
                                } else if (snapshot.hasError) {
                                  if (isShowError) {
                                    return _buildDataNotFound1(
                                        snapshot.error.toString());
                                  } else {
                                    return SizedBox();
                                  }
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
      ),
    );
  }

  Center _buildDataNotFound1(
    String text,
  ) {
    return Center(
        child: Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.width - 150),
      child: Text("$text"),
    ));
  }

  Column _buildListTile(ListElement data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                data.title.toString(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      data.value.toString() + " Cal",
                      style: TextStyle(
                          fontSize: 14,
                          color: ThemeClass.blueColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddItemsCalorieScreen(
                              slug: data.slug.toString(),
                              date: _currentDataToSend),
                        ),
                      );

                      if (res == true) {
                        _futureCall = _loadData(_currentDataToDisplay,
                            _currentDataToSend, currentDate);
                      }
                    },
                    child: Container(
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
                  )
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

  Container _buildBox(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: ThemeClass.skyblueColor1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: ThemeClass.blueColor),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/spoon.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: ThemeClass.blueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Calories Eaten',
                    style: TextStyle(
                        color: ThemeClass.greyColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/chart.png'),
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
    );
  }

  Row _buildRowTitle() {
    return Row(
      children: [
        Text(
          _currentDataToDisplay,
          style: TextStyle(
            fontSize: 16,
            color: ThemeClass.blueColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 1,
              color: ThemeClass.blueColor,
            ),
          ),
        ),
        TextButtonWidget(
          onPressed: () {
            _selectDate(context);
          },
          child: Image.asset(
            "assets/images/calender_simple.png",
            height: 35,
            width: 35,
          ),
        )
      ],
    );
  }
}

class CalorieTestModel {
  String title;
  String subtitle;

  CalorieTestModel({
    required this.title,
    required this.subtitle,
  });
}
