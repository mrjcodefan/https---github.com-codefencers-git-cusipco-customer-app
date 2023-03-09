import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_animated/auto_animated.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/doctor_list_model.dart';
import 'package:heal_u/screens/main_screen/home/Doctor/about_doctor_screen.dart';
import 'package:heal_u/screens/main_screen/home/store/store_product_details_screen.dart';

import 'package:heal_u/screens/main_screen/home/store/store_product_list_model.dart';

import 'package:heal_u/service/animation_service.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/prowider/doctor_list_provider.dart';
import 'package:heal_u/service/prowider/location_prowider_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_location.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class DoctorListScreen extends StatefulWidget {
  DoctorListScreen({Key? key, required this.categoryId, required this.mode})
      : super(key: key);
  final String categoryId;

  final String mode;
  @override
  State<DoctorListScreen> createState() => _FitnessShopScreenState();
}

class _FitnessShopScreenState extends State<DoctorListScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _scrollcontroller.addListener(_loadMore);
    getProductData(true);
  }

  var _scrollcontroller = ScrollController();
  TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;

  _filterList() {
    setState(() {
      _pageNo = 1;
      _isnotMoreData = false;
      _isFirstCall = true;
      _productData = [];
    });
    getProductData(true);
  }

  List<DoctorData>? _productData = [];

  int _pageNo = 1;
  int _pageCount = 10;

  bool _isLoadMoreRunning = false;
  bool _isFirstCall = true;

  bool _isError = false;
  String _errorMessage = "";
  bool _isnotMoreData = false;
  Future<void> getProductData(bool isInit) async {
    setState(() {
      if (_isFirstCall) {
        _isLoading = true;
      } else {
        _isLoadMoreRunning = true;
      }
    });
    try {
      Map<String, String> queryParameters = {
        "page": _pageNo.toString(),
        "count": _pageCount.toString(),
        "category_id": widget.categoryId.toString(),
        "search": _searchController.text.toString(),
        'mode_of_booking': widget.mode,
      };

      var response = await HttpService.httpPost("doctors", queryParameters,
          context: context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        DoctorListModel data = DoctorListModel.fromJson(body);

        if (data != null && data.status == "200") {
          if (data.data != null) {
            setState(() {
              _isError = false;
              _isFirstCall = false;
              if (data.data.isNotEmpty) {
                if (isInit) {
                  _productData = [];
                }
                data.data.forEach((element) {
                  _productData!.add(element);
                });
              } else {
                setState(() {
                  _isnotMoreData = true;
                });
              }
            });
          } else {
            setState(() {
              _isError = true;
              _errorMessage = GlobalVariableForShowMessage.internalservererror;
            });
          }
        } else {
          setState(() {
            _isError = true;
            _errorMessage = GlobalVariableForShowMessage.internalservererror;
          });
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        setState(() {
          _isError = true;
          _errorMessage = GlobalVariableForShowMessage.internalservererror;
        });
      }
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          _isError = true;
          _errorMessage = GlobalVariableForShowMessage.socketExceptionMessage;
        });
      } else if (e is TimeoutException) {
        setState(() {
          _isError = true;
          _errorMessage = GlobalVariableForShowMessage.timeoutExceptionMessage;
        });
      } else {
        setState(() {
          _isError = true;
          _errorMessage = e.toString();
        });
      }
    } finally {
      setState(() {
        _isLoading = false;

        _isLoadMoreRunning = false;
      });
    }
  }

  void _loadMore() async {
    if (!_isnotMoreData) {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        if (_isLoading == false &&
            _isLoadMoreRunning == false &&
            _scrollcontroller.position.extentAfter < 300) {
          setState(() {
            _isLoadMoreRunning = true;
          });
          _pageNo += 1;
          await getProductData(false);
          setState(() {
            _isLoadMoreRunning = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var data = Provider.of<LocationProwiderService>(context);
    data.addListener(() {
      if (data.currentLocationCity != "") {
        if (data.ischangeLocation == true) {
          if (mounted) {
            setState(() {
              _isnotMoreData = false;
              _pageNo = 1;
              _isFirstCall = true;
              _productData = [];
            });
            getProductData(true);
          }
        }
      }
    });
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBarWithLocationWidget(
                isBackShow: true,
                onbackPress: () {
                  Navigator.pop(context);
                },
              )),
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                    TextFiledWidget(
                      onChange: (value) {
                        _filterList();
                      },
                      backColor: ThemeClass.whiteDarkshadow,
                      hinttext: "Search",
                      controllers: _searchController,
                      radius: 10,
                      oniconTap: () {
                        _filterList();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      icon: "assets/images/search_icon.png",
                    ),
                    _isLoading
                        ? Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(50.0),
                                child: CircularProgressIndicator(
                                  color: ThemeClass.blueColor,
                                ),
                              ),
                            ),
                          )
                        : _buildView(width),

                    if (_isLoadMoreRunning == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 50),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: CircularProgressIndicator(
                              color: ThemeClass.blueColor,
                            ),
                          ),
                        ),
                      ),

                    // When nothing else to load
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildView(width) {
    return _isError
        ? Expanded(child: Center(child: Text(_errorMessage)))
        : _productData!.isEmpty
            ? Expanded(
                child: Center(
                  child: Lottie.asset('assets/animation/empty_animation.json',
                      repeat: true, height: 200, reverse: true, animate: true),
                ),
              )
            : Expanded(
                child: LiveList.options(
                    controller: _scrollcontroller,
                    physics: BouncingScrollPhysics(),
                    options: AnimationService.animationOption,
                    itemBuilder: (BuildContext context, int index,
                        Animation<double> animation) {
                      return FadeTransition(
                        opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: _buildCard(_productData, index),
                        ),
                      );
                    },
                    scrollDirection: Axis.vertical,
                    itemCount: _productData!.length
                    // _productData!.length,
                    ),
              );
  }

  Column _buildCard(List<DoctorData>? productData, int index) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () {
            pushNewScreen(
              context,
              screen: AboutDoctorScreen(
                id: productData![index].id,
                mode: widget.mode,
              ),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 5,
              ),
              CircleAvatar(
                backgroundImage:
                    NetworkImage(productData![index].image.toString()),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productData[index].title,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      productData[index].qualification,
                      style: TextStyle(
                          color: ThemeClass.blueColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: RatingBar.builder(
                  ignoreGestures: true,
                  initialRating: double.parse(productData[index].rating),
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  unratedColor: ThemeClass.greyLightColor,
                  itemPadding: EdgeInsets.only(right: 1.0),
                  itemSize: 15,
                  itemBuilder: (context, count) => Icon(
                    Icons.star_rate_rounded,
                    color: ThemeClass.blueColor,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Divider(
          height: 1,
          thickness: 1,
          color: ThemeClass.greyLightColor1,
        ),
      )
    ]);
  }
}
