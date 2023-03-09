import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/Global/globle_methd.dart';
import 'package:heal_u/Global/web_view_screen.dart';
import 'package:heal_u/model/book_appo_model.dart';
import 'package:heal_u/model/payment_method_model.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/home/Diet/model/diet_plan_model.dart';
import 'package:heal_u/screens/main_screen/home/Food/active_plans_and_subscription_screen.dart';
import 'package:heal_u/screens/main_screen/home/Food/model/my_subscription_model.dart';
import 'package:heal_u/screens/main_screen/my_account/booking_result_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';
import 'package:heal_u/service/book_appo_services.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';

import 'package:heal_u/service/prowider/payment_method_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/alert_dialog_subscription_under_review_widget.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';

import 'package:heal_u/widgets/general_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:provider/provider.dart';

class CheckoutForOtherScreen extends StatefulWidget {
  CheckoutForOtherScreen({
    Key? key,
    this.id,
    this.date,
    this.mode,
    this.module,
    this.time,
    this.chanrges,
    required this.tax,
    this.name,
    this.resturentData,
    this.dietPlan,
    this.queryParameters,
    required this.moduleView, // 1="Apponintment" , 2="subscription" , 3 = "DietPlan"
    this.payableAmount,
  }) : super(key: key);
  String? id;
  String? date;
  String tax;
  String? time;
  String? module;

  String? mode;
  String? chanrges;
  String? name;
  int moduleView;
  String? payableAmount;
  DietPlan? dietPlan;
  Map<String, String>? queryParameters;
  MySubscriptionDataRestaurant? resturentData;

  @override
  State<CheckoutForOtherScreen> createState() => _CheckoutForOtherScreenState();
}

class _CheckoutForOtherScreenState extends State<CheckoutForOtherScreen> {
  @override
  void initState() {
    super.initState();
  }

  String radioPaymentGroupValue = "paymentRadioGP";
  bool isLoading = false;
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
                title: "Details",
              )),
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: _buildView()),
        ),
      ),
    );
  }

  Stack _buildView() {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          // ignore: prefer_const_literals_to_create_immutables
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),

              widget.moduleView == 1
                  ? Column(
                      children: [
                        _buildYourItemValue(),
                        _buildTitle("Way to Payment"),
                        _buildPaymentView(),
                        _buildbottomAmount()
                      ],
                    )
                  : SizedBox(),
              widget.moduleView == 2
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildYourItemValueSubcription(),
                        _buildTitle("Way to Payment"),
                        _buildPaymentView(),
                        _buildbottomAmountSubcription()
                      ],
                    )
                  : SizedBox(),

              widget.moduleView == 3
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildYourItemValueDiet(),
                        _buildTitle("Way to Payment"),
                        _buildPaymentView(),
                        _buildbottomAmount()
                      ],
                    )
                  : SizedBox(),

              // _buildbottomAmount(),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
        _buildBottomButton()
      ],
    );
  }

  _buildPaymentView() {
    return Container(
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child:
            Consumer<PaymentMethodSerivce>(builder: (context, prowider, child) {
          if (prowider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ThemeClass.blueColor,
              ),
            );
          }

          if (prowider.isError) {
            return Center(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Provider.of<PaymentMethodSerivce>(context, listen: false)
                          .getPaymentMethod();
                    },
                    icon: Icon(
                      Icons.restart_alt_outlined,
                      size: 40,
                      color: ThemeClass.blueColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(prowider.errorMessage)
                ],
              ),
            );
          }

          if (prowider.paymentDataList != null &&
              prowider.paymentDataList!.isNotEmpty) {
            return _buildPaymentCart(prowider.paymentDataList);
          } else {
            return Center(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Provider.of<PaymentMethodSerivce>(context, listen: false)
                          .getPaymentMethod();
                    },
                    icon: Icon(
                      Icons.restart_alt_outlined,
                      size: 40,
                      color: ThemeClass.blueColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Data Not Found!")
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildPaymentCart(List<PaymentDataModel>? paymentMethods) {
    return Column(
      children: paymentMethods!
          .map((e) => _buildPaymentListTile(e, paymentMethods))
          .toList(),
    );
  }

  Column _buildPaymentListTile(
      PaymentDataModel data, List<PaymentDataModel>? paymentMethods) {
    var index = paymentMethods!.indexOf(data);
    bool isLast = paymentMethods.length - 1 == index;
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
        !isLast ? _buildDivider() : SizedBox()
      ],
    );
  }

  Align _buildBottomButton() {
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
            if (radioPaymentGroupValue == "paymentRadioGP") {
              showToast("Please select payment method");
            } else {
              if (widget.moduleView == 1) {
                _confirm();
              } else if (widget.moduleView == 2) {
                _confirmSuscriptionPay();
              } else {
                _confirmDiet();
              }
            }
          },
        ),
      ),
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

  _buildbottomAmountSubcription() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: Column(
          children: [
            _buildBottomAmountListTile(false, "Item Total (MRP)",
                "₹${widget.resturentData!.itemTotal.toString()}"),
            _buildBottomAmountListTile(false, "Restaurant Subscription Charges",
                "₹${widget.resturentData!.healuCharges.toString()}"),
            _buildBottomAmountListTile(false, "Delivery Charge",
                "+ ₹${widget.resturentData!.deliveryFee.toString()}"),
            //
            _buildBottomAmountListTile(false, "GST 5%", "+ ₹${widget.tax}"),
            _buildDivider(),
            _buildBottomAmountListTile(true, "Payable Amount",
                "₹${widget.resturentData!.grandTotal.toString()}"),
            _buildDivider(),
          ],
        ),
      ),
    );
  }

  Container _buildbottomAmount() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: Column(
          children: [
            _buildBottomAmountListTile(false, "GST 18%", "+ ₹${widget.tax}"),
            _buildDivider(),
            _buildBottomAmountListTile(true, "Payable Amount",
                "₹${widget.payableAmount != null ? widget.payableAmount.toString() : ""}"),
            _buildDivider(),
          ],
        ),
      ),
    );
  }

  Padding _buildBottomAmountListTile(bool isDark, String title, String title2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, left: 10, right: 10),
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

  _buildYourItemValueSubcription() {
    return Container(
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildItemListTile(
                "Name",
                widget.resturentData != null
                    ? widget.resturentData!.title.toString()
                    : ""),
            _buildItemListTile(
                "Days",
                widget.resturentData != null
                    ? widget.resturentData!.days.toString()
                    : ""),
          ],
        ),
      ),
    );
  }

  _buildYourItemValueDiet() {
    return Container(
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildItemListTile(
                "Name",
                widget.dietPlan != null
                    ? widget.dietPlan!.title.toString()
                    : ""),
            widget.dietPlan!.days != null
                ? _buildItemListTile(
                    "Days",
                    widget.dietPlan!.days != null
                        ? widget.dietPlan!.days.toString()
                        : "")
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Container _buildYourItemValue() {
    return Container(
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildItemListTile(
                "Name", widget.name != null ? widget.name.toString() : ""),
            _buildItemListTile("Date",
                widget.date != null ? getddmmyyyy(widget.date.toString()) : ""),
            _buildItemListTile(
                "Time",
                widget.time != null
                    ? time24to12Format(widget.time.toString())
                    : ""),
            Divider(),
            _buildItemListTile("Charges",
                widget.chanrges != null ? widget.chanrges.toString() : ""),
          ],
        ),
      ),
    );
  }

  Padding _buildItemListTile(String title, String value) {
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
            value,
            style: TextStyle(
              fontSize: 12,
              color: ThemeClass.blackColor,
              fontWeight: FontWeight.w500,
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

  _confirmDiet() async {
    EasyLoading.show();

    try {
      String memberid = "";
      var familyPro = Provider.of<FamilyMemberService>(context, listen: false);
      if (familyPro.isSelectFamilyMember) {
        memberid = familyPro.currentFamilyMember!.id.toString();
      }
      Map<String, String> queryParameters = widget.queryParameters!;

      Map<String, String> tempdata1 = {
        "payment_method_id": radioPaymentGroupValue.toString(),
      };

      queryParameters.addAll(tempdata1);

      var response = await HttpService.httpPost(
          "purchase_diet_plan", queryParameters,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          EasyLoading.dismiss();

          if (radioPaymentGroupValue == "2") {
            // when select razor pay
            var res2 = await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute<bool>(
                builder: (BuildContext context) =>
                    WebViewScreen(url: res['data']['payment_url'].toString()),
              ),
            );

            if (res2 == true) {
              showToast("Payment Successfully Done.");

              if (widget.module == "Standard") {
                Navigator.pop(context, true);
              } else if (widget.module == "Unconfirmed" ||
                  widget.module == "Customized") {
                Navigator.pop(context, true);
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            } else {
              showToast("Payment Not Done.");
            }
          } else {
            if (widget.module == "Standard") {
              Navigator.pop(context, true);
            } else if (widget.module == "Unconfirmed" ||
                widget.module == "Customized") {
              Navigator.pop(context, true);
            } else {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          }
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

  _confirmSuscriptionPay() async {
    // when select razor pay or other payments
    if (radioPaymentGroupValue == "2") {
      var res2 = await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<bool>(
          builder: (BuildContext context) =>
              WebViewScreen(url: widget.resturentData!.paymentUrl.toString()),
        ),
      );

      if (res2 == true) {
        showToast("Payment Successfully Done.");
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, false);
      }
    }

    if (radioPaymentGroupValue == "3") {
      // wallet
      _payFromWallet();
    }
  }

  _confirm() async {
    EasyLoading.show();
    try {
      BookAppoModel? bookAppoModel = await bookAppo(
          widget.id.toString(),
          widget.date.toString(),
          widget.time.toString(),
          widget.module.toString(),
          context,
          mode: widget.mode.toString(),
          paymentMethodId: radioPaymentGroupValue.toString());
      if (bookAppoModel!.status == "200") {
        EasyLoading.dismiss();
        if (radioPaymentGroupValue == "2") {
          // when select razor pay or other payments
          var res2 = await Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  WebViewScreen(url: bookAppoModel.data.paymentUrl.toString()),
            ),
          );

          if (res2 == true) {
            showToast("Payment Successfully Done.");

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingResultScreen(
                          success: true,
                        )));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingResultScreen(
                          success: false,
                        )));
          }
        } else if (radioPaymentGroupValue == "3") {
          // if wallet balance is not compaired to Amount

          showToast("Payment Successfully Done.");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingResultScreen(
                        success: true,
                      )));
        }
      } else {
        showToast(bookAppoModel.message);
      }
    } catch (e) {
      showToast(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  _payFromWallet() async {
    EasyLoading.show();

    try {
      Map<String, String> queryParameters = {
        "id": widget.resturentData!.id.toString(),
      };

      var response = await HttpService.httpPost(
          "pay-restaurant-subscription", queryParameters,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          showToast(res['message']);
          Navigator.pop(context, true);
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
