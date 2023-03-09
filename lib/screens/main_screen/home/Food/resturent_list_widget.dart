import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/home/Food/model/menu_items_model.dart';
import 'package:heal_u/screens/main_screen/home/Food/model/resturent_model.dart';
import 'package:heal_u/screens/main_screen/home/Food/restaurant_manu_list_screen.dart';
import 'package:heal_u/service/animation_service.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/prowider/location_prowider_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ResturentListItemWidget extends StatefulWidget {
  ResturentListItemWidget({Key? key}) : super(key: key);

  @override
  State<ResturentListItemWidget> createState() =>
      _ResturentListItemWidgetState();
}

class _ResturentListItemWidgetState extends State<ResturentListItemWidget> {
  var _scrollcontrollerResturnt = ScrollController();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getResturentList(true);
    _scrollcontrollerResturnt.addListener(_loadMoreResturent);
  }

  bool _isLoading = false;

  int _pageNo2 = 1;
  int _pageCount2 = 10;

  bool _isLoadMoreRunningr = false;
  bool _isFirstCallr = true;
  bool _isnotMoreDatar = false;
  bool _isError = false;
  String _errorMessage = "";

  List<ResturentData>? _resturentItems = [];

  _filterList() {
    if (mounted) {
      setState(() {
        _isnotMoreDatar = false;
        _pageNo2 = 1;
        _isFirstCallr = true;
        _resturentItems = [];
      });
    }
    getResturentList(true);
  }

  void _loadMoreResturent() async {
    if (!_isnotMoreDatar) {
      if (_scrollcontrollerResturnt.position.pixels ==
          _scrollcontrollerResturnt.position.maxScrollExtent) {
        if (_isLoading == false &&
            _isLoadMoreRunningr == false &&
            _scrollcontrollerResturnt.position.extentAfter < 300) {
          if (mounted) {
            setState(() {
              _isLoadMoreRunningr = true;
            });
          }
          _pageNo2 += 1;
          await getResturentList(false);
          if (mounted) {
            setState(() {
              _isLoadMoreRunningr = false;
            });
          }
        }
      }
    }
  }

  Future<void> getResturentList(bool isInit) async {
    print("get product called $_pageNo2");
    if (mounted) {
      setState(() {
        if (_isFirstCallr) {
          _isLoading = true;
        } else {
          _isLoadMoreRunningr = true;
        }
      });
    }
    try {
      Map<String, String> queryParameters = {
        "page": _pageNo2.toString(),
        "count": _pageCount2.toString(),
        "search": _searchController.text.toString(),
      };

      var response = await HttpService.httpPostWithoutToken(
          "restaurants", queryParameters,
          context: context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        ResturentModel data = ResturentModel.fromJson(body);

        if (data != null && data.status == "200") {
          if (data.data != null) {
            if (mounted) {
              setState(() {
                _isError = false;
                _isFirstCallr = false;
                if (data.data!.isNotEmpty) {
                  if (isInit) {
                    _resturentItems = [];
                  }
                  _resturentItems!.addAll(data.data!);
                } else {
                  _isnotMoreDatar = true;
                }
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _isError = true;
                _errorMessage =
                    GlobalVariableForShowMessage.internalservererror;
              });
            }
          }
        } else {
          if (mounted) {
            setState(() {
              _isError = true;
              _errorMessage = GlobalVariableForShowMessage.internalservererror;
            });
          }
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        if (mounted) {
          setState(() {
            _isError = true;
            _errorMessage = GlobalVariableForShowMessage.internalservererror;
          });
        }
      }
    } catch (e) {
      if (e is SocketException) {
        if (mounted) {
          setState(() {
            _isError = true;
            _errorMessage = GlobalVariableForShowMessage.socketExceptionMessage;
          });
        }
      } else if (e is TimeoutException) {
        if (mounted) {
          setState(() {
            _isError = true;
            _errorMessage =
                GlobalVariableForShowMessage.timeoutExceptionMessage;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isError = true;
            _errorMessage = e.toString();
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;

          _isLoadMoreRunningr = false;
        });
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
              _isnotMoreDatar = false;
              _pageNo2 = 1;
              _isFirstCallr = true;
              _resturentItems = [];
            });
            getResturentList(true);
          }
        }
      }
    });
    return Column(
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
                  child: CircularProgressIndicator(color: ThemeClass.blueColor),
                ),
              )
            : _buildFutureResturentList(width),
        if (_isLoadMoreRunningr == true)
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 50),
            child: Center(
              child: CircularProgressIndicator(color: ThemeClass.blueColor),
            ),
          ),
      ],
    );
  }

  Widget _buildFutureResturentList(double width) {
    return _isError
        ? Expanded(child: Center(child: Text(_errorMessage)))
        : _resturentItems!.isEmpty
            ? Expanded(
                child: Center(
                  child: Lottie.asset('assets/animation/empty_animation.json',
                      repeat: true, height: 200, reverse: true, animate: true),
                ),
              )
            : Expanded(
                child: LiveList.options(
                    controller: _scrollcontrollerResturnt,
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
                          child: _buildResturentListTile(
                              width, _resturentItems![index], index),
                        ),
                      );
                    },
                    scrollDirection: Axis.vertical,
                    itemCount: _resturentItems!.length
                    // _productData!.length,
                    ),
              );
  }

  Padding _buildResturentListTile(
      double width, ResturentData? itemData, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, top: index == 0 ? 15 : 0),
      child: InkWell(
        onTap: () {
          pushNewScreen(
            context,
            screen: ResturantManuListScreen(
                resturentName: itemData!.title.toString(),
                resturentId: itemData.id.toString()),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        child: Column(
          children: [
            Row(
              children: [
                itemData!.status.toString() != "Open Now"
                    ? Container(
                        width: width * 0.2,
                        height: width * 0.2,
                        foregroundDecoration: BoxDecoration(
                            color: Colors.white,
                            backgroundBlendMode: BlendMode.saturation),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            image: NetworkImage(itemData.image.toString()),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: width * 0.2,
                        height: width * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            image: NetworkImage(itemData.image.toString()),
                            fit: BoxFit.cover,
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
                        itemData.title.toString(),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        itemData.location.toString(),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: ThemeClass.greyColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        itemData.status.toString() != "Open Now"
                            ? "Closed"
                            : itemData.status.toString(),
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
                        itemData.rating.toString(),
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
