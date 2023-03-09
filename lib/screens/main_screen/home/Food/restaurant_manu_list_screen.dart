import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/home/Food/model/resturent_details_model.dart';
import 'package:heal_u/screens/main_screen/home/Food/product_list_widget.dart';
import 'package:heal_u/screens/main_screen/my_account/my_subscription/my_subscription_sevice.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/bottom_sheets/bottom_sheet_select_diet_plan.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ResturantManuListScreen extends StatefulWidget {
  ResturantManuListScreen({
    Key? key,
    required this.resturentId,
    required this.resturentName,
  }) : super(key: key);
  final String resturentId;

  final String resturentName;

  @override
  State<ResturantManuListScreen> createState() =>
      _ResturantManuListScreenState();
}

class _ResturantManuListScreenState extends State<ResturantManuListScreen>
    with TickerProviderStateMixin {
  CarouselController buttonCarouselController = CarouselController();

  List<ResturentCategory>? _categories = [];

  String? id = "";
  String? image = "";
  String? title = "";
  String? location = "";
  String? rating = "";

  bool inActive = false;
  late TabController _tabBarController;
  @override
  void initState() {
    super.initState();
    getResturentDetails();
  }

  bool isfirstInitialize = false;

  initaLizeTabControoler(int length) {
    if (!isfirstInitialize) {
      _tabBarController = TabController(length: length, vsync: this);
      _tabBarController.addListener(() {
        setState(() {
          selectedIndex = _tabBarController.index;
        });

        setState(() {
          isfirstInitialize = true;
        });
      });
    }
  }

  int selectedIndex = 0;
  bool isOpenResturent = true;

  bool _isMainLoadin = false;
  bool isFetching = false;
  bool isloading = false;
  String isSubscribed = "0";
  bool _isError = false;
  String _errorMSG = "";
  Future<void> getResturentDetails() async {
    setState(() {
      _isMainLoadin = true;
    });
    try {
      var response =
          await HttpService.httpGet("restaurant/${widget.resturentId}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        ResturentDetailModel data = ResturentDetailModel.fromJson(body);
        if (data != null && data.status == "200") {
          initaLizeTabControoler(data.data!.categories!.length);
          setState(() {
            _isError = false;
          });
          setState(() {
            _categories = data.data!.categories!;
            id = data.data!.id;
            image = data.data!.image;
            title = data.data!.title;
            location = data.data!.location;
            rating = data.data!.rating;

            isOpenResturent = data.data!.status.toString() != "Close Now";
            isSubscribed = data.data!.isSubscribed.toString();
          });
          // return data.data;
        } else {
          setState(() {
            _isError = true;
          });
          showToast("internal server error");
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        setState(() {
          _isError = true;
        });
        showToast("internal server error");
      }
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          _isError = true;
        });
        showToast("Socket exception");
      } else if (e is TimeoutException) {
        setState(() {
          _isError = true;
        });
        showToast("Time out exception");
      } else {
        setState(() {
          _isError = true;
        });
        showToast(e.toString());
      }
    } finally {
      setState(() {
        _isMainLoadin = false;
      });
    }
  }

  Future<void> getOnlyProductUpdatedData() async {
    if (!isFetching) {
      if (mounted) {
        setState(() {
          isFetching = true;
        });
        try {
          var response =
              await HttpService.httpGet("restaurant/${widget.resturentId}");

          if (response.statusCode == 200 || response.statusCode == 201) {
            final body = json.decode(response.body);
            ResturentDetailModel data = ResturentDetailModel.fromJson(body);
            if (data != null && data.status == "200") {
              setState(() {
                _categories = data.data!.categories;
              });
            }
          } else if (response.statusCode == 401) {
            showToast(GlobalVariableForShowMessage.unauthorizedUser);
            await UserPrefService().removeUserData();
            NavigationService().navigatWhenUnautorized();
          }
        } catch (e) {
          debugPrint(e.toString());
        } finally {
          setState(() {
            isFetching = false;
          });
        }
      }
    }
  }

  CardProviderService? cartListner;
  bool _isLoadingProduct = false;

  @override
  void dispose() {
    super.dispose();
    if (cartListner != null) {
      cartListner!.removeListener(() {
        print("listner removeed ===========");
        cartListner = null;
      });
      cartListner!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cartListner == null) {
      var cartListner = Provider.of<CardProviderService>(context);

      cartListner.addListener(() {
        if (isFetching == false) {
          if (cartListner.isLoadStoreProductDetails == true) {
            if (mounted) {
              getOnlyProductUpdatedData();
            }
          }
        }
      });
    }

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
                title: widget.resturentName,
                isShowCart: true,
              )),
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: _isMainLoadin
                  ? Center(
                      child: CircularProgressIndicator(
                          color: ThemeClass.blueColor),
                    )
                  : _isError
                      ? Center(
                          child: Text("Something went wrong!"),
                        )
                      : _buildVIew(height, width)),
        ),
      ),
    );
  }

  DefaultTabController _buildVIew(
    double height,
    double width,
  ) {
    return DefaultTabController(
      length: _categories!.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderImage(height, width),
          SizedBox(
            height: 10,
          ),
          _buildTapBar(),
          isFetching
              ? Expanded(
                  child: Center(
                    child: Lottie.asset(
                        'assets/animation/add_to_cart_animation.json',
                        repeat: true,
                        height: 150,
                        reverse: true,
                        animate: true),
                  ),
                )
              : isloading
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                            color: ThemeClass.blueColor),
                      ),
                    )
                  : _categories!.isNotEmpty
                      ? Expanded(
                          child: TabBarView(
                            controller: _tabBarController,
                            children: [
                              ..._categories!
                                  .map(
                                    (item) => ProductListWidget(
                                      isOpen: isOpenResturent,
                                      item: item,
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: Lottie.asset(
                                'assets/animation/empty_animation.json',
                                repeat: true,
                                height: 200,
                                reverse: true,
                                animate: true),
                          ),
                        ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Padding _buildManuName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        // horizontalManu[selectedIndex],
        _categories!.isNotEmpty
            ? _categories![selectedIndex].title.toString()
            : "",
        style:
            TextStyle(color: ThemeClass.blueColor, fontWeight: FontWeight.w500),
      ),
    );
  }

  _showLoadingTimer(value) async {
    setState(() {
      isloading = true;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        selectedIndex = value;
        isloading = false;
      });
    });
  }

  Column _buildTapBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TabBar(
            controller: _tabBarController,
            onTap: (value) {
              _showLoadingTimer(value);
            },
            isScrollable: true,
            indicatorColor: ThemeClass.blueColor,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: ThemeClass.blueColor),
                insets: EdgeInsets.symmetric(horizontal: 10.0)),
            tabs: [
              ..._categories!
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        item.title.toString(),
                        style: TextStyle(color: ThemeClass.greyColor),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
        _buildManuName(),
      ],
    );
  }

  Container _buildHeaderImage(
    double height,
    double width,
  ) {
    return Container(
      child: Stack(
        children: [
          isOpenResturent
              ? Container(
                  height: 150,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  height: 150,
                  width: width,
                  foregroundDecoration: BoxDecoration(
                      color: Colors.white,
                      backgroundBlendMode: BlendMode.saturation),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          Container(
            color: ThemeClass.blackColor.withOpacity(0.43),
            height: 150,
            width: width,
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: ThemeClass.whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          location.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ThemeClass.whiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: ThemeClass.whiteColor,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: ThemeClass.blueColor,
                                size: 15,
                              ),
                              Text(
                                rating.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: ThemeClass.blueColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: !isOpenResturent ? 20 : 0,
                      ),
                      InkWell(
                        onTap: () {
                          // _showSelectMemberBottomSheet();
                          if (isSubscribed == "0") {
                            _showSubscribeDialog(context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: isSubscribed == "0"
                                  ? ThemeClass.blueColor
                                  : ThemeClass.blueColor.withOpacity(0.5)),
                          child: Text(
                            isSubscribed == "0" ? "Subscribe" : "Subscribed",
                            style: TextStyle(
                              color: ThemeClass.whiteColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      !isOpenResturent
                          ? Lottie.asset(
                              'assets/animation/shop_close_animation.json',
                              repeat: true,
                              height: 70,
                              reverse: true,
                              animate: true)
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _setIsSubscribe() {
    setState(() {
      isSubscribed = "1";
    });
  }

  _showSubscribeDialog(BuildContext context1) async {
    EasyLoading.show();
    await Provider.of<MySubscriptionService>(context, listen: false)
        .getMySubscription();
    EasyLoading.dismiss();
    var res = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) {
          return BottomSheetSelectDietPlan(
            callback: _setIsSubscribe,
            prevContext: context1,
            restID: widget.resturentId,
          );
        });

    if (res == true) {
      setState(() {
        isSubscribed = "1";
      });
    }
  }
}
