import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/Global/web_view_screen.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/checkout/checkout_model.dart';
import 'package:heal_u/screens/main_screen/checkout/checkout_prowider_service.dart';
import 'package:heal_u/pages/add_address_screen.dart';
import 'package:heal_u/screens/main_screen/coupon/coupon_list_model.dart';
import 'package:heal_u/screens/main_screen/coupon/coupon_service.dart';
import 'package:heal_u/screens/main_screen/coupon/select_coupon_list_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/my_order_screen.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_button.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  CheckOutScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  void initState() {
    super.initState();
  }

  _refreshData() async {
    var pro = Provider.of<CheckOutProwider>(context, listen: false);
    EasyLoading.show();
    if (coupon != null) {
      await pro.getCheckData(
          coupon: coupon!.code.toString(),
          context: context,
          addressId: radioAddressGroupValue == "addressRadioGP"
              ? ""
              : radioAddressGroupValue,
          ownerId: ownerIdToSend);
    } else {
      await pro.getCheckData(
          coupon: "",
          context: context,
          addressId: radioAddressGroupValue == "addressRadioGP"
              ? ""
              : radioAddressGroupValue,
          ownerId: ownerIdToSend);
    }
    EasyLoading.dismiss();
  }

  CouponData? coupon;
  String ownerIdToSend = "";

  String radioAddressGroupValue = "addressRadioGP";
  String radioPaymentGroupValue = "paymentRadioGP";

  _checkout(CheckOutData? checkOutData) async {
    if (radioAddressGroupValue == "addressRadioGP" &&
        checkOutData!.isShowDeliveryAddress == "1") {
      showToast("Please select address");
    } else if (radioPaymentGroupValue == "paymentRadioGP") {
      showToast("Please select payment method");
    } else {
      EasyLoading.show();
      var pro = Provider.of<CheckOutProwider>(context, listen: false);
      try {
        var code = "";
        if (coupon != null) {
          code = coupon!.code.toString();
        }
        var res = await pro.createOrder(
            radioAddressGroupValue == "addressRadioGP"
                ? ""
                : radioAddressGroupValue,
            radioPaymentGroupValue,
            code,
            context);

        if (res != null) {
          if (radioPaymentGroupValue == "2") {
            EasyLoading.dismiss();
            var res2 = await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute<bool>(
                builder: (BuildContext context) =>
                    WebViewScreen(url: res.toString()),
              ),
            );

            if (res2 == true) {
              showToast("Payment Successfully Done.");
              var provider1 =
                  Provider.of<CardProviderService>(context, listen: false);
              EasyLoading.show();
              await provider1.getCart();
              EasyLoading.dismiss();
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => MyOrderScreen(),
                ),
              );
            } else {
              showToast("Payment Not Done.");
            }
          } else if (radioPaymentGroupValue == "3") {
            // if wallet balance is not compaired to Amount
            if (res['data']['payment_url'] != null) {
              EasyLoading.dismiss();
              var res2 = await Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute<bool>(
                  builder: (BuildContext context) =>
                      WebViewScreen(url: res['data']['payment_url']),
                ),
              );

              if (res2 == true) {
                showToast("Payment Successfully Done.");
                var provider1 =
                    Provider.of<CardProviderService>(context, listen: false);
                EasyLoading.show();
                await provider1.getCart();
                EasyLoading.dismiss();
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => MyOrderScreen(),
                  ),
                );
              } else {
                showToast("Payment Not Done.");
              }
            } else {
              showToast(res['message'].toString());
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => MyOrderScreen(),
                ),
              );
            }
          } else {
            showToast(res.toString());
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => MyOrderScreen(),
              ),
            );
          }
        }
      } catch (e) {
        showToast(e.toString());
      }

      EasyLoading.dismiss();
    }
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
                title: "Checkout",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child:
                Consumer<CheckOutProwider>(builder: (context, prowider, child) {
              if (prowider.checkOutData != null) {
                return _buildView(prowider.checkOutData);
              } else {
                return Center(
                  child: Text("Data not found"),
                );
              }
            }),
          ),
        ),
      ),
    );
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
          _refreshData();
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
                            Consumer<CouponService>(
                                builder: (context, coupoonService, child) {
                              return coupoonService.mainCouponList.isNotEmpty
                                  ? Text(
                                      "${coupoonService.mainCouponList.length} offers are available",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: ThemeClass.blueColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      "0 offers are available",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: ThemeClass.blueColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    );
                            }),
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

                          _refreshData();
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

  Stack _buildView(CheckOutData? checkOutData) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle("Your Items"),
              checkOutData!.items != null
                  ? _buildYourItemValue(checkOutData.items)
                  : SizedBox(),
              _buildCouponCode(),
              _buildDivider(),
              checkOutData.isShowDeliveryAddress == "1"
                  ? _buildAddressTitle()
                  : SizedBox(),
              checkOutData.isShowDeliveryAddress == "1"
                  ? checkOutData.address != null
                      ? _buildAddressCart(checkOutData.address)
                      : SizedBox()
                  : SizedBox(),
              _buildTitle("Way to Payment"),
              checkOutData.paymentMethods != null
                  ? _buildPaymentCart(checkOutData.paymentMethods)
                  : SizedBox(),
              _buildbottomAmount(checkOutData),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
        _buildBottomButton(checkOutData)
      ],
    );
  }

  Align _buildBottomButton(CheckOutData? checkOutData) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        child: ButtonWidget(
          title: "Confirm & Pay",
          color: ThemeClass.blueColor,
          callBack: () {
            _checkout(checkOutData);
          },
        ),
      ),
    );
  }

  Container _buildPaymentCart(List<PaymentMethod>? paymentMethods) {
    return Container(
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: paymentMethods!.isEmpty
              ? [
                  Center(
                    child:
                        Text(GlobalVariableForShowMessage.addressNotFoundMsg),
                  )
                ]
              : paymentMethods.map((e) => _buildPaymentListTile(e)).toList(),
        ),
      ),
    );
  }

  Column _buildPaymentListTile(PaymentMethod data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                child: Radio(
                  value: data.id.toString(),
                  activeColor: ThemeClass.blueColor,
                  fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                  groupValue: radioPaymentGroupValue,
                  onChanged: (value) {
                    setState(() {
                      radioPaymentGroupValue = value.toString();
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                data.title.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeClass.blackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        _buildDivider()
      ],
    );
  }

  Container _buildAddressCart(List<CheckOutAddress>? address) {
    return Container(
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: address!.isEmpty
              ? [
                  Center(
                    child: Text("Address not found"),
                  )
                ]
              : address.map((e) => _buildAddressListTile1(e)).toList(),
        ),
      ),
    );
  }

  Column _buildAddressListTile1(CheckOutAddress data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(data.addressType == "Home"
                          ? 'assets/images/home_icon.png'
                          : 'assets/images/office_icon.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeClass.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    data.address.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: ThemeClass.greyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                child: Radio(
                  value: data.id.toString(),
                  activeColor: ThemeClass.blueColor,
                  fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                  groupValue: radioAddressGroupValue,
                  onChanged: (value) {
                    setState(() {
                      radioAddressGroupValue = value.toString();
                    });
                    _refreshData();
                  },
                ),
              ),
            ),
          ],
        ),
        _buildDivider()
      ],
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Divider(
        thickness: 1,
        color: ThemeClass.greyLightColor1,
      ),
    );
  }

  Container _buildbottomAmount(CheckOutData? checkOutData) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildBottomAmountListTile(false, "Item Total (MRP)",
                "₹${checkOutData!.itemTotal.toString()}"),
            checkOutData.isItemDiscount == "1"
                ? _buildBottomAmountListTile(
                    false, "Item Discount", "- ₹${checkOutData.itemDiscount}")
                : SizedBox(),
            _buildBottomAmountListTile(
                false, "Coupon Discount", "- ₹${checkOutData.couponDiscount}"),
            checkOutData.isDeliveryCharge == "1"
                ? _buildBottomAmountListTile(
                    false, "Delivery Charge", "+ ₹${checkOutData.deliveryFee}")
                : SizedBox(),
            _buildBottomAmountListTile(false, checkOutData.textLabel.toString(),
                "+ ₹${checkOutData.tax}"),
            _buildDivider(),
            _buildBottomAmountListTile(true, "Payable Amount",
                "₹${checkOutData.grandTotal.toString()}"),
            _buildDivider(),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total Saving : ",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "₹${checkOutData.totalSavings}",
                    style: TextStyle(
                      fontSize: 10,
                      color: ThemeClass.greenColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildBottomAmountListTile(bool isDark, String title, String title2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? ThemeClass.blackColor : ThemeClass.greyColor,
              fontWeight: isDark ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
          Text(
            title2,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? ThemeClass.blackColor : ThemeClass.greyColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildYourItemValue(List<CheckOutItem>? items) {
    return Container(
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: items!.isEmpty
              ? [
                  Center(
                    child: Text("product not found"),
                  )
                ]
              : items.map((item) => _buildItemListTile(item, items)).toList(),
        ),
      ),
    );
  }

  Padding _buildItemListTile(CheckOutItem item, List<CheckOutItem>? items) {
    var index = items!.indexOf(item);
    index = index + 1;
    var title = index < 10
        ? "${item.quantity}   x   ${item.title}"
        : "${index}    ${item.title}";

    ownerIdToSend = item.ownerId.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: ThemeClass.greyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            item.salePrice.toString() == ""
                ? "${item.price}"
                : item.salePrice.toString(),
            style: TextStyle(
              fontSize: 12,
              color: ThemeClass.blueColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Padding _buildAddressTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Delivery Address",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButtonWidget(
            onPressed: () async {
              await pushNewScreen(context,
                  screen: AddAddressScreen(
                    isFromCheckout: true,
                  ));

              _refreshData();
            },
            child: Text(
              "+ Add New Address",
              style: TextStyle(
                fontSize: 14,
                color: ThemeClass.blueColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
