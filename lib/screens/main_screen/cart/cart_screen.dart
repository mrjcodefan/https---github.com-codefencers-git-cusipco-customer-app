import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/globle_methd.dart';
import 'package:heal_u/screens/main_screen/cart/cart_model.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/checkout/checkout_prowider_service.dart';
import 'package:heal_u/screens/main_screen/checkout/checkout_screen.dart';
import 'package:heal_u/screens/main_screen/coupon/coupon_list_model.dart';
import 'package:heal_u/screens/main_screen/coupon/coupon_service.dart';
import 'package:heal_u/screens/main_screen/coupon/select_coupon_list_screen.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';

import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

bool isEmpty = true;

class _CartScreenState extends State<CartScreen> {
  CouponData? coupon;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false, // this is new

          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBarWithTextAndBackWidget(
                onbackPress: () {
                  Navigator.pop(context);
                },
                // isShowCart: true,
                isClickOnCart: false,
                onCartPress: () {},
                title: "Cart",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: _buildMainView(),
          ),
        ),
      ),
    );
  }

  Consumer<CardProviderService> _buildMainView() {
    return Consumer<CardProviderService>(
        builder: (context, cartService, child) {
      if (cartService.loading == true) {
        return Center(
          child: CircularProgressIndicator(
            color: ThemeClass.blueColor,
          ),
        );
      } else {
        if (cartService.isError == true) {
          if (cartService.errorMessage == "No result found") {
            return Center(
              child: Lottie.asset('assets/animation/empty_Cart_animation.json',
                  repeat: true, height: 100, reverse: true, animate: true),
            );
          } else {
            return Center(
              child: Text(cartService.errorMessage),
            );
          }
        } else {
          if (cartService.cartData != null &&
              cartService.cartData!.items!.isNotEmpty) {
            return _buildView(cartService.cartData!);
          } else {
            return Center(
              child: Lottie.asset('assets/animation/empty_Cart_animation.json',
                  repeat: true, height: 100, reverse: true, animate: true),
            );
          }
        }
      }
    });
  }

  Stack _buildView(CartData? cartData) {
    return Stack(
      fit: StackFit.loose,
      children: [
        SingleChildScrollView(
          reverse: true, // this is new
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 10,
                color: ThemeClass.greyLightColor1,
              ),
              _buildCartItemList(cartData!.items),
              // _buildCouponCode(),
              // _buildDivider(),
              _buildTotalAmount(cartData),
              cartData.isItemDiscount.toString() == "1"
                  ? _buildItemDiscound(cartData)
                  : SizedBox(),

              _buildDivider(),
              _buildPayableAmount(cartData),
              // _buildDivider(),
              // _buildTotalSaving(cartData),
              SizedBox(
                height: 140,
              )
            ],
          ),
        ),
        Consumer<CardProviderService>(builder: (context, cartService, child) {
          if (cartService.cartData != null &&
              cartService.cartData!.totalItem != null &&
              cartService.cartData!.items != null &&
              cartService.cartData!.items!.isNotEmpty) {
            return _buildBottomButton(
                true, cartService.cartData!.items!.first.ownerId.toString());
          } else {
            return _buildBottomButton(
                false, cartService.cartData!.items!.first.ownerId.toString());
          }
        }),
      ],
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: ThemeClass.greyLightColor1,
      ),
    );
  }

  Padding _buildTotalSaving(CartData cartData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Savings : ",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          cartData.totalAmount != null
              ? Text(
                  "₹${cartData.totalAmount.toString()}",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeClass.greenColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Text(
                  "₹0",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeClass.greenColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }

  Padding _buildPayableAmount(CartData cartData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Payable amount",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          cartData.payableAmount != null
              ? Text(
                  "₹${cartData.payableAmount.toString()}",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeClass.greyDarkColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Text(
                  "₹0",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeClass.greyDarkColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }

  Padding _buildTotalAmount(CartData cartData) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Item Total (MRP)",
            style: TextStyle(
              fontSize: 12,
              color: ThemeClass.greyDarkColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          cartData.totalAmount != null
              ? Text(
                  "₹${cartData.totalAmount.toString()}",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeClass.greyDarkColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Text(
                  "₹0",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeClass.greyDarkColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }

  Padding _buildItemDiscound(CartData cartData) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Item Discount",
            style: TextStyle(
              fontSize: 12,
              color: ThemeClass.greyDarkColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          cartData.discount != null
              ? Text(
                  "-₹${cartData.discount}",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeClass.greenColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Text(
                  "₹0",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeClass.greenColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }

  _buildCartItemList(List<CartItem>? items) {
    return Column(
        children: (items!.isNotEmpty)
            ? items.map((e) => _buildCartItem(e)).toList()
            : [SizedBox()]);
  }

  Widget _buildCouponCode() {
    return InkWell(
      onTap: () async {
        var data = await pushNewScreen(
          context,
          screen: SelectCouponListScreen(),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );

        if (data != null) {
          setState(() {
            coupon = data;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/percentage.png",
                  height: 60,
                ),
                coupon == null
                    ? Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Apply Coupon Code",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "7 offers are available",
                              style: TextStyle(
                                fontSize: 10,
                                color: ThemeClass.blueColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              coupon!.title.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "saved ₹${coupon!.discount}",
                              style: TextStyle(
                                fontSize: 10,
                                color: ThemeClass.greenColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                coupon == null
                    ? Image.asset(
                        "assets/images/right_icon2.png",
                        height: 25,
                      )
                    : GestureDetector(
                        onTap: () {
                          // _addAndRemoveItemFromCart(true, cartItem);
                          setState(() {
                            coupon = null;
                          });
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
                            Icons.close,
                            color: ThemeClass.whiteColor,
                            size: 20,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card _buildCartItem(CartItem cartItem) {
    return Card(
      child: Container(
        color: ThemeClass.blueDarkColor2.withOpacity(0.05),
        height: 150,
        child: Row(
          children: [
            _buildCartImage(cartItem),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    Text(
                      cartItem.title.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    cartItem.variation.toString() != ""
                        ? Text(
                            cartItem.variation.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: ThemeClass.greyDarkColor,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : SizedBox(),
                    Row(
                      children: [
                        Text(
                          cartItem.salePrice.toString() == ""
                              ? "₹${cartItem.price}"
                              : "₹${cartItem.salePrice}",
                          style: TextStyle(
                            fontSize: 16,
                            color: ThemeClass.blueColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          cartItem.salePrice.toString() != ""
                              ? "₹${cartItem.price}"
                              : "",
                          style: TextStyle(
                            fontSize: 13,
                            color: ThemeClass.greyColor,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildRemoveButton(cartItem),
                        Spacer(),
                        Spacer(),
                        _buildAddRemove(cartItem),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            // _buildAddRemove(cartItem),
          ],
        ),
      ),
    );
  }

  InkWell _buildRemoveButton(CartItem cartItem) {
    return InkWell(
      onTap: () {
        _removeItem(cartItem);
      },
      child: Text(
        "Remove",
        style: TextStyle(
          fontSize: 14,
          color: ThemeClass.redColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Expanded _buildAddRemove(CartItem cartItem) {
    return Expanded(
        flex: 4,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _addAndRemoveItemFromCart(false, cartItem);
                  },
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: ThemeClass.greyLightColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: ThemeClass.whiteColor,
                    ),
                  ),
                ),
                Container(
                  color: ThemeClass.blueDarkColor2.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      cartItem.quantity.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeClass.blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _addAndRemoveItemFromCart(true, cartItem);
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
                      color: ThemeClass.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Container _buildCartImage(CartItem cartItem) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          color: ThemeClass.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(cartItem.image.toString()),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Align _buildBottomButton(bool isactive, String ownerId) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        child: ButtonWidget(
          title: "Checkout",
          color: ThemeClass.blueColor,
          isdisable: !isactive,
          callBack: () async {
            if (isactive) {
              var pro = Provider.of<CheckOutProwider>(context, listen: false);
              EasyLoading.show();
              try {
                await pro.getCheckData(
                    coupon: "",
                    context: context,
                    addressId: "",
                    ownerId: ownerId);
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
                EasyLoading.dismiss();
              }
            }
          },
        ),
      ),
    );
  }

  _addAndRemoveItemFromCart(bool isAdding, CartItem cartItem) async {
    EasyLoading.show();
    int qu = 0;
    if (isAdding) {
      qu = int.parse(cartItem.quantity.toString()) + 1;
      getcallAddRemove(isAdding, cartItem, qu);
    } else {
      if (int.parse(cartItem.quantity.toString()) == 1) {
        // remove from cart delete
        _removeItem(cartItem);
      } else {
        qu = int.parse(cartItem.quantity.toString()) - 1;
        // remove from cart update

        getcallAddRemove(isAdding, cartItem, qu);
      }
    }
  }

  getcallAddRemove(bool isAdding, CartItem cartItem, qu) async {
    var pro = Provider.of<CardProviderService>(context, listen: false);
    var res =
        await pro.addRemoveCartItem(isAdding, cartItem, qu, context, true);

    if (res != null) {
      showToast(res.toString());
    }

    EasyLoading.dismiss();
  }

  _removeItem(CartItem cartItem) async {
    EasyLoading.show();

    var pro = Provider.of<CardProviderService>(context, listen: false);
    var res = await pro.removeItem(cartItem, context, true);

    if (res != null) {
      showToast(res.toString());
    }
    EasyLoading.dismiss();
  }
}
