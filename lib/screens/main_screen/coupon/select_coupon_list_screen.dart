import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/coupon/coupon_list_model.dart';
import 'package:heal_u/screens/main_screen/coupon/coupon_service.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';

import 'package:provider/provider.dart';

class SelectCouponListScreen extends StatefulWidget {
  SelectCouponListScreen({Key? key}) : super(key: key);

  @override
  State<SelectCouponListScreen> createState() => _SelectCouponListScreenState();
}

class _SelectCouponListScreenState extends State<SelectCouponListScreen> {
  TextEditingController _couponCodeController = TextEditingController();

  bool _isloading = false;
  bool _isError = false;
  String _errorMessage = "";

  @override
  void initState() {
    getdata();
    super.initState();
  }

  getdata() {
    var pro = Provider.of<CouponService>(context, listen: false);
    pro.getCoupons(context);
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
                isClickOnCart: false,
                onCartPress: () {},
                title: "Coupons",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            padding: EdgeInsets.only(
              top: 15,
            ),
            width: width,
            child: _buildMainView(),
          ),
        ),
      ),
    );
  }

  _buildMainView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextFiledWidget(
              hinttext: "Enter Coupon Code",
              radius: 10,
              backColor: ThemeClass.skyblueColor1,
              controllers: _couponCodeController,
              onChange: (value) {
                var pro = Provider.of<CouponService>(context, listen: false);
                pro.filterData(value);
              },
              oniconTap: () {},
              icon: "assets/images/search_icon.png"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            "Coupons",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Consumer<CouponService>(builder: (context, couponProwider, child) {
          if (couponProwider.loading == true) {
            return buildConditionalView(true, "Coupon not found");
          } else {
            if (couponProwider.isError == true) {
              return buildConditionalView(false, couponProwider.errorMessage);
            } else {
              if (couponProwider.couponList != null &&
                  couponProwider.couponList.isNotEmpty) {
                return Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...couponProwider.couponList
                          .map(
                            (e) => _buildCouponDetails(e),
                          )
                          .toList()
                    ],
                  ),
                ));
              } else {
                return buildConditionalView(false, "Coupon not found");
              }
            }
          }
        }),
      ],
    );
  }

  buildConditionalView(bool isloading, text) {
    if (isloading) {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
        child: Center(
          child: CircularProgressIndicator(
            color: ThemeClass.blueColor,
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
        child: Center(
            child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
      );
      ;
    }
  }

  Container _buildCouponDetails(CouponData data) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Image.network(
                    data.image.toString(),
                    height: 36,
                    width: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, data);
                  },
                  child: Text(
                    "Apply",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ThemeClass.blueColor),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              data.title.toString(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ThemeClass.blackColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 0, top: 10, left: 15, right: 15),
            child: Text(
              "Coupon Code : ${data.code}",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: ThemeClass.greyColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10, left: 15, right: 15),
            child: Text(
              "Expires :  ${data.endDate}",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: ThemeClass.greyColor),
            ),
          ),
          _buildDivider(),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: ThemeClass.greyLightColor1,
    );
  }
}
