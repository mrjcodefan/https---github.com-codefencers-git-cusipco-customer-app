import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/cart/cart_screen.dart';
import 'package:heal_u/screens/main_screen/home/store/seller_list_tile_widget.dart';
import 'package:heal_u/screens/main_screen/home/store/store_product_details_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_location.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/slider_for_product_details_widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class StoreProductDetailsScreen extends StatefulWidget {
  StoreProductDetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<StoreProductDetailsScreen> createState() =>
      _StoreProductDetailsScreenState();
}

class _StoreProductDetailsScreenState extends State<StoreProductDetailsScreen> {
  String checkedID = "";

  String _price = "";

  String _salesPrice = "";
  String _variation = "";
  bool _isLoading = false;
  bool _isLoadingProduct = false;
  Future<StoreProductDetailsData?>? _futureCAll;
  @override
  void initState() {
    super.initState();

    _futureCAll = getStoreProductDetails();
  }

  Future<StoreProductDetailsData?> getStoreProductDetails() async {
    if (mounted) {
      setState(() {
        _isLoadingProduct = true;
      });
    }
    try {
      var response = await HttpService.httpGet("product/${widget.id}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          StoreProductDetailsModel places =
              StoreProductDetailsModel.fromJson(body);

          if (places.data!.id != null && places.data!.id != "") {
            return places.data;
          } else {
            throw GlobalVariableForShowMessage.internalservererror + "";
          }
        } else {
          throw body['message'].toString();
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        print("product details issue--------------------------");
        print("----------> ${response.body}");
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
    return null;
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
              _futureCAll = getStoreProductDetails();
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
                  })),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: FutureBuilder(
                future: _futureCAll,
                builder: (context,
                    AsyncSnapshot<StoreProductDetailsData?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return _buildview(width, snapshot.data);
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
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
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

  Container _buildDataNotFound1(
    String text,
  ) {
    return Container(
        height: 700,
        color: Colors.transparent,
        child: Center(child: Text("$text")));
  }

  Stack _buildview(width, StoreProductDetailsData? productData) {
    if (checkedID == "") {
      _price = productData!.price.toString();
      _variation = productData.variation.toString();
      _salesPrice = productData.salePrice.toString();
    }
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productData!.image!.isNotEmpty
                    ? SliderProductDetailsWidget(
                        image: productData.image!.isNotEmpty
                            ? productData.image!.toList()
                            : [],
                      )
                    : SizedBox(),
                SizedBox(
                  height: productData.image!.isNotEmpty ? 50 : 0,
                ),
                Text(
                  productData.title.toString(),
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  _variation,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      color: ThemeClass.greyColor,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _salesPrice == "" ? "₹${_price}" : "₹${_salesPrice}",
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 22,
                          color: ThemeClass.blueColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          _salesPrice != "" ? "₹${_price}" : "",
                          style: TextStyle(
                              // overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                              color: ThemeClass.greyColor,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Sold by : ${productData.soldBy}",
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                      color: ThemeClass.blackColor,
                      fontWeight: FontWeight.w400),
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
                productData.variations!.length > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose Pack Size",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                                color: ThemeClass.blackColor,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${productData.variations!.length} Option",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12,
                                color: ThemeClass.greyColor,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 3,
                            childAspectRatio: 3 / 1.1,
                            children: productData.variations!
                                .map((e) => _buildTrainerBox(e))
                                .toList(),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            thickness: 1,
                            color: ThemeClass.greyLightColor1,
                          ),
                        ],
                      )
                    : SizedBox(),
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
                Html(
                  data: productData.description.toString(),
                  style: {
                    "*": Style(
                        margin: EdgeInsets.only(left: 0),
                        fontSize: FontSize.small,
                        color: ThemeClass.greyColor,
                        fontWeight: FontWeight.w400),
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Other Seller on HealU",
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      color: ThemeClass.blackColor,
                      fontWeight: FontWeight.w500),
                ),
                Divider(
                  thickness: 1,
                  color: ThemeClass.greyLightColor1,
                ),
                SizedBox(
                  height: 15,
                ),
                ...productData.sellers!.reversed
                    .map(
                      (e) => ProductSellerListTile(seller: e),
                    )
                    .toList(),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
        _buildBottomButton(productData.countInCart.toString()),
      ],
    );
  }

  InkWell _buildTrainerBox(Variation data) {
    if (checkedID == "") {
      checkedID = data.id.toString();
    }

    return InkWell(
      onTap: () {
        setState(() {
          checkedID = data.id.toString();

          _price = data.price.toString();
          _variation = data.title.toString();
          _salesPrice = data.salePrice.toString();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: checkedID == data.id.toString()
              ? ThemeClass.blueColor
              : ThemeClass.skyblueColor1,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data.title.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 10,
                  color: checkedID == data.id.toString()
                      ? ThemeClass.whiteColor
                      : ThemeClass.greyColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buildBottomButton(String cartData) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        child: ButtonWidget(
          title: cartData == "0" ? "Add to Cart" : "View Cart",
          isLoading: _isLoading,
          color: ThemeClass.blueColor,
          callBack: () {
            if (cartData == "0") {
              _addToCart(checkedID);
            } else {
              pushNewScreen(
                context,
                screen: CartScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            }
          },
        ),
      ),
    );
  }

  _addToCart(variationId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, String> queryParameters = {
        "product_id": widget.id.toString(),
        "clear_cart": "0",
        "quantity": "1",
        "variation_id": variationId
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
          _futureCAll = getStoreProductDetails();
          showToast(res['message']);

          pushNewScreen(
            context,
            screen: CartScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
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
