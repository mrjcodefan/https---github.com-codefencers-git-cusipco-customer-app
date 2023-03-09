import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/cart/cart_model.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/home/Food/model/resturent_details_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ProductItemResturentWidget extends StatefulWidget {
  ProductItemResturentWidget(
      {Key? key,
      required this.isShowCart,
      required this.callback,
      required this.isOpen,
      required this.data})
      : super(key: key);
  final bool isShowCart;
  final Function callback;
  final ResturentItem data;
  final bool isOpen;
  @override
  State<ProductItemResturentWidget> createState() =>
      _ProductItemResturentWidgetState();
}

class _ProductItemResturentWidgetState
    extends State<ProductItemResturentWidget> {
  int _total = 0;
  bool isShowCart = false;

  @override
  void initState() {
    super.initState();
    isShowCart = widget.isShowCart;
    _total = int.parse(widget.data.quantityInCart.toString());
  }

  _addOrRemoveCartItem(bool isAdding, int qu) async {
    try {
      EasyLoading.show();

      CartItem cartData = CartItem(productId: widget.data.id);
      var pro = Provider.of<CardProviderService>(context, listen: false);
      if (qu == 0) {
        var res = await pro.removeItem(cartData, context, false);

        if (res != null) {
          setState(() {
            isShowCart = false;
          });
          showToast(res.toString());
        }
      } else {
        var res =
            await pro.addRemoveCartItem(isAdding, cartData, qu, context, false);

        if (res != null) {
          setState(() {
            isShowCart = true;
            _total = qu;
          });
          showToast(res.toString());
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return _buildRestaurentListTile(width);
  }

  Padding _buildRestaurentListTile(double width) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: InkWell(
        onTap: () {
          // pushNewScreen(
          //   context,
          //   screen: ProductDetailsScreen(),
          //   withNavBar: false,
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
        },
        child: Column(
          children: [
            Row(
              children: [
                !widget.isOpen
                    ? Container(
                        width: width * 0.2,
                        height: width * 0.2,
                        foregroundDecoration: BoxDecoration(
                            color: Colors.white,
                            backgroundBlendMode: BlendMode.saturation),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            image: NetworkImage(widget.data.image.toString()),
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
                            image: NetworkImage(widget.data.image.toString()),
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
                        widget.data.title.toString(),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.data.description.toString(),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: ThemeClass.greyColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "₹${widget.data.price.toString()}",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: ThemeClass.blueColor,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                !widget.isOpen
                    ? SizedBox()
                    : isShowCart
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  _addOrRemoveCartItem(false, _total - 1);
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: ThemeClass.blueColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    size: 15,
                                    color: ThemeClass.whiteColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  _total.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ThemeClass.blueColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _addOrRemoveCartItem(true, _total + 1);

                                  // setState(() {
                                  //   _total = _total + 1;
                                  // });
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: ThemeClass.blueColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 15,
                                    color: ThemeClass.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: () {
                              // widget.callback();
                              _addToCart(widget.data.id);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: ThemeClass.blueColor,
                              ),
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: ThemeClass.whiteColor,
                                  fontSize: 8,
                                ),
                              ),
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

  _addToCart(productId) async {
    EasyLoading.show();
    try {
      Map<String, String> queryParameters = {
        "product_id": productId.toString(),
        "clear_cart": "0",
        "quantity": "1",
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

          showToast(res['message']);
          setState(() {
            _total = _total + 1;
            isShowCart = true;
          });
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
      EasyLoading.dismiss();
    }
  }
}
