import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/cart/cart_screen.dart';
import 'package:heal_u/screens/main_screen/checkout/checkout_prowider_service.dart';
import 'package:heal_u/screens/main_screen/checkout/checkout_screen.dart';
import 'package:heal_u/screens/main_screen/coupon/coupon_service.dart';
import 'package:heal_u/screens/main_screen/home/fitness/fitness_detail_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_location.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class MemberShipDetailsScreen extends StatefulWidget {
  MemberShipDetailsScreen({Key? key, required this.productId})
      : super(key: key);

  final String productId;

  @override
  State<MemberShipDetailsScreen> createState() =>
      _MemberShipDetailsScreenState();
}

class _MemberShipDetailsScreenState extends State<MemberShipDetailsScreen> {
  bool _isLoading = false;
  List<Trainer>? temptrainer = [];
  bool _isLoadingProduct = false;
  var _futureCAll;
  @override
  void initState() {
    super.initState();

    _futureCAll = getPlanDetail();
  }

  Future<FitnessData?> getPlanDetail() async {
    try {
      if (mounted) {
        setState(() {
          _isLoadingProduct = true;
        });
      }
      var response =
          await HttpService.httpGet("fitness_plan/${widget.productId}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          FitnessDetailModel places = FitnessDetailModel.fromJson(body);

          return places.data;
        } else {
          throw body['message'].toString();
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
      } else {
        throw e.toString();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProduct = false;
        });
      }
    }
  }

  CardProviderService? cartListner;

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
        if (_isLoadingProduct == false) {
          if (cartListner.isLoadStoreProductDetails == true) {
            if (mounted) {
              _futureCAll = getPlanDetail();
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
            child: AppBarWithLocationWidget(
                isBackShow: true,
                onbackPress: () {
                  Navigator.pop(context);
                }),
          ),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: FutureBuilder(
                future: _futureCAll,
                builder: (context, AsyncSnapshot<FitnessData?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return _buildMainView(height, snapshot.data);
                      } else {
                        return _buildDataNotFound1("Data Not Found!");
                      }
                    } else if (snapshot.hasError) {
                      // return Center(child: Text(snapshot.error.toString()));
                      return _buildDataNotFound1(snapshot.error.toString());
                    } else {
                      return _buildDataNotFound1("Data Not Found!");
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                          color: ThemeClass.blueColor),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  Container _buildDataNotFound1(
    String text,
  ) {
    return Container(
        height: 700,
        color: Colors.transparent,
        child: Center(child: Text("$text")));
  }

  Stack _buildMainView(double height, FitnessData? dataREs) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          // ignore: prefer_const_literals_to_create_immutables
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                height: height * 0.3,
                imageUrl: dataREs!.image.toString(),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(
                    child:
                        CircularProgressIndicator(color: ThemeClass.blueColor)),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
              _buildview(dataREs),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
        _buildBottomButton(
            dataREs.id.toString(), dataREs.countInCart.toString())
      ],
    );
  }

  Padding _buildview(FitnessData? dataREs) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dataREs!.title.toString(),
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            dataREs.subTitle.toString(),
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                color: ThemeClass.greyColor,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "₹${dataREs.price.toString()}",
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 22,
                color: ThemeClass.blueColor,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            thickness: 1,
            color: ThemeClass.greyLightColor1,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Select Trainer",
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                color: ThemeClass.blackColor,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 15,
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...dataREs.trainer!.map((e) => _buildTrainerBox(e)).toList()

                // _buildTrainerBox(),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: ThemeClass.greyLightColor1,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Product Detail",
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                color: ThemeClass.blackColor,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${dataREs.description.toString()}",
            style: TextStyle(
                // overflow: TextOverflow.ellipsis,
                fontSize: 10,
                color: ThemeClass.greyColor,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Padding _buildTrainerBox(Trainer trainer) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (temptrainer!.contains(trainer)) {
              temptrainer = [];
            } else {
              temptrainer = [];
              temptrainer!.add(trainer);
            }
          });
        },
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              color: temptrainer!.contains(trainer)
                  ? Colors.black
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.2,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(trainer.image.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                trainer.name.toString(),
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12,
                    color: ThemeClass.greyColor,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }

  Align _buildBottomButton(String productId, String cartItem) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        child: ButtonWidget(
          isLoading: _isLoading,
          title: cartItem == "0" ? "Add to Cart" : "Checkout",
          color: ThemeClass.blueColor,
          callBack: () {
            if (cartItem == "0") {
              _addToCart(productId);
            } else {
              _checkOut();
            }
          },
        ),
      ),
    );
  }

  _checkOut() async {
    setState(() {
      _isLoading = true;
    });
    var pro = Provider.of<CheckOutProwider>(context, listen: false);

    try {
      await pro.getCheckData(
          coupon: "", context: context, addressId: "", ownerId: "");
      var pro1 = Provider.of<CouponService>(context, listen: false);
      pro1.getCoupons(context);
      pushNewScreen(
        context,
        screen: CheckOutScreen(),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } catch (e) {
      showToast(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _addToCart(productId) async {
    setState(() {
      _isLoading = true;
    });

    var trainerId = "";

    if (temptrainer!.isNotEmpty) {
      trainerId = temptrainer!.first.id.toString();
    }

    try {
      Map<String, String> queryParameters = {
        "product_id": productId.toString(),
        "clear_cart": "0",
        "quantity": "1",
        "trainer_id": trainerId
      };

      var response = await HttpService.httpPost("addToCart", queryParameters,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          var provider1 =
              Provider.of<CardProviderService>(context, listen: false);
          await provider1.getCart();
          _checkOut();
        } else {
          showToast(res['message']);
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
      setState(() {
        _isLoading = false;
      });
    }
  }
}
