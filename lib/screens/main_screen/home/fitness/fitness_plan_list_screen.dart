import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/product_model.dart';
import 'package:heal_u/screens/main_screen/home/fitness/membership_details_screen.dart';

import 'package:heal_u/service/animation_service.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/prowider/location_prowider_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_location.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class FitnesPlanListScreen extends StatefulWidget {
  FitnesPlanListScreen({Key? key, required this.fitnessId}) : super(key: key);
  final String fitnessId;
  @override
  State<FitnesPlanListScreen> createState() => _FitnesPlanListScreenState();
}

class _FitnesPlanListScreenState extends State<FitnesPlanListScreen>
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

  List<ProductData>? _productData = [];

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
        "fitness_id": widget.fitnessId.toString(),
        "search": _searchController.text.toString(),
      };

      var response = await HttpService.httpPost(
          "fitness_plan_list", queryParameters,
          context: context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        ProductModel data = ProductModel.fromJson(body);

        if (data != null && data.status == "200") {
          if (data.data != null) {
            setState(() {
              _isError = false;
              _isFirstCall = false;
              if (data.data!.isNotEmpty) {
                if (isInit) {
                  _productData = [];
                }
                data.data!.forEach((element) {
                  _productData!.add(element);
                });
              } else {
                _isnotMoreData = true;
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
                              child: CircularProgressIndicator(
                                  color: ThemeClass.blueColor),
                            ),
                          )
                        : _buildView(width),
                    // when the _loadMore function is running
                    if (_isLoadMoreRunning == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 50),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: ThemeClass.blueColor),
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
                          child: _buildRestaurentListTile(
                            width,
                            index,
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.vertical,
                    itemCount: _productData!.length
                    // _productData!.length,
                    ),
              );
  }

  Padding _buildRestaurentListTile(double width, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, top: index == 0 ? 15 : 0),
      child: InkWell(
        onTap: () {
          pushNewScreen(
            context,
            screen: MemberShipDetailsScreen(
              productId: _productData![index].id.toString(),
            ),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: width * 0.2,
                  height: width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      image:
                          NetworkImage(_productData![index].image.toString()),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _productData![index].title.toString(),
                        // "asd",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        _productData![index].subTitle.toString(),
                        // "asd",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: ThemeClass.greyColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "₹${_productData![index].price.toString()}",
                        // "asd",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: ThemeClass.blueColor,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.star,
                        color: ThemeClass.blueColor,
                      ),
                      Text(
                        "${_productData![index].rating}",
                        // "asd",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: ThemeClass.blueColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: ThemeClass.greyLightColor1,
            )
          ],
        ),
      ),
    );
  }
}
